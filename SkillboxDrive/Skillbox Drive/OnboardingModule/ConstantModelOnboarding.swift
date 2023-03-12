//
//  ConstantModelOnboarding.swift
//  Skillbox Drive
//
//  Created by Bandit on 16.02.2023.
//

import UIKit

protocol ModelProtocol {
    
    func setPages() -> [UIViewController]

}

class ConstantModelOnboarding: ModelProtocol {
    
    func setPages() -> [UIViewController] {
        var list: [UIViewController] = []
        list.append(ViewOnboarding(imageName: "Group7",
                                   subtitleText: Constans.Text.onbordingFirstLabel))
        list.append(ViewOnboarding(imageName: "Group9",
                                   subtitleText: Constans.Text.onbordingSecondLabel))
        list.append(ViewOnboarding(imageName: "Group10",
                                   subtitleText: Constans.Text.onbordingThirdLabel))
        return list
    }
    
    
    static var pages: [UIViewController] {
        var list: [UIViewController] = []
        list.append(ViewOnboarding(imageName: "Group7",
                                   subtitleText: Constans.Text.onbordingFirstLabel))
        list.append(ViewOnboarding(imageName: "Group9",
                                   subtitleText: Constans.Text.onbordingSecondLabel))
        list.append(ViewOnboarding(imageName: "Group10",
                                   subtitleText: Constans.Text.onbordingThirdLabel))
        return list
    }
}
