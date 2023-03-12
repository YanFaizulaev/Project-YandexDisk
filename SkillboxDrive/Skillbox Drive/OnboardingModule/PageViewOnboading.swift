//
//  PageViewOnboading.swift
//  Skillbox Drive
//
//  Created by Bandit on 15.02.2023.
//

import UIKit

extension PageViewOnboading: PresenterOnboardingProtocolOutput {

}

class PageViewOnboading: UIPageViewController {

    // MARK: - Model and Presenter
    var pages = ConstantModelOnboarding.pages
    var presenter: PresenterOnboarding!

    // MARK: - View
    private lazy var skipButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(Constans.Text.onbordingButtonSkip, for: .normal)
        button.setTitleColor(Constans.Color.colorButton, for: .normal)
        button.titleLabel?.font = Constans.Fonts.graphik17
        button.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        return button
    }()

    private lazy var nextButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.cornerRadius = 10
        button.backgroundColor = Constans.Color.colorButton
        button.setTitle(Constans.Text.onbordingButtonNext, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Constans.Fonts.graphik17
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        return button
    }()

    let pageControl = UIPageControl()

//    private lazy var pageControl: UIPageControl = {
//        let page = UIPageControl()
//        page.currentPageIndicatorTintColor = .blue
//        page.pageIndicatorTintColor = .systemGray2
//        page.numberOfPages = pages.count
//        page.currentPage = initialPage
//        return page
//    }()

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        dataSource = self
        delegate = self

        setup()
        stylePageControl()
        autoLayout()
    }
}

extension PageViewOnboading {

    // MARK: - Установка начального экрана
    func setup() {
        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
    }

    // MARK: - PageControl
    func stylePageControl() {
        pageControl.currentPageIndicatorTintColor = .blue
        pageControl.pageIndicatorTintColor = .systemGray2
        pageControl.numberOfPages = pages.count
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
    }

    // MARK: - Layout
    func autoLayout() {
        view.addSubview(skipButton)
        view.addSubview(pageControl)
        view.addSubview(nextButton)

        let margins = view.safeAreaLayoutGuide

        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0).isActive = true
        skipButton.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 16).isActive = true

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -183).isActive = true


        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 27).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -27).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -92).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

// MARK: - DataSource

extension PageViewOnboading: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }

        if currentIndex == 0 {
            return nil              // wrap last
        } else {
            return pages[currentIndex - 1]  // go previous
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }

        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]  // go next
        } else {
            return nil              // wrap first
        }
    }
}

// MARK: - Delegates

extension PageViewOnboading: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }

        pageControl.currentPage = currentIndex
        skipButtonIsHidden()
    }

    private func skipButtonIsHidden() {
        let lastPage = pageControl.currentPage == pages.count - 1
        if lastPage {
            skipButton.isHidden = true
        } else {
            skipButton.isHidden = false
        }
    }
}

// MARK: - Actions

extension PageViewOnboading {

    @objc func pageControlTapped(_ sender: UIPageControl) {
        goToSpecificPage(index: sender.currentPage, ofViewControllers: pages)
        skipButtonIsHidden()
    }

    @objc func skipTapped(_ sender: UIButton) {
        let vc = ViewEntrance()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
        UserDefaults.standard.set(true, forKey: KeysUserDefaults.newUser)
    }

    @objc func nextTapped(_ sender: UIButton) {
        let lastPage = pageControl.currentPage == pages.count - 1
        if lastPage {
            let vc = ViewEntrance()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: KeysUserDefaults.newUser)
        } else {
            pageControl.currentPage += 1
            goToNextPage()
            skipButtonIsHidden()
        }
    }
}

// MARK: - Extensions

extension UIPageViewController {

    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }

        setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
    }

//    func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
//        guard let currentPage = viewControllers?[0] else { return }
//        guard let prevPage = dataSource?.pageViewController(self, viewControllerBefore: currentPage) else { return }
//
//        setViewControllers([prevPage], direction: .forward, animated: animated, completion: completion)
//    }

    func goToSpecificPage(index: Int, ofViewControllers pages: [UIViewController]) {
        setViewControllers([pages[index]], direction: .forward, animated: true, completion: nil)
    }
}
