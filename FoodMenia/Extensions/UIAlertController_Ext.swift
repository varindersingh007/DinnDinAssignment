//
//  UIAlertController_Ext.swift
//  FoodMenia
//
//  Created by Varinder on 07/08/21.
//

import UIKit

extension UIAlertController {
    /// - to show `alert` message
    /// - Parameters:
    ///  - title: this will be title for the alert
    ///  - actions: includes all the actions that needs to show to user
    ///  - handler: has param type `uialertaction`
    ///
    static func showAlert(title: String,message : String,actions: [String:UIAlertAction.Style],from: UIViewController ,_ handler : ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions.sorted(by: {$0.key < $1.key}) {
            let tapAction = UIAlertAction(title: action.key, style: action.value) { (action) in
                handler?(action)
            }
            alertController.addAction(tapAction)
        }
        from.present(alertController, animated: true, completion: nil)
    }
}

