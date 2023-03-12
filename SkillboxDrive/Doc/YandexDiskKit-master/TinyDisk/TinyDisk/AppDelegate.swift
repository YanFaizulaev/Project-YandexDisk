//
//  AppDelegate.swift
//
//  Copyright (c) 2014-2015, Clemens Auer
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

import UIKit
import YandexDiskKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, DirectoryViewControllerDelegate, UISplitViewControllerDelegate {

    let clientId = "bdfb621d6c214f7ba090f8d9ae9ec6d9" // OAuth client id
    var token : String? {
        didSet {
            disk = YandexDisk(token: token ?? "")
        }
    }
    var disk = YandexDisk(token: "")

    var window: UIWindow?
    var svc: UISplitViewController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        token = loadToken()

        if let launchURL = launchOptions?[UIApplicationLaunchOptionsURLKey] as? NSURL {
            handleURL(launchURL)
        }

        svc = UISplitViewController()
        let rootVC = UINavigationController(rootViewController:getSuitableRootViewController())
        let nfsVC = NoFileSelectedViewController()
        nfsVC.navigationItem.leftBarButtonItem = svc.displayModeButtonItem()
        nfsVC.navigationItem.leftItemsSupplementBackButton = true
        let detailVC = UINavigationController(rootViewController: nfsVC)

        svc.delegate = self
        svc.viewControllers = [ rootVC, detailVC ]

        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = svc
        window?.makeKeyAndVisible()

        return true
    }

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        if let vc = (secondaryViewController as? UINavigationController)?.topViewController as? NoFileSelectedViewController {
            return true
        }
        return false
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        if handleURL(url) {
            let rootVC = getSuitableRootViewController()
            let navVC = UINavigationController(rootViewController: rootVC)
            let nfsVC = NoFileSelectedViewController()
            nfsVC.navigationItem.leftBarButtonItem = svc.displayModeButtonItem()
            nfsVC.navigationItem.leftItemsSupplementBackButton = true
            let detailVC = UINavigationController(rootViewController: nfsVC)
            svc = UISplitViewController()
            svc.delegate = self
            svc.viewControllers = [navVC, detailVC]
            window?.rootViewController = svc
            return true
        }
        return false
    }

    func directoryViewController(dirController:DirectoryViewController!, didSelectFileWithURL fileURL: NSURL?, resource:YandexDiskResource) -> Void {
        println("Chooosen: \(resource.path)")
        if let itemController = ItemViewController(disk: disk, resource: resource) {
            itemController.navigationItem.leftBarButtonItem = svc.displayModeButtonItem()
            itemController.navigationItem.leftItemsSupplementBackButton = true
            let navVC = UINavigationController(rootViewController: itemController)
            svc.showDetailViewController(navVC, sender: self)
        }
    }

    func handleURL(url: NSURL) -> Bool {
        var querydict : [String: String] = [:]

        if let fragment = url.fragment {
            for tuple in fragment.componentsSeparatedByString("&") {
                let nv = tuple.componentsSeparatedByString("=") as [NSString]

                switch (nv[0], nv[1]) {
                case (let name, let value):
                    querydict[name as! String] = value as? String
                default:
                    break
                }
            }
            token = querydict["access_token"]
            if let token = token {
                saveToken(token)
            }
            return true
        }
        return false
    }

    func logout() {
        token = nil
        deleteToken()

        let navVC = UINavigationController(rootViewController: LoginViewController(clientId: clientId))
        let nfsVC = NoFileSelectedViewController()
        nfsVC.navigationItem.leftBarButtonItem = svc.displayModeButtonItem()
        nfsVC.navigationItem.leftItemsSupplementBackButton = true
        let detailVC = UINavigationController(rootViewController: nfsVC)
        svc = UISplitViewController()
        svc.delegate = self
        svc.viewControllers = [navVC, detailVC]
        window?.rootViewController = svc
    }

    func getSuitableRootViewController() -> UIViewController {
        if token != nil {
            if let rootDirectory = DirectoryViewController(disk: disk) {
                rootDirectory.delegate = self
                rootDirectory.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logout")

                return rootDirectory
            }
        }
        return LoginViewController(clientId: clientId)
    }

}

extension AppDelegate { // keychain related
    private func saveToken(token: String) {
        if let data = token.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {

            var keyChainQuery = NSMutableDictionary()
            keyChainQuery[kSecClass as NSString] = kSecClassGenericPassword
            keyChainQuery[kSecAttrService as NSString] = clientId
            keyChainQuery[kSecValueData as NSString] = data

            SecItemAdd(keyChainQuery, nil)
        }
    }

    private func loadToken() -> String? {
        var keyChainQuery = NSMutableDictionary()
        keyChainQuery[kSecClass as NSString] = kSecClassGenericPassword
        keyChainQuery[kSecAttrService as NSString] = clientId
        keyChainQuery[kSecReturnData as NSString] = true
        keyChainQuery[kSecMatchLimit as NSString] = kSecMatchLimitOne
        keyChainQuery[kSecUseOperationPrompt as NSString] = "Authenticate to log in!"

        var extractedData: Unmanaged<AnyObject>? = nil

        if SecItemCopyMatching(keyChainQuery, &extractedData) != errSecSuccess {
            return nil
        }

        let opaque = extractedData?.toOpaque()
        let contentsOfKeychain: String?

        if let opaque = opaque {
            let retrievedData = Unmanaged<NSData>.fromOpaque(opaque).takeUnretainedValue()
            // Convert the data retrieved from the keychain into a string
            contentsOfKeychain = NSString(data: retrievedData, encoding: NSUTF8StringEncoding) as? String
        } else {
            contentsOfKeychain = nil
        }
        
        return contentsOfKeychain
    }

    private func deleteToken() {
        var keyChainQuery = NSMutableDictionary()
        keyChainQuery[kSecClass as NSString] = kSecClassGenericPassword
        keyChainQuery[kSecAttrService as NSString] = clientId

        SecItemDelete(keyChainQuery)
    }
}

