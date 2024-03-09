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

/// TextView의 입력 모드를 케이스에 따라 막는 모드
@frozen public enum TextViewInputBreakMode {
    /// 기본
    case none
    /// 개행의 입력을 막는다
    case lineBreak
    /// 공백의 입력을 막는다
    case whiteSpace
    /// 연속된 공백의 입력을 막는다
    case continuousWhiteSpace
    /// 개행과 공백의 입력을 막는다
    case lineWithWhiteSpace
    /// 개행과 연속된 공백의 입력을 막는다
    case lineWithContinuousWhiteSpace
}

/// TextView의 스타일 ( PlaceHolder / Basic )
@frozen public enum TextViewStyle: Equatable {
    /// PlaceHolder 타입
    case placeHolder
    /// 초기값이 있는 타입
    case basic
}

@frozen public struct TextViewInputModel: Equatable {
    public static let zero = TextViewInputModel(placeholderText: "", placeholderColor: .white, placeholderFont: .boldSystemFont(ofSize: 14), focusColor: .white, focusFont: .boldSystemFont(ofSize: 14))
    
    public var placeholderText: String = ""
    public var placeholderColor: UIColor = .white
    public var placeholderFont: UIFont = .boldSystemFont(ofSize: 14)

    public var focusColor: UIColor = .white
    public var focusFont: UIFont = .boldSystemFont(ofSize: 14)

    public init(placeholderText: String = "",
                placeholderColor: UIColor = .white,
                placeholderFont: UIFont = .boldSystemFont(ofSize: 14),
                focusColor: UIColor = .white,
                focusFont: UIFont = .boldSystemFont(ofSize: 14)) {
        self.placeholderText = placeholderText
        self.placeholderColor = placeholderColor
        self.placeholderFont = placeholderFont
        self.focusColor = focusColor
        self.focusFont = focusFont
    }
}

public struct TextView: UIViewRepresentable {
    @Binding public var text: String
    public var style: TextViewStyle = .placeHolder
//    public var placeHolderStyle: PlaceHolderStyle = .zero
//    public var basicStyle: BasicStyle = .zero
    public var inputModel: TextViewInputModel = .zero
    public var method: TextViewTrimMethod = .none
    public var inputBreakMode: TextViewInputBreakMode = .none
    public var limitCount: Int = 9999
    public var limitLine: Int = 9999
    public var isScrollEnabled: Bool = true
    
    public var heightClosure: ((CGFloat) -> Void)?
    public var textCountClosure: ((Int) -> Void)?
    
    public init(text: Binding<String>,
                style: TextViewStyle = .placeHolder) {
        self._text = text
        self.style = style
    }
    
    public func makeUIView(context: Context) -> some UITextView {
        let textView = UITextView()
        
        if style == .basic && !_text.wrappedValue.isEmpty {
            textView.text = _text.wrappedValue
            textView.textColor = inputModel.focusColor
            textView.font = inputModel.focusFont
        } else {
            textView.text = inputModel.placeholderText
            textView.textColor = inputModel.placeholderColor
            textView.font = inputModel.placeholderFont
        }
        
        textView.backgroundColor = .clear
        textView.delegate = context.coordinator
        textView.showsVerticalScrollIndicator = false
        textView.isEditable = true
        textView.isSelectable = true
        textView.isScrollEnabled = isScrollEnabled
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        DispatchQueue.main.async {
            self.updateTextCount(textView: textView)
        }
        
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
        
        if text == inputModel.placeholderText || text.isEmpty {
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
    
    @inlinable func inputBreakMode(_ mode: TextViewInputBreakMode = .none) -> TextView {
        var view = self
        view.inputBreakMode = mode
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
    
    @inlinable func limitLine(_ lines: Int = 9999) -> TextView {
        var view = self
        view.limitLine = lines
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
    
    @inlinable func setInputModel(_ model: TextViewInputModel = .zero) -> TextView {
        var view = self
        view.inputModel = model
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
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == parent.inputModel.placeholderText {
            textView.text = ""
            textView.font = parent.inputModel.focusFont
            textView.textColor = parent.inputModel.focusColor
            self.text.wrappedValue = textView.text
        }
        
        parent.updateTextCount(textView: textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if text == parent.inputModel.placeholderText || text.isEmpty {
            textView.text = parent.inputModel.placeholderText
            textView.textColor = parent.inputModel.placeholderColor
            textView.font = parent.inputModel.placeholderFont
            self.text.wrappedValue = parent.inputModel.placeholderText
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
        if checkInputBreakMode(textView, replacementText: text) {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
                
                // 새로운 텍스트 높이 계산
            let textHeight = newText.boundingRect(with: CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude),
                                                      options: .usesLineFragmentOrigin,
                                                      attributes: [NSAttributedString.Key.font: textView.font ?? UIFont.systemFont(ofSize: 17)],
                                                      context: nil).height
                
                // 새로운 라인 수 계산
            let numberOfLines = Int(textHeight / (textView.font?.lineHeight ?? 0))
            
            if numberOfLines > parent.limitLine {
                return false
            }
            
            var changedText = ""

            switch parent.method {
            case .none:
                changedText = newText
            case .whitespaces:
                changedText = newText.trimmingCharacters(in: .whitespaces)
            case .whitespacesAndNewlines:
                changedText = newText.trimmingCharacters(in: .whitespacesAndNewlines)
            case .blankWithTrim:
                changedText = newText.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "")
            case .blankWithTrimLine:
                changedText = newText.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
            }
            
            if changedText.count > parent.limitCount {
                return false
            }
            
            return true
            
        } else {
            
            return false
        }
    }
    
    func checkInputBreakMode(_ textView: UITextView, replacementText text: String) -> Bool {
        switch parent.inputBreakMode {
        case .lineBreak:
            
            if text == "\n" {
                return false
            } else {
                return true
            }
            
        case .whiteSpace:
            
            if text == " " {
                return false
            } else {
                return true
            }
            
        case .continuousWhiteSpace:
            
            let lastText = textView.text.last
            
            if lastText == " " && text == " " {
                return false
            } else {
                return true
            }
            
        case .lineWithWhiteSpace:
            
            if text == "\n" || text == " " {
                return false
            } else {
                return true
            }
            
        case .lineWithContinuousWhiteSpace:
            
            let lastText = textView.text.last
            
            if text == "\n" || lastText == " " && text == " " {
                return false
            } else {
                return true
            }
            
        default:
            return true
        }
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
