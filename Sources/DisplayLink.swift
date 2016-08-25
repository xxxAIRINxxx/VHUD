//
//  DisplayLink.swift
//  VHUD
//
//  Created by xxxAIRINxxx on 2016/07/26.
//  Copyright © 2016 xxxAIRINxxx. All rights reserved.
//

import Foundation

final class DisplayLink {
    
    var completion: ((Void) -> Void)?
    var updateDurationCallback: ((Double) -> Void)?
    
    var needLoop: Bool = false
    
    let duration: TimeInterval
    private(set) var currentDuration: TimeInterval = 0
    private(set) var percentComplete: Double = 0
    private var displayLink: CADisplayLink?
    
    deinit {
        self.closeLink()
    }
    
    init(_ duration: TimeInterval) {
        self.duration = duration
    }
    
    func reset() {
        self.closeLink()
        self.percentComplete = 0
        self.currentDuration = self.duration
    }
    
    func start() {
        self.reset()
        self.updateDurationCallback?(0)
        self.startLink()
    }
    
    private func startLink() {
        self.displayLink = CADisplayLink(target: self, selector: #selector(self.updateDuration(_:)))
        self.displayLink?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    }
    
    private func closeLink() {
        self.displayLink?.invalidate()
        self.displayLink = nil
    }
    
    @objc private func updateDuration(_ displayLink: CADisplayLink) {
        if self.currentDuration <= 0 { return }
        
        self.currentDuration -= displayLink.duration
        let percentComplete = (self.duration - self.currentDuration) / self.duration
        
        let c = ceil(percentComplete * 100) / 100
        if c != self.percentComplete {
            self.percentComplete = c
            self.updateDurationCallback?(c)
        }
        
        if self.currentDuration <= 0 {
            self.completion?()
            
            if self.needLoop {
                self.start()
            } else {
                self.reset()
            }
        }
    }
}
