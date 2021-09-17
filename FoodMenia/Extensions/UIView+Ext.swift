//
//  UIView+Ext.swift
//  FoodMenia
//
//  Created by Varinder on 06/08/21.
//

import UIKit
extension UIView {
    
    /// for setting the view round corner
    /// - Parameters:
    ///   - corners: `UIRectCornr this is the four corner types , leftTop, rightTop, bottomRight, BottomLeft
    ///   - radius: this is the `CGFloat` value for the view corner radius
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    
    /// make a shodow to view
    /// - Parameters:
    ///   - color: this must be `uicolor` ,we will conver it to `cgcolor` and asign it to view layer
    ///   - offset: offSet is a `CGSize` for the shaoe width/height
    ///   - radius: radius for shadow `blurNess`
    func showShadow(color : UIColor,offset : CGSize,radius : CGFloat)  {
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = 1.0
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.masksToBounds = false
    }
    
    
    /// to setting the four round corner
    /// - Parameter radius: radius will be the `cgfloat` value
    func roundCorner(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    
    /// for setting the boarder to the view
    /// - Parameters:
    ///   - width: will be the `Cgfloat` value to the view border width
    ///   - color: this will be the `UIColor` to set the boarder color
    func setBorder(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    
    /// dumping Animation
    /// - Parameters:
    ///   - from: from `CGFload` value where we can start our animation
    ///   - to: to will be `CGFloat` value
    func dumpingAnimation(from: CGFloat, to: CGFloat){
        let spring = CASpringAnimation(keyPath: "transform.scale")
        spring.damping = 1
        spring.fromValue = from
        spring.toValue = to
        spring.duration = spring.settlingDuration
        self.layer.add(spring, forKey: nil)
    }
}
