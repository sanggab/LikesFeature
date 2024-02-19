//
//  LikesSendView.swift
//  LikesFeature
//
//  Created by Gab on 2024/02/15.
//

import SwiftUI

public struct LikesSendView<ContentView: View>: View {
    
    @Binding public var openState: Bool
    @State private var commentTexT: String = ""
    public var ptrName: String
    private var likesView: () -> ContentView
    
    @State private var inputOffsetY: CGFloat = 0
    
    @State private var btnOffsetY: CGFloat = 0
    
    @FocusState private var keyBoardState
    
    @State private var keyboardHeight: CGFloat = 0
    
    @Namespace private var animation
    
    @State private var testState: Bool = false
    @State private var textViewHeight: CGFloat = 66
    
    @State private var boxHeight: CGFloat = 98
    
    public init(openState: Binding<Bool>,
                ptrName: String,
                commentText: String,
                @ViewBuilder likesView: @escaping () -> ContentView) {
        self._openState = openState
        self.ptrName = ptrName
        self._commentTexT = .init(initialValue: commentText)
        self.likesView = likesView
    }
    
    public var body: some View {
        GeometryReader { proxy in
//            let _ = print("proxy -> \(proxy.size)")
            ZStack(alignment: .topLeading) {
                Color.gray
                    .opacity(0.7)
                    .onTapGesture {
                        keyBoardState = false
                    }
                
                likesView()
                    .onTapGesture {
                        withAnimation(.spring()) {
                            openState = false
                        }
                    }
                
                HStack(alignment: .top, spacing: 0) {
                    TextView(text: $commentTexT,
                             style: TextViewStyle(placeholderText: "Add a commnent",
                                                  placeholderColor: .placeHolderColor,
                                                  placeholderFont: .boldSystemFont(ofSize: 15),
                                                  focusColor: .commentTextColor,
                                                  focusFont: .boldSystemFont(ofSize: 15)))
                    .isScrollEnabled(false)
                    .limitCount(.blankWithTrimLine, 150)
                    .textViewHeight { height in
                        if height > 66 {
                            withAnimation(.linear(duration: 0.1)) {
                                textViewHeight = height
                                boxHeight = height + 32
                                inputOffsetY = proxy.size.height - (keyboardHeight - proxy.safeAreaInsets.bottom) - boxHeight
                            }
                            btnOffsetY = 124 + proxy.size.width - 24 + (boxHeight / 2) + 32
                        } else {
                            withAnimation(.linear(duration: 0.1)) {
                                textViewHeight = 66
                                boxHeight = 98
                                inputOffsetY = proxy.size.height - (keyboardHeight - proxy.safeAreaInsets.bottom) - boxHeight
                            }
                            btnOffsetY = 124 + proxy.size.width - 24 + (boxHeight / 2) + 32
                        }
                    }
                        .focused($keyBoardState)
                        .frame(width: proxy.size.width - 72, height: textViewHeight, alignment: .topLeading)
//                        .frame(minHeight: textViewHeight, maxHeight: .infinity, alignment: .top)
//                        .fixedSize()
                        .padding(.vertical, 16)
                        .padding(.leading, 16)
                    
                    if testState {
                        Image("iconInputDisabled")
                            .resizable()
                            .frame(width: 24, height: 24, alignment: .topTrailing)
                            .padding(.all, 8)
                            .padding(.top, 12)
                            .padding(.leading, 4)
                    }
                }
//                .matchedGeometryEffect(id: "HStack", in: animation)
                .frame(height: boxHeight, alignment: .top)
                .frame(maxWidth: .infinity, alignment: .leading)
//                .fixedSize(horizontal: false, vertical: true)
                .background(.white)
                .cornerRadius(testState ? 0 : 8)
                .padding(.horizontal, testState ? 0 : 20)
                .offset(y: inputOffsetY)
                
                VStack(spacing: 0) {
                    
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.yellow)
                        .frame(height: 50)
                        .padding(.horizontal, 12)
                        .overlay {
                            Text(makeAttributedString())
                                .lineLimit(1)
                                .font(.system(size: 16, weight: .medium))
                                .padding(.horizontal, 24)
                                .padding(.vertical, 13)
                        }
                    
                    Text("Cancel")
                        .font(.system(size: 16, weight: .medium))
                        .frame(height: 24)
                        .foregroundColor(.cancelTexT)
                        .padding(.vertical, 13)
                        .padding(.horizontal, 14)
                        .padding(.top, 4)
                }
                .onAppear {
                    // 계산식 해당 VStack은 사진의 사이즈 절발만큼 올라가야한다
                    // 현재 사진의 top inset인 124를 더하고
                    // 사진의 높이는 디바이스 사이즈에서 좌우 여백 12를 뺀 값이므로 proxy.size.width - 24를 더해준다.
                    // 그리고 인풋박스는 박스의 높이의 절반만큼 밀어줘야 하므로 boxHeight / 2 만큼 뺴준다음
                    // 처음 스타트를 20밑에서부터 시작하므로 20 더해준다.
                    inputOffsetY = 124 + proxy.size.width - 24 - (boxHeight / 2)  + 20
                    
                    
                    // Match 버튼과 Cancel 버튼의 offset은 인풋박스의 maxY에서 32만큼 더해주면된다.
                    // 그 다음 첫 스타트를 20밑에서부터 시작하므로 20 더해준다.
                    
                    btnOffsetY = 124 + proxy.size.width - 24 + (boxHeight / 2) + 32 + 20
                }
                .frame(maxWidth: .infinity)
                .padding(.top, btnOffsetY)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                withAnimation(.spring()) {
                    inputOffsetY = proxy.size.width - (boxHeight / 2) - 24 + 124
                    btnOffsetY = 124 + proxy.size.width - 24 + (boxHeight / 2) + 32
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { output in
                print("keyboardWillShowNotification")
                if let userinfo = output.userInfo {
                    if let size = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                        guard let duration = userinfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
                            return
                        }
                        
                        let offsetY = proxy.size.height - (size.height - proxy.safeAreaInsets.bottom) - boxHeight
                        
                        keyboardHeight = size.height
                        
                        withAnimation(.linear(duration: duration)) {
                            testState = true
                        }
                        
                        withAnimation(.easeOut(duration: duration)) {
                            inputOffsetY = offsetY
                        }
                        
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { output in
                print("keyboardDidHideNotification")
                if let userinfo = output.userInfo {
                    guard let duration = userinfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
                        return
                    }
                    
                    withAnimation(.linear(duration: duration)) {
                        testState = false
                    }
                    
                    withAnimation(.easeIn(duration: duration - 0.05)) {
                        inputOffsetY = proxy.size.width - (boxHeight / 2) - 24 + 124
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .all)
    }
    
    private func makeAttributedString() -> AttributedString {
        var string = AttributedString("Match with \(ptrName)")

        if let this = string.range(of: ptrName) {
            string[this].font = .system(size: 16, weight: .bold)
            string[this].foregroundColor = .matchText
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
