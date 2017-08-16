//
//  VHUD.swift
//  VHUD
//
//  Created by xxxAIRINxxx on 2016/07/19.
//  Copyright © 2016 xxxAIRINxxx. All rights reserved.
//

import Foundation
import UIKit

public enum Mode {
    case loop(TimeInterval)
    case duration(TimeInterval, dismissDeley: TimeInterval?)
    case percentComplete
    
    public static func ==(lhs: Mode, rhs: Mode) -> Bool {
        switch (lhs, rhs) {
        case (.loop(_), .loop(_)): return true
        case (.duration(_), .duration(_)): return true
        case (.percentComplete, .percentComplete): return true
        default: return false
        }
    }
}

public enum Shape {
    case round
    case circle
    case custom((UIView) -> Void)
}

public enum Style {
    case light
    case dark
    case blur(UIBlurEffectStyle)
}

public enum Background {
    case none
    case color(UIColor)
    case blur(UIBlurEffectStyle)
}

public struct VHUDContent {
    
    public static var defaultShape: Shape = .circle
    public static var defaultStyle: Style = .blur(.light)
    public static var defaultBackground: Background = .none
    public static var defaultLoadingText: String? = nil
    public static var defaultCompletionText: String? = nil
    public static var defaultIsUserInteractionEnabled: Bool = true
    
    public var mode: Mode
    public var shape: Shape
    public var style: Style
    public var background: Background
    
    public var loadingText: String? = nil
    public var completionText: String? = nil
    
    public var isUserInteractionEnabled: Bool = true
    
    public var labelFont: UIFont? = nil
    public var lineDefaultColor: UIColor? = nil
    public var lineElapsedColor: UIColor? = nil
    
    public init(_ mode: Mode, _ style: Shape? = nil, _ theme: Style? =  nil, _ background: Background? = nil) {
        self.mode = mode
        self.shape = style ?? VHUDContent.defaultShape
        self.style = theme ?? VHUDContent.defaultStyle
        self.background = background ?? VHUDContent.defaultBackground
        self.loadingText = VHUDContent.defaultLoadingText
        self.completionText = VHUDContent.defaultCompletionText
        self.isUserInteractionEnabled = VHUDContent.defaultIsUserInteractionEnabled
    }
}

public struct VHUD {
    
    private static let window: VHUDWindow = VHUDWindow(frame: CGRect.zero)
    
    fileprivate(set) var content: VHUDContent
    
    fileprivate var hudView: VHUDView?
    
    public init (_ mode: Mode) {
        self.content = VHUDContent(mode)
    }
    
    public static func show(loopInterval: TimeInterval) {
        self.show(VHUDContent(.loop(loopInterval)))
    }
    
    public static func show(duration: TimeInterval, _ dismissDeley: TimeInterval? = nil) {
        self.show(VHUDContent(.duration(duration, dismissDeley: dismissDeley)))
    }
    
    public static func show(_ content: VHUDContent) {
        self.window.show(content: content)
    }
    
    public static func updateProgress(_ percentComplete: CGFloat) {
        self.window.updateProgress(Double(percentComplete))
    }
    
    public static func dismiss(_ duration: TimeInterval, _ deley: TimeInterval? = nil, _ text: String? = nil, _ completion: (() -> Void)? = nil) {
        self.window.dismiss(duration, deley, text, completion)
    }
}

extension VHUD {
    
    public mutating func setShapeStyle(_ shape: Shape) -> VHUD {
        self.content.shape = shape
        return self
    }

    public mutating func setThemeStyle(_ theme: Style) -> VHUD {
        self.content.style = theme
        return self
    }

    public mutating func setBackgroundStyle(_ background: Background) -> VHUD {
        self.content.background = background
        return self
    }
    
    public mutating func setLoadingText(_ text: String) -> VHUD {
        self.content.loadingText = text
        return self
    }
    
    public mutating func setCompletionText(_ text: String) -> VHUD {
        self.content.completionText = text
        return self
    }
    
    public mutating func setLabelFont(_ font: UIFont) -> VHUD {
        self.content.labelFont = font
        return self
    }
    
    public mutating func setUserInteractionEnabled(_ isUserInteractionEnabled: Bool) -> VHUD {
        self.content.isUserInteractionEnabled = isUserInteractionEnabled
        return self
    }
    
    public mutating func setLineDefaultColor(_ color: UIColor) -> VHUD {
        self.content.lineDefaultColor = color
        return self
    }
    
    public mutating func setLineElapsedColor(_ color: UIColor) -> VHUD {
        self.content.lineElapsedColor = color
        return self
    }
    
    public mutating func show(_ inView: UIView) -> VHUD {
        let view = VHUDView(inView: inView)
        self.hudView = view
        self.hudView?.setContent(content)
        
        return self
    }
    
    public func dismiss(_ duration: TimeInterval, _ deley: TimeInterval? = nil, _ text: String? = nil, _ completion: (() -> Void)? = nil) {
        self.hudView?.dismiss(duration, deley, text, completion)
    }
}

