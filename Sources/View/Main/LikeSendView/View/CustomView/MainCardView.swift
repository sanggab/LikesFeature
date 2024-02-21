//
//  MainCardView.swift
//  LikesFeature
//
//  Created by Gab on 2024/02/20.
//

import SwiftUI

public struct MainCardView: View {
    public let style: LikeSendStyle
    
    private var boxHeight: CGFloat = 0
    
    public init(style: LikeSendStyle) {
        self.style = style
    }
    
    public var body: some View {
        if style.mainCard == .image {
            imgCardView
        } else if style.mainCard == .video {
            videoCardView
        } else {
            textCardView
        }
    }
    
    public func inputBoxHeight(_ height: CGFloat) -> MainCardView {
        var view = self
        view.boxHeight = height
        return view
    }
    
    @ViewBuilder
    public var imgCardView: some View {
        Image(style.thumbnailImgUrl)
            .resizable()
            .cornerRadius(12)
            .overlay {
                if style.state == .delete {
                    ZStack {
                        BlurEffect(effectStyle: .light, intensity: 50)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .overlay {
                                Color.black
                                    .opacity(0.4)
                            }
                            .cornerRadius(12)
                        
                        VStack(spacing: 0) {
                            Image("imgDeletedContent")
                                .resizable()
                                .frame(width: 80, height: 80)

                            Text("Deleted Content")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .padding(.top, 6)
                        }
                    }
                }
            }
            .matchedGeometryEffect(id: style.id, in: style.animation)
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 0)
    }
    
    @ViewBuilder
    public var videoCardView: some View {
        Text("Video")
    }
    
    @ViewBuilder
    public var textCardView: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(.white248)
            .matchedGeometryEffect(id: style.id, in: style.animation)
            .frame(maxWidth: .infinity, alignment: .leading)
            .aspectRatio(1, contentMode: .fit)
            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 0)
            .overlay {
                VStack(alignment: .leading, spacing: 0) {
                    Text("About me")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.warmgrey)
                        .padding(.top, 36)
                        .padding(.leading, 16)
                    
                    Text(style.aboutMe)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.gray20)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, boxHeight / 2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .overlay {
                    if style.state == .delete {
                        ZStack {
                            BlurEffect(effectStyle: .light, intensity: 50)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .overlay {
                                    Color.black
                                        .opacity(0.4)
                                }
                                .cornerRadius(12)
                            
                            VStack(spacing: 0) {
                                Image("imgDeletedContent")
                                    .resizable()
                                    .frame(width: 80, height: 80)

                                Text("Deleted Content")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .padding(.top, 6)
                            }
                        }
                    }
                }
            }
    }
}

//struct MainCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainCardView()
//    }
//}
