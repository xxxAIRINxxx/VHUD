//
//  ProgressView.swift
//  VHUD
//
//  Created by xxxAIRINxxx on 2016/07/19.
//  Copyright © 2016 xxxAIRINxxx. All rights reserved.
//

import UIKit
import QuartzCore

// @see http://stackoverflow.com/questions/16192254/why-does-giving-addarcwithcenter-a-startangle-of-0-degrees-make-it-start-at-90-d

final class ProgressView: UIView {
    
    private static let startAngle: Double = 90
    private static let endAngle: Double = 270
    
    var mode: Mode?
    
    var defaultColor: UIColor = .black
    var elapsedColor: UIColor = .lightGray
    
    var lineWidth: CGFloat = 30.0 {
        didSet { setNeedsDisplay() }
    }
    
    var loopLineWidth: Double = 25.0 {
        didSet { setNeedsDisplay() }
    }
    
    var radius: CGFloat {
        return (self.bounds.width * 0.5) - (self.lineWidth * 0.5) - self.outsideMargin
    }
    
    var outsideMargin: CGFloat = 10.0 {
        didSet { setNeedsDisplay() }
    }
    
    var percentComplete: Double = 0 {
        didSet { setNeedsDisplay() }
    }
  
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        self.backgroundColor = .clear
    }
    
    func finish() {
        self.mode = nil
    }
    
    private func convertAngle(percentComplete: Double) -> Double {
        return percentComplete * 360 - ProgressView.startAngle
    }
    
    private func drawPath(startAngle: Double, endAngle: Double, strokeColor: UIColor) {
        let s = CGFloat(startAngle * M_PI / 180.0)
        let e = CGFloat(endAngle * M_PI / 180.0)
        let art = UIBezierPath(arcCenter: self.center, radius: self.radius, startAngle: s, endAngle: e, clockwise: true)
        art.lineWidth = self.lineWidth
        art.setLineDash([ CGFloat(M_PI * Double(self.radius * 0.01 * 0.225)), CGFloat(M_PI * Double(self.radius * 0.01 * 0.7545)) ],
                        count: 2,
                        phase: 0)
        strokeColor.setStroke()
        art.stroke()
    }
    
    private func draw(percentComplete: Double) {
        guard let m = self.mode else { return }
        
        if case Mode.loop = m {
            let current = self.convertAngle(percentComplete: percentComplete)
            let start = current - self.loopLineWidth
            self.drawPath(startAngle: -ProgressView.startAngle, endAngle: ProgressView.endAngle, strokeColor: self.defaultColor)
            self.drawPath(startAngle: start, endAngle: current, strokeColor: self.elapsedColor)
        } else {
            let start = -ProgressView.startAngle
            let current = self.convertAngle(percentComplete: percentComplete)
            if percentComplete >= 1.0 {
                self.drawPath(startAngle: start, endAngle: ProgressView.endAngle, strokeColor: self.elapsedColor)
            } else {
                self.drawPath(startAngle: -ProgressView.startAngle, endAngle: ProgressView.endAngle, strokeColor: self.defaultColor)
                self.drawPath(startAngle: start, endAngle: current, strokeColor: self.elapsedColor)
            }
        }
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.draw(percentComplete: percentComplete)
    }
}
