//
//  Model.swift
//  LikesFeature
//
//  Created by Gab on 2024/02/20.
//

import SwiftUI

@frozen public enum LikeCardState: Equatable {
    case original
    case delete
}

@frozen public enum LikeCardType: Equatable {
    case match
    case Like
}

@frozen public enum LikeMainCardType: Equatable {
    case image
    case video
    case text
}

@frozen public struct LikeSendStyle {
    
    public static let zero = LikeSendStyle(state: .original, type: .Like, mainCard: .image, id: "hoho", animation: Namespace().wrappedValue)
    
    public let state: LikeCardState
    public let type: LikeCardType
    public let mainCard: LikeMainCardType
    
    public let thumbnailImgUrl: String
    public let videoUrl: String
//    public let thumbnailImgUrl: URL
//    public let videoUrl: URL
    public let comment: String
    public let aboutMe: String
    
    public let ptrName: String
    public let id: String
    public let animation: Namespace.ID
    
    public init(state: LikeCardState,
                type: LikeCardType,
                mainCard: LikeMainCardType,
                thumbnailImgUrl: String = "",
                videoUrl: String = "",
                comment: String = "",
                aboutMe: String = "",
                ptrName: String = "",
                id: String,
                animation: Namespace.ID) {
        self.state = state
        self.type = type
        self.mainCard = mainCard
        self.thumbnailImgUrl = thumbnailImgUrl
        self.videoUrl = videoUrl
        self.comment = comment
        self.aboutMe = aboutMe
        self.ptrName = ptrName
        self.id = id
        self.animation = animation
    }
}
