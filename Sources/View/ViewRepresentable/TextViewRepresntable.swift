//
//  TextViewRepresntable.swift
//  LikesFeature
//
//  Created by Gab on 2024/02/15.
//

import UIKit
import SwiftUI

@frozen public struct SUTextViewModel: Equatable {
    public var placeholderText: String
    public var placeholderColor: UIColor
    public var placeholderFont: UIFont
    
    public var focusColor: UIColor
    public var focusFont: UIFont
    
    public init(placeholderText: String,
                placeholderColor: UIColor,
                placeholderFont: UIFont,
                focusColor: UIColor,
                focusFont: UIFont) {
        self.placeholderText = placeholderText
        self.placeholderColor = placeholderColor
        self.placeholderFont = placeholderFont
        self.focusColor = focusColor
        self.focusFont = focusFont
    }
}

public struct SUTextView: UIViewRepresentable, Equatable {
    public static func == (lhs: SUTextView, rhs: SUTextView) -> Bool {
        return lhs.model == rhs.model
    }
    
    @Binding public var text: String
    public var model: SUTextViewModel
    
    public var throwHeight: ((CGFloat) -> ())?
    
    public init(text: Binding<String>,
                model: SUTextViewModel) {
        self._text = text
        self.model = model
    }
    
    public func makeUIView(context: Context) -> some UITextView {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = .boldSystemFont(ofSize: 15)
        textView.text = model.placeholderText
        textView.textColor = model.placeholderColor
        textView.delegate = context.coordinator
        textView.showsVerticalScrollIndicator = false
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return textView
    }
    
    /// textView의 키보드가 닫아질 때, 이놈도 같이 호출된다. 조심하자
    public func updateUIView(_ textView: UIViewType, context: Context) {
        
    }
    
    public func makeCoordinator() -> TextViewCoordinator {
        TextViewCoordinator(text: $text,
                            parent: self)
    }
    
    
    @inlinable public func textViewHeight(height: ((CGFloat) -> ())? = nil) -> SUTextView {
        var view = self
        view.throwHeight = height
        return view
    }
    
    fileprivate func updateHeight(textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width:
                                                    textView.frame.size.width, height: .infinity))
        if textView.frame.size != size {
            textView.frame.size = size
            throwHeight?(size.height)
        }
    }
}

public final class TextViewCoordinator: NSObject, UITextViewDelegate {
    var text: Binding<String>
    public var parent: SUTextView
    
    public init(text: Binding<String>,
                parent: SUTextView) {
        self.text = text
        self.parent = parent
    }
}

public extension TextViewCoordinator {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDidBeginEditing")
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == parent.model.placeholderText {
            textView.text = ""
            textView.textColor = parent.model.focusColor
            self.text.wrappedValue = textView.text
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing")
        
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == parent.model.placeholderText || textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = parent.model.placeholderText
            textView.textColor = parent.model.placeholderColor
            self.text.wrappedValue = parent.model.placeholderText
        } else {
            textView.text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
            self.text.wrappedValue = textView.text
        }
        
        parent.updateHeight(textView: textView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print("textViewDidChange")
        self.text.wrappedValue = textView.text
        
        parent.updateHeight(textView: textView)
    }
}
