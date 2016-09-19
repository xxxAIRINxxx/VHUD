//
//  VHUDView.swift
//  VHUD
//
//  Created by xxxAIRINxxx on 2016/07/19.
//  Copyright © 2016 xxxAIRINxxx. All rights reserved.
//

import UIKit

final class VHUDView: UIView {
    
    private static let size: CGSize = CGSize(width: 180, height: 180)
    private static let labelFont: UIFont = UIFont(name: "HelveticaNeue-Thin", size: 26)!
    private static let labelInset: CGFloat = 44.0
    
    private let label: UILabel = UILabel()
    private let progressView: ProgressView = ProgressView()
    private var blurView: UIVisualEffectView?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        self.bounds.size = VHUDView.size
        self.clipsToBounds = true
        
        self.label.textAlignment = .center
        self.label.backgroundColor = .clear
        self.label.adjustsFontSizeToFitWidth = true
        self.label.font = VHUDView.labelFont
        self.addSubview(self.label)
        _ = self.addPin(withView: self.label, attribute: .top, toView: self, constant: VHUDView.labelInset)
        _ = self.addPin(withView: self.label, attribute: .left, toView: self, constant: VHUDView.labelInset)
        _ = self.addPin(withView: self.label, attribute: .right, toView: self, constant: -VHUDView.labelInset)
        _ = self.addPin(withView: self.label, attribute: .bottom, toView: self, constant: -VHUDView.labelInset)

        self.addSubview(self.progressView)
        self.allPin(subView: self.progressView)
    }
    
    func setContent(_ content: VHUDContent) {
        switch content.shape {
        case .round:
            self.layer.cornerRadius = 8
        case .circle:
            self.layer.cornerRadius = self.bounds.width * 0.5
        case .custom(let closure):
            closure(self)
        }
        
        switch content.style {
        case .dark:
            self.backgroundColor = .black
            self.label.textColor = .white
            self.progressView.defaultColor = content.lineDefaultColor ?? .darkGray
            self.progressView.elapsedColor = content.lineElapsedColor ?? .white
        case .light:
            self.backgroundColor = .white
            self.label.textColor = .black
            self.progressView.defaultColor = content.lineDefaultColor ?? .lightGray
            self.progressView.elapsedColor = content.lineElapsedColor ?? .darkGray
        case .blur(let effecType):
            self.label.textColor = .white
            self.progressView.defaultColor = content.lineDefaultColor ?? .darkGray
            self.progressView.elapsedColor = content.lineElapsedColor ?? .white
            let v = UIVisualEffectView(effect: UIBlurEffect(style: effecType))
            self.insertSubview(v, belowSubview: self.label)
            self.allPin(subView: v)
            self.blurView = v
        }
        
        self.label.font = content.labelFont ?? VHUDView.labelFont
        self.progressView.mode = content.mode
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
    
    func finishAllIfNeeded() {
        self.progressView.outsideMargin -= 0.14
    }
    
    func finish() {
        self.blurView?.removeFromSuperview()
        self.backgroundColor = .clear
        self.progressView.backgroundColor = .clear
        self.progressView.finish()
        self.label.text = nil
    }
}
