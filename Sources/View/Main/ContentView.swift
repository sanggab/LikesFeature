//
//  ContentView.swift
//  LikesFeature
//
//  Created by Gab on 2024/02/15.
//

import SwiftUI

public struct ContentView: View {
    @State private var openState: Bool = false
    @Namespace private var animation
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Rectangle()
                .fill(.mint)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
            
            if !openState {
                Image("도화가25")
                    .resizable()
                    .cornerRadius(12)
                    .matchedGeometryEffect(id: "도화가25", in: animation)
                    .frame(width: 100, height: 100)
                    .padding(.leading, 10)
                    .padding(.top, 10)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            openState = true
                        }
                    }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .overlay {
            if openState {
                LikesSendView(openState: $openState,
                              ptrName: "Krrrrwalwal") {
                    Image("도화가25")
                        .resizable()
                        .cornerRadius(12)
                        .matchedGeometryEffect(id: "도화가25", in: animation)
                        .frame(maxWidth: .infinity)
                        .aspectRatio(1, contentMode: .fit)
                        .padding(.horizontal, 12)
                        .padding(.top, 124)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
