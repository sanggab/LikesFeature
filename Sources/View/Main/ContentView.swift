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
    
    @State private var name: String = "도화가25"
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Rectangle()
                .fill(.mint)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
            
            if !openState {
                Image(name)
                    .resizable()
                    .cornerRadius(12)
                    .matchedGeometryEffect(id: "도화가25", in: animation)
                    .frame(width: 100, height: 100)
                    .padding(.leading, 10)
                    .padding(.top, 10)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            openState = true
//                            name = "안돼"
                        }
                    }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .overlay {
            if openState {
                LikesSendView(openState: $openState,
                              ptrName: "Krrrrwalwal",
                              commentText: "Liked your Photo") {
                    Image("도화가25")
                        .resizable()
                        .cornerRadius(12)
                        .matchedGeometryEffect(id: "도화가25", in: animation)
                        .frame(maxWidth: .infinity)
                        .aspectRatio(1, contentMode: .fit)
                        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 6)
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
