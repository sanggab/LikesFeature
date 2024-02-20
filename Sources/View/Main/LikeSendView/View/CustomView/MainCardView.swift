//
//  MainCardView.swift
//  LikesFeature
//
//  Created by Gab on 2024/02/20.
//

import SwiftUI

@frozen public enum LikeCardType {
    case image
    case video
}

@frozen public enum LikeContentState {
    case original
    case delete
}

public struct MainCardView: View {
    
    
    public var id: AnyHashable
    public var imgUrl: String
    public var cardType: LikeCardType
    public var state: LikeContentState
    
    
    
    @Namespace private var animation
    
    public init(id: AnyHashable,
                imgUrl: String,
                cardType: LikeCardType = .image,
                state: LikeContentState = .original) {
        self.id = id
        self.imgUrl = imgUrl
        self.cardType = cardType
        self.state = state
    }
    
//    public var imgUrl: URL?
    
    public var body: some View {
        if cardType == .image {
            imageCardView
        }
    }
    
    @ViewBuilder
    public var imageCardView: some View {
        Image(imgUrl)
            .resizable()
            .cornerRadius(12)
            .overlay {
                if state == .delete {
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
            .matchedGeometryEffect(id: id, in: animation)
    }
}

//struct MainCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainCardView()
//    }
//}
