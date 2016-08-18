//
//  UIView+AutoLayout.swift
//  VHUD
//
//  Created by xxxAIRINxxx on 2016/07/30.
//  Copyright © 2016 xxxAIRINxxx. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func checkTranslatesAutoresizing(withView: UIView?, toView: UIView?) {
        if withView?.translatesAutoresizingMaskIntoConstraints == true {
            withView?.translatesAutoresizingMaskIntoConstraints = false
        }
        if toView?.translatesAutoresizingMaskIntoConstraints == true {
            toView?.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func addPin(withView:UIView, attribute:NSLayoutAttribute, toView:UIView?, constant:CGFloat) -> NSLayoutConstraint {
        checkTranslatesAutoresizing(withView: withView, toView: nil)
        return addPinConstraint(addView: self, withItem: withView, toItem: toView, attribute: attribute, constant: constant)
    }
    
    func allPin(subView: UIView, _ constant: CGFloat = 0.0) {
        checkTranslatesAutoresizing(withView: subView, toView: nil)
        _ = addPinConstraint(addView: self, withItem: subView, toItem: self, attribute: .top, constant: constant)
        _ = addPinConstraint(addView: self, withItem: subView, toItem: self, attribute: .bottom, constant: constant)
        _ = addPinConstraint(addView: self, withItem: subView, toItem: self, attribute: .left, constant: constant)
        _ = addPinConstraint(addView: self, withItem: subView, toItem: self, attribute: .right, constant: constant)
    }
    
    // MARK: NSLayoutConstraint
    
    func addPinConstraint(addView: UIView, withItem:UIView, toItem:UIView?, attribute:NSLayoutAttribute, constant:CGFloat) -> NSLayoutConstraint {
        return addConstraint(
            addView: addView,
            relation: .equal,
            withItem: withItem,
            withAttribute: attribute,
            toItem: toItem,
            toAttribute: attribute,
            constant: constant
        )
    }
    
    func addWidthConstraint(view: UIView, constant:CGFloat) -> NSLayoutConstraint {
        return addConstraint(
            addView: view,
            relation: .equal,
            withItem: view,
            withAttribute: .width,
            toItem: nil,
            toAttribute: .width,
            constant: constant
        )
    }
    
    func addHeightConstraint(view: UIView, constant:CGFloat) -> NSLayoutConstraint {
        return addConstraint(
            addView: view,
            relation: .equal,
            withItem: view,
            withAttribute: .height,
            toItem: nil,
            toAttribute: .height,
            constant: constant
        )
    }
    
    func addConstraint(addView: UIView, relation: NSLayoutRelation, withItem:UIView, withAttribute:NSLayoutAttribute, toItem:UIView?, toAttribute:NSLayoutAttribute, constant:CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(
            item: withItem,
            attribute: withAttribute,
            relatedBy: relation,
            toItem: toItem,
            attribute: toAttribute,
            multiplier: 1.0,
            constant: constant
        )
        
        addView.addConstraint(constraint)
        
        return constraint
    }
}
