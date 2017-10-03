//
//  VHUDView.swift
//  VHUD
//
//  Created by xxxAIRINxxx on 2016/07/19.
//  Copyright © 2016 xxxAIRINxxx. All rights reserved.
//

import UIKit

final class VHUDView: UIView {
    
    static let size: CGSize = CGSize(width: 180, height: 180)
    
    var dismissalHandler: (() -> Void)?
    
    private static let labelFont: UIFont = UIFont(name: "HelveticaNeue-Thin", size: 26)!
    private static let labelInset: CGFloat = 44.0
    
    private let label: UILabel = UILabel()
    private let progressView: ProgressView = ProgressView()
    private var blurView: UIVisualEffectView?
    
    private var progressLink: DisplayLink?
    private var dismissalLink: DisplayLink?
    
    private(set) var content: VHUDContent?
    
    init(inView: UIView) {
        super.init(frame: inView.bounds)
        
        inView.addSubview(self)
        inView.allPin(subView: self)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.progressView.clipsToBounds = true
        self.addSubview(self.progressView)
        self.setCenterLayoutConstraint(self.progressView)
        
        self.label.textAlignment = .center
        self.label.backgroundColor = .clear
        self.label.adjustsFontSizeToFitWidth = true
        self.label.font = VHUDView.labelFont
        self.progressView.addSubview(self.label)
        _ = self.addPin(withView: self.label, attribute: .top, toView: self.progressView, constant: VHUDView.labelInset)
        _ = self.addPin(withView: self.label, attribute: .left, toView: self.progressView, constant: VHUDView.labelInset)
        _ = self.addPin(withView: self.label, attribute: .right, toView: self.progressView, constant: -VHUDView.labelInset)
        _ = self.addPin(withView: self.label, attribute: .bottom, toView: self.progressView, constant: -VHUDView.labelInset)
    }
    
    func setContent(_ content: VHUDContent) {
        self.content = content
        
        switch content.mode {
        case .loop(let interval):
            self.progressLink = DisplayLink(interval)
            self.progressLink?.needLoop = true
        case .duration(let duration, let dismissDeley):
            self.progressLink = DisplayLink(duration)
            self.progressLink?.completion = { [weak self] in
                self?.dismiss(0.5, dismissDeley)
            }
        case .percentComplete:
            break
        }
        
        switch content.shape {
        case .round:
            self.progressView.layer.cornerRadius = 8.0
        case .circle:
            self.progressView.layer.cornerRadius = VHUDView.size.width * 0.5
        case .custom(let closure):
            closure(self.progressView)
        }
        
        switch content.style {
        case .dark:
            self.progressView.backgroundColor = .black
            self.label.textColor = .white
            self.progressView.defaultColor = content.lineDefaultColor ?? .darkGray
            self.progressView.elapsedColor = content.lineElapsedColor ?? .white
        case .light:
            self.progressView.backgroundColor = .white
            self.label.textColor = .black
            self.progressView.defaultColor = content.lineDefaultColor ?? .lightGray
            self.progressView.elapsedColor = content.lineElapsedColor ?? .darkGray
        case .blur(let effecType):
            self.label.textColor = .white
            self.progressView.defaultColor = content.lineDefaultColor ?? .darkGray
            self.progressView.elapsedColor = content.lineElapsedColor ?? .white

            let v = UIVisualEffectView(effect: UIBlurEffect(style: effecType))
            v.clipsToBounds = true
            self.addSubview(v)
            self.sendSubview(toBack: v)
            v.layer.cornerRadius = self.progressView.layer.cornerRadius
            self.setCenterLayoutConstraint(v)
            self.blurView = v
        }
        
        switch content.background {
        case .none:
            self.backgroundColor = .clear
        case .color(let color):
            self.backgroundColor = color
        case .blur(let effecType):
            self.backgroundColor = .clear
            let v = UIVisualEffectView(effect: UIBlurEffect(style: effecType))
            self.addSubview(v)
            self.sendSubview(toBack: v)
            self.allPin(subView: v)
        }
        
        self.label.font = content.labelFont ?? VHUDView.labelFont
        self.progressView.mode = content.mode
        
        self.setText(text: content.loadingText)
        let needShowProgressText = content.mode == .percentComplete
        self.progressLink?.updateDurationCallback = { [weak self] percentComplete in
            self?.updateProgress(percentComplete)
            if needShowProgressText {
                self?.updateProgressText(percentComplete)
            }
        }
        
        self.progressLink?.start()
    }
    
    func updateProgress(_ percentComplete: Double) {
        var p = percentComplete
        if p < 0.0 { p = 0.0 }
        if p > 1.0 { p = 1.0 }
        self.progressView.percentComplete = p
    }
    
    func setText(text: String?) {
        self.label.text = text
    }
    
    func updateProgressText(_ percentComplete: Double) {
        var p = percentComplete
        if p < 0.0 { p = 0.0 }
        if p > 1.0 { p = 1.0 }
        self.label.text = Int(p * 100).description + "%"
    }
    
    private func setCenterLayoutConstraint(_ view: UIView) {
        self.pinCenter(subView: view)
        _ = view.addWidthConstraint(view: view, constant: VHUDView.size.width)
        _ = view.addHeightConstraint(view: view, constant: VHUDView.size.height)
    }
    
    private func finishAllIfNeeded() {
        self.progressView.outsideMargin -= 0.14
    }
    
    private func finish() {
        self.blurView?.removeFromSuperview()
        self.backgroundColor = .clear
        self.progressView.backgroundColor = .clear
        self.progressView.finish()
        self.label.text = nil
        self.removeFromSuperview()
    }
    
    func dismiss(_ duration: TimeInterval, _ deley: TimeInterval? = nil, _ text: String? = nil, _ completion: (() -> Void)? = nil) {
        if self.dismissalLink != nil { return }
        
        self.progressLink?.reset()
        self.setText(text: text ?? self.content?.completionText)
        
        if let d = deley {
            self.dismissalLink = DisplayLink(d)
            self.dismissalLink?.updateDurationCallback = { [weak self] percentComplete in
                self?.finishAllIfNeeded()
            }
            self.dismissalLink?.completion = { [weak self] in
                self?.dismissalLink = nil
                self?.dismiss(duration, nil, text, completion)
            }
            self.dismissalLink?.start()
        } else {
            self.dismissalLink = DisplayLink(duration)
            self.dismissalLink?.updateDurationCallback = { [weak self] percentComplete in
                self?.alpha = CGFloat(1.0 - percentComplete)
            }
            self.dismissalLink?.completion = { [weak self] in
                self?.dismissalHandler?()
                self?.finish()
                completion?()
            }
            self.dismissalLink?.start()
        }
    }
}
