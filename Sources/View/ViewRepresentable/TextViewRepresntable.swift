//
//  TextViewRepresntable.swift
//  LikesFeature
//
//  Created by Gab on 2024/02/15.
//

import UIKit
import SwiftUI

@frozen public enum TextViewTrimMethod {
    /// default
    case none
    
    /// trim의 whitespaces과 같다
    case whitespaces
    
    /// trim의 whitespacesAndNewlines과 같다
    case whitespacesAndNewlines
    
    /// whitespaces와 문자열 사이의 공백들 다 제거
    case blankWithTrim
    
    /// whitespacesAndNewlines와 문자열 사이의 공백들 다 제거
    case blankWithTrimLine
}

@frozen public struct TextViewStyle: Equatable {
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

public struct TextView: UIViewRepresentable {
    @Binding public var text: String
    public var style: TextViewStyle
    public var method: TextViewTrimMethod = .none
    public var limitCount: Int = 9999
    public var isScrollEnabled: Bool = true
    
    public var heightClosure: ((CGFloat) -> Void)?
    public var textCountClosure: ((Int) -> Void)?
    
    public init(text: Binding<String>,
                style: TextViewStyle) {
        self._text = text
        self.style = style
    }
    
    public func makeUIView(context: Context) -> some UITextView {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = style.placeholderFont
        textView.text = style.placeholderText
        textView.textColor = style.placeholderColor
        textView.delegate = context.coordinator
        textView.showsVerticalScrollIndicator = false
        textView.isEditable = true
        textView.isSelectable = true
        textView.isScrollEnabled = isScrollEnabled
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return textView
    }
    
    public func updateUIView(_ textView: UIViewType, context: Context) {
        
    }
    
    public func makeCoordinator() -> TextViewCoordinator {
        TextViewCoordinator(text: $text,
                            parent: self)
    }
    
    fileprivate func updateHeight(textView: UITextView) {
        if !isScrollEnabled {
            let size = textView.sizeThatFits(CGSize(width:
                                                        textView.frame.size.width, height: .infinity))
            if textView.frame.size != size {
                textView.frame.size.height = size.height
                heightClosure?(textView.frame.size.height)
            }
        }
    }
    
    fileprivate func updateTextCount(textView: UITextView) {
        var count: Int = 0
        
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if text == style.placeholderText || text.isEmpty {
            textCountClosure?(count)
            return
        }
        
        switch method {
        case .none:
            count = textView.text.count
        case .whitespaces:
            count = textView.text.trimmingCharacters(in: .whitespaces).count
        case .whitespacesAndNewlines:
            count = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).count
        case .blankWithTrim:
            count = textView.text.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "").count
        case .blankWithTrimLine:
            count = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "").count
        }
        
        textCountClosure?(count)
    }
}

/// 옵션 기능들
public extension TextView {
    
    @inlinable func isScrollEnabled(_ state: Bool) -> TextView {
        var view = self
        view.isScrollEnabled = state
        return view
    }
    
    @inlinable func trimMethod(_ method: TextViewTrimMethod) -> TextView {
        var view = self
        view.method = method
        return view
    }
    
    @inlinable func limitCount(_ count: Int = 9999) -> TextView {
        var view = self
        view.limitCount = count
        return view
    }
    
    @inlinable func limitCount(_ method: TextViewTrimMethod = .none, _ count: Int = 9999) -> TextView {
        var view = self
        view.method = method
        view.limitCount = count
        return view
    }
    
    @inlinable func textViewHeight(height: ((CGFloat) -> Void)? = nil) -> TextView {
        var view = self
        view.heightClosure = height
        return view
    }
    
    @inlinable func textCount(count: ((Int) -> Void)? = nil) -> TextView {
        var view = self
        view.textCountClosure = count
        return view
    }
}

public final class TextViewCoordinator: NSObject, UITextViewDelegate {
    var text: Binding<String>
    public var parent: TextView
    
    public init(text: Binding<String>,
                parent: TextView) {
        self.text = text
        self.parent = parent
    }
}

public extension TextViewCoordinator {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == parent.style.placeholderText {
            textView.text = ""
            textView.font = parent.style.focusFont
            textView.textColor = parent.style.focusColor
            self.text.wrappedValue = textView.text
        }
        
        parent.updateTextCount(textView: textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if text == parent.style.placeholderText || text.isEmpty {
            textView.text = parent.style.placeholderText
            textView.textColor = parent.style.placeholderColor
            textView.font = parent.style.placeholderFont
            self.text.wrappedValue = parent.style.placeholderText
        } else {
            textView.text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
            self.text.wrappedValue = textView.text
        }
        
        parent.updateTextCount(textView: textView)
        parent.updateHeight(textView: textView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.text.wrappedValue = textView.text
        
        parent.updateTextCount(textView: textView)
        parent.updateHeight(textView: textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let currentText = textView.text else { return false }
        guard let stringRange = Range(range, in : currentText) else { return false}

        var changedText = ""

        switch parent.method {
        case .none:
            changedText = currentText.replacingCharacters(in: stringRange, with: text)
        case .whitespaces:
            changedText = currentText.replacingCharacters(in: stringRange, with: text).trimmingCharacters(in: .whitespaces)
        case .whitespacesAndNewlines:
            changedText = currentText.replacingCharacters(in: stringRange, with: text).trimmingCharacters(in: .whitespacesAndNewlines)
        case .blankWithTrim:
            changedText = currentText.replacingCharacters(in: stringRange, with: text).trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "")
        case .blankWithTrimLine:
            changedText = currentText.replacingCharacters(in: stringRange, with: text).trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
        }

        if changedText.count >= parent.limitCount {
            textView.text = currentText.trimmingTrailingSpaces()
            self.text.wrappedValue = textView.text
        }
        
        return changedText.count <= parent.limitCount
    }
}

public extension String {

    func trimmingTrailingSpaces() -> String {
        var t = self
        while t.hasSuffix(" ") {
          t = "" + t.dropLast()
        }
        return t
    }

    mutating func trimmedTrailingSpaces() {
        self = self.trimmingTrailingSpaces()
    }

}
