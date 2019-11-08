//
//  OnboardingViewController.swift
//  Donorhin
//
//  Created by Ni Made Ananda Ayu Permata on 08/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class OnboardingViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        if let firstViewController = orderedViewController.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        self.delegate = self
        configurePageControl()
    
    }
    
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: Int(UIScreen.main.bounds.maxY - 50), width: Int(UIScreen.main.bounds.width), height: 50))
        pageControl.numberOfPages = orderedViewController.count
        pageControl.currentPage = 0
        pageControl.tintColor = .red
        pageControl.pageIndicatorTintColor = .black
        pageControl.currentPageIndicatorTintColor = .red
        self.view.addSubview(pageControl)
    }
    
    private lazy var orderedViewController: [UIViewController] = {
        return [self.newViewController(number: "1"),self.newViewController(number: "2"), self.newViewController(number: "3"),self.newViewController(number: "4")]
    }()
    
    private func newViewController(number:String) -> UIViewController{
        return UIStoryboard (name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "Page\(number)")
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewController.lastIndex(of: pageContentViewController)!
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewController.lastIndex(of: viewController)
            else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewController.count > previousIndex else {
            return nil
        }
        
        return orderedViewController[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewController.lastIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewController.count
        
        guard orderedViewControllersCount != nextIndex && orderedViewControllersCount > nextIndex else {
            return  nil
        }
        return orderedViewController[nextIndex]
        
    }
    
    
}



