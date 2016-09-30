//
//  VHUDWindow.swift
//  VHUD
//
//  Created by xxxAIRINxxx on 2016/08/02.
//  Copyright © 2016 xxxAIRINxxx. All rights reserved.
//

import UIKit

final class VHUDWindow: UIWindow {

    private let backgroundView: UIView = UIView()
    private var hudView: VHUDView?
    
    private var link: DisplayLink?
    private var dismissalLink: DisplayLink?
    private var content: VHUDContent?
    
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
        
        self.backgroundView.backgroundColor = .clear
        self.addSubview(self.backgroundView)
        self.allPin(subView: self.backgroundView)
        
        self.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.hudView?.center = center
    }
    
    func show(content: VHUDContent) {
        self.finish()
        
        self.content = content
        self.isUserInteractionEnabled = content.isUserInteractionEnabled
        
        let view = VHUDView()
        self.addSubview(view)
        view.center = self.center
        self.hudView = view
        self.hudView?.setContent(content)
        
        switch content.background {
        case .none:
            self.backgroundView.backgroundColor = .clear
        case .color(let color):
            self.backgroundView.backgroundColor = color
        case .blur(let effecType):
            self.backgroundView.backgroundColor = .clear
            let v = UIVisualEffectView(effect: UIBlurEffect(style: effecType))
            self.backgroundView.addSubview(v)
            self.backgroundView.allPin(subView: v)
        }
        
        switch content.mode {
        case .loop(let interval):
            self.link = DisplayLink(interval)
            self.link?.needLoop = true
        case .duration(let duration, let dismissDeley):
            self.link = DisplayLink(duration)
            self.link?.completion = { [weak self] in
                self?.dismiss(0.5, dismissDeley)
            }
        case .percentComplete:
            break
        }
        
        self.hudView?.setText(text: self.content?.loadingText)
        let needShowProgressText = self.content?.loadingText == nil
        self.link?.updateDurationCallback = { [weak self] percentComplete in
            self?.hudView?.updateProgress(percentComplete)
            if needShowProgressText {
                self?.hudView?.updateProgressText(percentComplete)
            }
        }
        
        self.makeKeyAndVisible()
        self.isHidden = false
        self.alpha = 1.0
        self.link?.start()
    }
    
    func updateProgress(_ percentComplete: Double) {
        self.hudView?.updateProgress(percentComplete)
        self.hudView?.updateProgressText(percentComplete)
    }
    
    func finish() {
        self.hudView?.finish()
        self.hudView?.removeFromSuperview()
        self.hudView = nil
        
        self.link?.reset()
        self.dismissalLink?.reset()
        self.link = nil
        self.dismissalLink = nil
        self.content = nil
        self.backgroundView.subviews.forEach { $0.removeFromSuperview() }
        self.backgroundView.backgroundColor = .clear
        
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
        self.isHidden = true
        self.isUserInteractionEnabled = false
    }
    
    func dismiss(_ duration: TimeInterval, _ deley: TimeInterval? = nil, _ text: String? = nil, _ completion: ((Void) -> Void)? = nil) {
        if self.dismissalLink != nil { return }
        
        self.link?.reset()
        self.hudView?.setText(text: text ?? self.content?.completionText)
        
        if let d = deley {
            self.link = DisplayLink(d)
            self.link?.updateDurationCallback = { [weak self] percentComplete in
                self?.hudView?.finishAllIfNeeded()
            }
            self.link?.completion = { [weak self] in
                self?.dismiss(duration, nil, text, completion)
            }
            self.link?.start()
        } else {
            self.dismissalLink = DisplayLink(duration)
            self.dismissalLink?.updateDurationCallback = { [weak self] percentComplete in
                self?.alpha = CGFloat(1.0 - percentComplete)
            }
            self.dismissalLink?.completion = { [weak self] in
                self?.finish()
                completion?()
            }
            self.dismissalLink?.start()
        }
    }
}
