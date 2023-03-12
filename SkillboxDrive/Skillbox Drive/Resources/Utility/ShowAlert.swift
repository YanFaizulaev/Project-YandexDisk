//
//  ShowAlert.swift
//  Skillbox Drive
//
//  Created by Bandit on 22.02.2023.
//

import Foundation

import UIKit
class UtilsShowAlert {
    
    static func showAlertErrorNoInternet(viewcontroller:UIViewController) {
        let alert = UIAlertController(title: Constans.Text.alertNoInternetTitleText, message: Constans.Text.alertNoInternetSubTitleText, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Constans.Text.alertNoInternetButtonTextCancel, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        viewcontroller.present(alert, animated: true, completion: nil)
    }
    
//    static func showAlertErrorFileIsExists(viewcontroller:UIViewController) {
//        let alert = UIAlertController(title: Constans.Text.alertNoInternetTitleText, message: Constans.Text.alertNoInternetSubTitleText, preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: Constans.Text.alertNoInternetButtonTextCancel, style: .cancel, handler: nil)
//        alert.addAction(cancelAction)
//        viewcontroller.present(alert, animated: true, completion: nil)
//    }
    
//    static func showAlertAction(viewcontroller: UIViewController, titleAlert: String, messageAlert: String,titleButtonOne: String, styleButtonOne: UIAlertAction.Style, actionOne: @escaping () -> Void,titleButtonTwo: String, styleButtonTwo: UIAlertAction.Style, actionTwo: @escaping () -> Void) {
//        let alert = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: .alert)
//        let actionOne = UIAlertAction(title: titleButtonOne, style: styleButtonOne, handler: { _ in
//            actionOne()
//        })
//        let actionTwo = UIAlertAction(title: titleButtonTwo, style: styleButtonTwo, handler: { _ in
//            actionTwo()
//        })
//        alert.addAction(actionOne)
//        alert.addAction(actionTwo)
//        viewcontroller.present(alert, animated: true, completion: nil)
//    }
}
