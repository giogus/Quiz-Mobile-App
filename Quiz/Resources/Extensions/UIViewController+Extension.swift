//
//  UIViewController+Extension.swift
//  Quiz
//
//  Created by Gustavo Severo on 09/02/20.
//  Copyright © 2020 Severo. All rights reserved.
//

import UIKit

// MARK: Loading View Logic
extension UIViewController {
    var loadingView: LoadingViewController? {
        return LoadingViewController.shared
    }
    
    func showLoadingView(){
        guard let unwrappedLoadingView = self.loadingView else { return }
        self.add(unwrappedLoadingView)
    }
    
    func hideLoadingView() {
        guard let unwrappedLoadingView = self.loadingView else { return }
        self.remove(unwrappedLoadingView)
    }
}

// MARK: Add and Remove Child Methods for UIViewController
extension UIViewController {
    func add(_ child: UIViewController) {
        if self.view.subviews.contains(where: { $0 == child.view }) { return }
        child.view.alpha = 0
        UIView.transition(with: child.view, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.view.addSubview(child.view)
            self.view.bringSubviewToFront(child.view)
            child.view.alpha = 1.0
        }, completion: nil)
    }
    
    func remove(_ child: UIViewController) {
        if !self.view.subviews.contains(where: { $0 == child.view }) { return }
        UIView.transition(with: child.view, duration: 0.25, options: .transitionCrossDissolve, animations: {
            child.view.alpha = 0
        }, completion: { _ in
            child.view.removeFromSuperview()
        })
    }
}
