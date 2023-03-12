//
//  PresenterOnboarding.swift
//  Skillbox Drive
//
//  Created by Bandit on 16.02.2023.
//

import UIKit

// MARK: - Protocol Output
protocol PresenterOnboardingProtocolOutput: AnyObject {

//    func pageIndex()
//    func skipButtonIsHidden()
}

// MARK: - Protocol Input
protocol PresenterOnboardingProtocolInput: AnyObject {
    init(view:PresenterOnboardingProtocolOutput, model: ModelProtocol)
    
//    var results: APIResponse? { get set }
//    var images: [UIImage]? {get}
//    func getResult (searchText: String)
}

// MARK: - Presenter
class PresenterOnboarding: PresenterOnboardingProtocolInput {
    
    weak var view: PresenterOnboardingProtocolOutput?
    let model: ModelProtocol!
    
    required init(view: PresenterOnboardingProtocolOutput, model: ModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func setPageIndex(_ index: Int) -> UIViewController {
        let array = model?.setPages()
        guard let vc = array?[index] else { return UIViewController() }
        return vc
    }
    
    
}



