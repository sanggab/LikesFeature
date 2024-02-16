//
//  Color.swift
//  LikesFeature
//
//  Created by Gab on 2024/02/15.
//

import SwiftUI

public extension UIColor {
    
    static var commentTextColor: UIColor {
        UIColor(red: 149.0 / 255.0, green: 104.0 / 255.0, blue: 0 / 255.0, alpha: 1.0)
    }
    
    static var placeHolderColor: UIColor {
        UIColor(white: 184.0 / 255.0, alpha: 1.0)
    }
    
    static var matchBtnBGColor: UIColor {
        UIColor(red: 255.0 / 255.0, green: 206.0 / 255.0, blue: 14.0 / 255.0, alpha: 1.0)
    }
    
    static var matchTextColor: UIColor {
        UIColor(white: 32.0 / 255.0, alpha: 1.0)
    }
    
    static var cancelTextColor: UIColor {
        UIColor(white: 80.0 / 255.0, alpha: 1.0)
    }
}

public extension ShapeStyle where Self == Color {
    
    static var commentText: Color {
        Color(uiColor: .commentTextColor)
    }
    
    static var placeHolder: Color {
        Color(uiColor: .placeHolderColor)
    }
    
    static var matchBtnBG: Color {
        Color(uiColor: .matchBtnBGColor)
    }
    
    static var matchText: Color {
        Color(uiColor: .matchTextColor)
    }
    
    static var cancelTexT: Color {
        Color(uiColor: .cancelTextColor)
    }
}
