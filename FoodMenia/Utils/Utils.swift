//
//  Utils.swift
//  FoodMenia
//
//  Created by Varinder on 06/08/21.
//

import UIKit

class Utils: NSObject {
    
    /// shared instance for the whole app
    /// will be used for all the `helper` methods
    static let shared = Utils()
    
    
    var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    var hasNotch: Bool {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
    
    
    /// this will make the intializer `private`
    /// we can't allow the the another initialization
    private override init() {
        super.init()
    }
    
}
