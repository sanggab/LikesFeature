//
//  BlurEffect.swift
//  LikesFeature
//
//  Created by Gab on 2024/02/19.
//

import SwiftUI

public class BlurEffectView: UIVisualEffectView {

    private let theEffect: UIVisualEffect
    private let customIntensity: CGFloat
    private var animator: UIViewPropertyAnimator?
    
    public init(effectStyle: UIBlurEffect.Style, intensity: CGFloat) {
        theEffect = UIBlurEffect(style: effectStyle)
        customIntensity = intensity
        super.init(effect: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { nil }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        effect = nil
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in
            self.effect = theEffect
        }
        animator?.pausesOnCompletion = true
        animator?.fractionComplete = customIntensity
    }
    
    deinit {
        animator?.stopAnimation(true)
    }
    
}

public struct BlurEffect: UIViewRepresentable {
    
    private var effectStyle: UIBlurEffect.Style
    private var intensity: CGFloat
    
    public init(effectStyle: UIBlurEffect.Style,
                intensity: CGFloat) {
        self.effectStyle = effectStyle
        self.intensity = intensity
    }
    
    public func makeUIView(context: Context) -> some UIView {
        let view = BlurEffectView(effectStyle: effectStyle, intensity: intensity)
        
        return view
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
