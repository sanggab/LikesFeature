//
//  MatchAnimation.swift
//  LikesFeature
//
//  Created by Gab on 2024/02/21.
//

import SwiftUI

public struct MatchAnimation: View {
    @State private var onAppear: Bool = false
    @State private var state: Bool = true
    @State private var matchState: Bool = false
    
    public var body: some View {
        if state {
            BlurEffect(effectStyle: .light, intensity: 50)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    withAnimation(.spring(response: 0.6)) {
                        onAppear = true
                    }
                    
                    withAnimation(.spring(response: 0.4).delay(0.6)) {
                        matchState = true
                    }
                }
            
            /// Image에 border를 주고 애니메이션을 입힐 때, .compositingGroup()를 안하면
            /// padding영역하고 Image 영역 각각 따로 애니메이션 들어가서 이상하게 보인다.
            /// 그래서 .compositingGroup() 구현
            VStack(spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    Image("도화가17")
                        .resizable()
                        .frame(width: 143.6, height: 143.6)
                        .cornerRadius(12)
                        .padding(.all, 6)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.white)
                        }
                        .compositingGroup()
                        .rotationEffect(.degrees(-10))
                    
                    Image("도화가19")
                        .resizable()
                        .frame(width: 143.6, height: 143.6)
                        .cornerRadius(12)
                        .padding(.all, 6)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.white)
                        }
                        .compositingGroup()
                        .rotationEffect(.degrees(10))
                        .padding(.top, 45)
                }
                .opacity(onAppear ? 1 : 0)
                .offset(y: onAppear ? 0 : -10)
                
                /// imgMatch를 ZStack으로 넣은 이유는 단순하게 Image로 쓸 경우, 사이즈가 줄어들면 위에 잡은 padding이
                /// 줄어들면서 디자인적으로 문제가 생긴다.
                /// 그래서 container인 고정 사이즈 ZStack을 만들어서 그 안에 imgMatch를 넣어서 구현한다.
                /// padding top이 원래 매치가 이미지의 68만큼 떨어져 있는데 40으로 준 이유는
                /// ZStack에서 최종적으로 잡히는 높이는 56인데 위 아래 여백이 28씩 남으므로
                /// 68 - 28 = 40 이니까 40만큼 떨어틀인다.
                ZStack {
                    Image("imgMatch")
                        .resizable()
                        .frame(width: matchState ? 248 : 480, height: matchState ? 56: 108)
                        .opacity(matchState ? 1 : 0)
                }
                .frame(maxWidth: .infinity, maxHeight: 108, alignment: .center)
                .padding(.top, 40)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                    onAppear = false
                    matchState = false
                    withAnimation(.linear(duration: 0.3)) {
                        state = false
                    }
                }
            }
        }
        
    }
}

struct MatchAnimation_Previews: PreviewProvider {
    static var previews: some View {
        MatchAnimation()
    }
}
