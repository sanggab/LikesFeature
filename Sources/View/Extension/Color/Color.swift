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
    
    static var graya4: UIColor {
        UIColor(white: 164.0 / 255.0, alpha: 1.0)
    }
    
    static var warmgrey: UIColor {
        UIColor(white: 112.0 / 255.0, alpha: 1.0)
    }
    
    static var gray20: UIColor {
        UIColor(white: 32.0 / 255.0, alpha: 1.0)
    }
    
    static var gray50: UIColor {
        UIColor(white: 80.0 / 255.0, alpha: 1.0)
    }
    
    static var white248: UIColor {
        UIColor(white: 248.0 / 255.0, alpha: 1.0)
    }
    
    static var primary300: UIColor {
        UIColor(red: 255.0 / 255.0, green: 238.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)
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
    
    static var graya4: Color {
        Color(uiColor: .graya4)
    }
    
    static var warmgrey: Color {
        Color(uiColor: .warmgrey)
    }
    
    static var gray20: Color {
        Color(uiColor: .gray20)
    }
    
    static var gray50: Color {
        Color(uiColor: .gray50)
    }
    
    static var white248: Color {
        Color(uiColor: .white248)
    }
    
    static var primary300: Color {
        Color(uiColor: .primary300)
    }
}
