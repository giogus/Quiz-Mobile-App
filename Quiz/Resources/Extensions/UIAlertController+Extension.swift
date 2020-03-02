//
//  UIAlertController+Extension.swift
//  Quiz
//
//  Created by Gustavo Severo on 09/02/20.
//  Copyright © 2020 Severo. All rights reserved.
//

import UIKit

extension UIAlertController {
    /// Creates a simple alert with the app default style
    ///
    /// - Parameters:
    ///   - title: Title of the UIAlertController
    ///   - message: Message of the UIAlertController
    ///   - buttonText: Action Button text of the UIAlertController
    ///   - handler: Handler to deal with a tap on the UIAlertAction
    
    convenience init (title: String?, message: String?, buttonText: String, handler: @escaping ((UIAlertAction) -> Void)) {
        self.init(title: title, message: message, preferredStyle: .alert)
        addAction(UIAlertAction(title: buttonText, style: .cancel, handler: handler))
    }
}
