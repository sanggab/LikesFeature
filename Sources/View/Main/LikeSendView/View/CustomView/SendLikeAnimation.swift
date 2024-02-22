//
//  SendLikeAnimation.swift
//  LikesFeature
//
//  Created by Gab on 2024/02/21.
//

import SwiftUI

public struct SendLikeAnimation: View {
    @State private var heartState: Bool = true
    @State private var offsetY: CGFloat = 97
    @State private var disAppearAnimation: Bool = false
    
    public var body: some View {
        if heartState {
            
            BlurEffect(effectStyle: .light, intensity: 50)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onChange(of: disAppearAnimation) { newValue in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(.linear(duration: 0.3)) {
                            heartState = false
                        }
                    }
                }
            
            Image("imgSendLikeHeart")
                .resizable()
                .frame(width: 130, height: 130)
                .transition(AnyTransition.scale.animation(.spring(response: 0.8).delay(0.0)))
                .opacity(disAppearAnimation ? 0 : 1)
                .offset(y: disAppearAnimation ? -(UIScreen.main.bounds.height / 2 - 65) : 0)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation(.linear(duration: 0.4)) {
                            disAppearAnimation = true
                        }
                    }
                }
            
            Text("Sent")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.gray20)
                .lineLimit(1)
                .offset(y: offsetY)
                .transition(AnyTransition.opacity.animation(.spring(response: 0.8).delay(0.0)))
                .opacity(disAppearAnimation ? 0 : 1)
                .onAppear {
                    withAnimation(.spring(response: 0.8).delay(0.0)) {
                        offsetY = 77
                    }
                    
                    withAnimation(.linear(duration: 0.4).delay(1.0)) {
                        offsetY = 57
                    }
                }
        }
    }
}

struct SendLikeAnimation_Previews: PreviewProvider {
    static var previews: some View {
        SendLikeAnimation()
    }
}
