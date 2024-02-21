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
    @State private var style: LikeSendStyle = .zero
    
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
                        style = LikeSendStyle(state: .original,
                                              type: .Like,
                                              mainCard: .image,
                                              amberType: .amberWithfree,
                                              thumbnailImgUrl: name,
                                              comment: "Liked your photo",
                                              ptrName: "SangGab",
                                              id: "도화가25",
                                              animation: animation)
                        
                        withAnimation(.spring()) {
                            openState = true
                        }
                    }
            }
            
            if !openState {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.primary300)
                    .matchedGeometryEffect(id: "동그라미", in: animation)
                    .frame(height: 96, alignment: .top)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Liked your \"about me\"")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.commentText)
                                .padding(.horizontal, 16)
                                .padding(.top, 12)
                            
                            Text("I work as a model in Spain and I'm bored because I don't have any friends here. so I wan....")
                                .matchedGeometryEffect(id: "텍스트", in: animation)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.gray50)
                                .padding(.horizontal, 16)
                                .padding(.top, 6)
                                .padding(.bottom, 12)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 12)
                    .onTapGesture {
                        style = LikeSendStyle(state: .original,
                                              type: .Like,
                                              mainCard: .text,
                                              amberType: .free,
                                              comment: "Liked your \"about me\"",
                                              aboutMe: "I work as a model in Spain and I'm bored because I don't have any friends here. so I wan....I work as a model in Spain and I'm bored because I don't have any friends here. so I wan....I work as a model in Spain and I'm bored because I don't have any friends here. so I wan....",
                                              ptrName: "SangGab",
                                              id: "동그라미",
                                              animation: animation)
                        
                        withAnimation(.linear(duration: 0.2)) {
                            openState = true
                        }
                    }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .overlay {
            if openState {
                LikesSendView(openState: $openState,
                              style: style)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//style = LikeSendStyle(state: .original,
//                     type: .match,
//                     mainCard: .text,
//                     comment: "I work as a model in Spain and I'm bored because I don't have any friends here.  love tennis, football, hockey, and all kinds of sports ! I work as a model in Spain and I'm boredad",
//                     ptrName: "SangGab",
//                     id: "V스택",
//                     animation: animation)

