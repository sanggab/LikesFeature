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
        
        return textView
    }
    
    /// textView의 키보드가 닫아질 때, 이놈도 같이 호출된다. 조심하자
    public func updateUIView(_ uiView: UIViewType, context: Context) {
//        uiView.setContentOffset(CGPoint(x: 0, y: uiView.contentSize.height), animated: false)
    }
    
    public func makeCoordinator() -> TextViewCoordinator {
        TextViewCoordinator(text: $text,
                            model: model)
    }
    
}

public final class TextViewCoordinator: NSObject, UITextViewDelegate {
    var text: Binding<String>
    public var model: SUTextViewModel
    
    public init(text: Binding<String>,
                model: SUTextViewModel) {
        self.text = text
        self.model = model
    }
}

public extension TextViewCoordinator {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDidBeginEditing")
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == model.placeholderText {
            textView.text = ""
            textView.textColor = model.focusColor
            self.text.wrappedValue = textView.text
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing")
        print("text -> \(textView.text ?? "")")
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == model.placeholderText || textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = model.placeholderText
            textView.textColor = model.placeholderColor
            self.text.wrappedValue = model.placeholderText
        } else {
            self.text.wrappedValue = textView.text
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print("textViewDidChange")
//        $text.wrappedValue = textView.text
    }
}


import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.text = text
        textView.isEditable = true
        textView.delegate = context.coordinator
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func textViewDidChange(_ textView: UITextView) {
            text = textView.text
        }
    }
}
