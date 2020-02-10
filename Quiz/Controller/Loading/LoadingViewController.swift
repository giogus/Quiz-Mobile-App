//
//  LoadingViewController.swift
//  Quiz
//
//  Created by Gustavo Severo on 09/02/20.
//  Copyright © 2020 Severo. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    // MARK: - Variables -
    static let shared = UIStoryboard(name: "Loading", bundle: nil).instantiateInitialViewController() as? LoadingViewController
    
    // MARK: - IBOutlets -
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var alertView: UIView?
    @IBOutlet weak var backgroundView: UIView?
}
