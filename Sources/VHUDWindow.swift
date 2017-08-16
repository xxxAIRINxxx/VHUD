//
//  VHUDWindow.swift
//  VHUD
//
//  Created by xxxAIRINxxx on 2016/08/02.
//  Copyright © 2016 xxxAIRINxxx. All rights reserved.
//

import UIKit

final class VHUDWindow: UIWindow {

    private var hudView: VHUDView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.frame = UIScreen.main.bounds
        self.rootViewController = VHUDViewController()
        self.windowLevel = UIWindowLevelNormal + 500.0
        self.rootViewController?.view.backgroundColor = .clear
        self.backgroundColor = .clear
        
        self.isHidden = true
    }
    
    func show(content: VHUDContent) {
        self.finish()
        
        self.isUserInteractionEnabled = content.isUserInteractionEnabled
        
        let view = VHUDView(inView: self)
        self.hudView = view
        self.hudView?.setContent(content)
        self.hudView?.dismissalHandler = { [weak self] in
            self?.finish()
        }
        
        self.makeKeyAndVisible()
        self.isHidden = false
        self.alpha = 1.0
    }
    
    func updateProgress(_ percentComplete: Double) {
        self.hudView?.updateProgress(percentComplete)
        self.hudView?.updateProgressText(percentComplete)
    }
    
    func finish() {
        self.hudView = nil
        
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
        self.isHidden = true
        self.isUserInteractionEnabled = false
    }
    
    func dismiss(_ duration: TimeInterval, _ deley: TimeInterval? = nil, _ text: String? = nil, _ completion: (() -> Void)? = nil) {
        self.hudView?.dismiss(duration, deley, text, completion)
    }
}
