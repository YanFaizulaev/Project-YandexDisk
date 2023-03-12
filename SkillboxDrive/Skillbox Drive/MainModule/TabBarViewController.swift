//
//  TabBarViewController.swift
//  Skillbox Drive
//
//  Created by Bandit on 20.01.2023.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTabBarViewController ()
        
//        let blurEffectView = BlurEffectView()
//        view.addSubview(blurEffectView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.userIsLogged == false {
            let requestTokenViewController = AuthViewController()
            requestTokenViewController.modalPresentationStyle = .fullScreen
            requestTokenViewController.modalTransitionStyle = .crossDissolve
            present(requestTokenViewController, animated: true, completion: nil)
        }
    }

    func setupTabBarViewController() {

        let viewController1 = UINavigationController(rootViewController: FirstViewController())
        let viewController2 = UINavigationController(rootViewController: SecondViewController())
        let viewController3 = UINavigationController(rootViewController: ThirdViewController())

        viewController1.title = Constans.Text.profileTitleLabel
        viewController2.title = Constans.Text.lastTitleLabel
        viewController3.title = Constans.Text.allFilesTitleLabel
        
        self.tabBar.backgroundColor = UIColor.white
        self.setViewControllers([viewController1, viewController2, viewController3], animated: true)
        
        guard let items = self.tabBar.items else {
            return
        }

        let images = ["person", "doc", "list.bullet.rectangle.portrait"]
        for x in 0..<items.count {
            items[x].image = UIImage(systemName: images[x])
        }
    }
}

//class BlurEffectView: UIVisualEffectView {
//
//    var animator = UIViewPropertyAnimator(duration: 1, curve: .linear)
//
//    override func didMoveToSuperview() {
//        guard let superview = superview else { return }
//        backgroundColor = .clear
//        frame = superview.bounds //Or setup constraints instead
//        setupBlur()
//    }
//
//    private func setupBlur() {
//        animator.stopAnimation(true)
//        effect = nil
//
//        animator.addAnimations { [weak self] in
//            self?.effect = UIBlurEffect(style: .dark)
//        }
//        animator.fractionComplete = 0.1   //This is your blur intensity in range 0 - 1
//    }
//
//    deinit {
//        animator.stopAnimation(true)
//    }
//}
