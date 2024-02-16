//
//  TextViewRepresntable.swift
//  LikesFeature
//
//  Created by Gab on 2024/02/15.
//

import UIKit
import SwiftUI

public struct SUTextView: UIViewRepresentable {
    @Binding var text: String
    
    public func makeUIView(context: Context) -> some UITextView {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = .boldSystemFont(ofSize: 16)
        textView.textColor = .placeholderText
        textView.delegate = context.coordinator
        
        return textView
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.text = text
    }
    
    public func makeCoordinator() -> TextViewCoordinator {
        TextViewCoordinator(text: $text)
    }
    
    public func keyboardState(_ state: Binding<Bool>) -> SUTextView {
        var view = self
        
        return view
    }
    
}

public final class TextViewCoordinator: NSObject, UITextViewDelegate {
    @Binding var text: String
    
    public init(text: Binding<String>) {
        self._text = text
    }
}

public extension TextViewCoordinator {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDidBeginEditing")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print("textViewDidChange")
        text = textView.text
    }
}
