//
//  ViewController.swift
//  Demo
//
//  Created by xxxAIRINxxx on 2016/07/19.
//  Copyright © 2016 xxxAIRINxxx. All rights reserved.
//

import UIKit
import Dispatch
import VHUD

final class ViewController: UIViewController {
    
    @IBOutlet private weak var modeSeg: UISegmentedControl!
    @IBOutlet private weak var shapeSeg: UISegmentedControl!
    @IBOutlet private weak var styleSeg: UISegmentedControl!
    @IBOutlet private weak var backgroundSeg: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func tapLoop() {
        var content = VHUDContent(.loop(0.5))
        
        switch shapeSeg.selectedSegmentIndex {
        case 0:
            content.shape = .circle
        case 1:
            content.shape = .round
        default:
            break
        }
        
        switch styleSeg.selectedSegmentIndex {
        case 0:
            content.style = .light
        case 1:
            content.style = .dark
        case 2:
            content.style = .blur(.light)
        default:
            break
        }
        
        switch backgroundSeg.selectedSegmentIndex {
        case 0:
            content.background = .none
        case 1:
            content.background = .color(#colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 0.7))
        case 2:
            content.background = .blur(.dark)
        default:
            break
        }
        
        switch modeSeg.selectedSegmentIndex {
        case 0:
            content.mode = .loop(3)
            content.loadingText = "Loading.."
            content.completionText = "Finish!"
            VHUD.show(content)
            
            GCD.dispatch(type: .after(second: 3.0, queue: .background)) {
                GCD.dispatch(type: .async(queue: .main)) {
                    VHUD.dismiss(1.0, 1.0)
                }
            }
        case 1:
            content.mode = .duration(3, dismissDeley: 1.0)
            content.completionText = "Finish!"
            VHUD.show(content)
        case 2:
            content.mode = .percentComplete
            content.completionText = "Finish!"
            VHUD.show(content)
            
            let queue = DispatchQueue(label: "queue")
            var p: CGFloat = 0.0
            for _ in 0..<100 {
                p += 0.01
                let c = p
                GCD.dispatch(type: .after(second: Double(c * 3.0), queue: .cosutom(queue: queue))) {
                    GCD.dispatch(type: .async(queue: .main)) {
                        VHUD.updateProgress(c)
                        
                        if c >= 1.0 {
                            VHUD.dismiss(1.0, 1.0)
                        }
                    }
                }
            }
        default:
            break
        }
    }
}

