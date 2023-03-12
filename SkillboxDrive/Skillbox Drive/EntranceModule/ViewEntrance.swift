//
//  ViewEntrance.swift
//  Skillbox Drive
//
//  Created by Bandit on 18.01.2023.
//

import UIKit
import CoreData

final class ViewEntrance: UIViewController {
    
    private lazy var imageSkillboxLabel: UIImageView = {
        let image = UIImageView()
        image.image = Constans.Image.imageSkillboxDrive
        return image
    }()
    
    private lazy var buttonInput: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = Constans.Color.colorButton
        button.setTitle(Constans.Text.onbordingButtonEnter, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Constans.Fonts.graphik17
        button.addTarget(self, action: #selector(input), for: .touchUpInside)
        return button
        }()
    
    @objc private func input(_ sender: UIButton){
        let vc = TabBarViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(imageSkillboxLabel)
        view.addSubview(buttonInput)
        
        let margins = view.safeAreaLayoutGuide
        
        imageSkillboxLabel.translatesAutoresizingMaskIntoConstraints = false
        imageSkillboxLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageSkillboxLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        imageSkillboxLabel.heightAnchor.constraint(equalToConstant: 168).isActive = true
        imageSkillboxLabel.widthAnchor.constraint(equalToConstant: 189).isActive = true

        buttonInput.translatesAutoresizingMaskIntoConstraints = false
        buttonInput.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 27).isActive = true
        buttonInput.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -27).isActive = true
        buttonInput.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -92).isActive = true
        buttonInput.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}


