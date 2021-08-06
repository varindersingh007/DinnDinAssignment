//
//  ViewController.swift
//  FoodMenia
//
//  Created by Varinder on 06/08/21.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    /// Checks if the view controller’s view is visible for updates or not.
    open var isVisible: Bool { viewIfLoaded?.window != nil }
    
}
