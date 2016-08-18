//
//  VHUDViewController.swift
//  VHUD
//
//  Created by xxxAIRINxxx on 2016/08/02.
//  Copyright © 2016 xxxAIRINxxx. All rights reserved.
//

import UIKit

final class VHUDViewController: UIViewController {
    
    private var appRootVC: UIViewController? {
        return  UIApplication.shared.delegate?.window??.rootViewController
    }
    
    override var supportedInterfaceOrientations:  UIInterfaceOrientationMask {
        return self.appRootVC?.supportedInterfaceOrientations ?? .portrait
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.presentingViewController?.preferredStatusBarStyle ?? UIApplication.shared.statusBarStyle
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.presentingViewController?.prefersStatusBarHidden ?? UIApplication.shared.isStatusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return self.appRootVC?.preferredStatusBarUpdateAnimation ?? .none
    }
    
    override var shouldAutorotate: Bool {
        return self.appRootVC?.shouldAutorotate ?? false
    }
}
