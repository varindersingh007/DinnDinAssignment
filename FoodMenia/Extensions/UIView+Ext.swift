//
//  UIView+Ext.swift
//  FoodMenia
//
//  Created by Varinder on 06/08/21.
//

import UIKit
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func showShadow(color : UIColor,offset : CGSize,radius : CGFloat)  {
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = 1.0
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.masksToBounds = false
    }
    
    func roundCorner(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func setBorder(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func dumpingAnimation(from: CGFloat, to: CGFloat){
        let spring = CASpringAnimation(keyPath: "transform.scale")
        spring.damping = 1
        spring.fromValue = from
        spring.toValue = to
        spring.duration = spring.settlingDuration
        self.layer.add(spring, forKey: nil)
    }
}
