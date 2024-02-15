//
//  LikesSendView.swift
//  LikesFeature
//
//  Created by Gab on 2024/02/15.
//

import SwiftUI

public struct LikesSendView<ContentView: View>: View {
    
    @Binding public var openState: Bool
    public var ptrName: String
    private var likesView: () -> ContentView
    
    @State private var topPadding: CGFloat = 487
    
//    @State private var attributedString: AttributedString = .init(stringLiteral: "")
    
//    private var attributedString : AttributedString {
//        var string = AttributedString("Match with Krrrrwalwal")
//
//        if let this = string.range(of: "Krrrrwalwal") {
//            string[this].font = .system(size: 16, weight: .bold)
//            string[this].foregroundColor = .black
//        }
//
//        return string
//    }
    
    public init(openState: Binding<Bool>,
                ptrName: String,
                @ViewBuilder likesView: @escaping () -> ContentView) {
        self._openState = openState
        self.ptrName = ptrName
        self.likesView = likesView
    }
    
    public var body: some View {
        GeometryReader { proxy in
            let _ = print("size -> \(proxy.size)")
            
            ZStack(alignment: .topLeading) {
                Color.gray
                    .opacity(0.7)
                
                likesView()
                    .onTapGesture {
                        withAnimation(.spring()) {
                            openState = false
                        }
                    }
                
                VStack(spacing: 0) {
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white)
                        .frame(height: 98)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                    
                    
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.yellow)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 12)
                        .overlay {
                            Text(makeAttributedString())
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                        }
                        .padding(.top, 32)
                    
                    
                    Text("Cancel")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.vertical, 13)
                        .padding(.horizontal, 14)
                        .padding(.top, 4)
                }
                .padding(.top, topPadding)
            }
            .frame(maxWidth: .infinity)
            .onAppear {
                withAnimation(.spring()) {
                    topPadding = 467
                }
            }
            .onDisappear {
                withAnimation(.spring()) {
                    topPadding = 487
                }
            }
        }
    }
    
    private func makeAttributedString() -> AttributedString {
        var string = AttributedString("Match with \(ptrName)")

        if let this = string.range(of: ptrName) {
            string[this].font = .system(size: 16, weight: .bold)
            string[this].foregroundColor = .black
        }

        return string
    }
}

//struct LikesSendView_Previews: PreviewProvider {
//    static var previews: some View {
//        LikesSendView(openState: .constant(true)) {
//            Image("도화가25")
//                .resizable()
//                .cornerRadius(12)
//                .matchedGeometryEffect(id: "도화가25", in: animation)
//                .frame(maxWidth: .infinity)
//                .aspectRatio(1, contentMode: .fit)
//                .padding(.horizontal, 12)
//                .padding(.top, 124)
//        }
//    }
//}
