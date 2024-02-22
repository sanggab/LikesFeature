//
//  LikesSendView.swift
//  LikesFeature
//
//  Created by Gab on 2024/02/15.
//

import SwiftUI

public struct LikesSendView: View {
    
    @Binding public var openState: Bool
    
    public let style: LikeSendStyle
    
    @State private var commentText: String = ""
    
    @State private var inputOffsetY: CGFloat = 0
    @State private var btnOffsetY: CGFloat = 0
    
    @State private var keyboardHeight: CGFloat = 0
    @State private var textViewHeight: CGFloat = 66
    @State private var boxHeight: CGFloat = 98
    
    @State private var sendState: Bool = false
    @State private var shadowState: Bool = false
    @State private var textViewAnimationState: Bool = false
    
    @State private var showLikeAnimation: Bool = false
    @State private var matchAnimation: Bool = false
    @State private var test1: Bool = false
    @State private var offset: CGFloat = 32
    
    @FocusState private var keyBoardState
    
    public init(openState: Binding<Bool>,
                style: LikeSendStyle) {
        self._openState = openState
        self.style = style
        self._commentText = .init(wrappedValue: style.comment)
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                
                BlurEffect(effectStyle: .light, intensity: 50)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture {
                        if textViewAnimationState {
                            keyBoardState = false
                        }
                    }
                
                
                // if condition으로 View를 띄울 지 말지 처리하는 코드를 넣을 때, onAppear의 순서가 뒤바뀌었다. 이건 멀까?
                MainCardView(style: style)
                    .inputBoxHeight(boxHeight)
                    .opacity(style.state == .original && textViewAnimationState ? 0.5 : 1)
                    .padding(.horizontal, 12)
                    .padding(.top, 124)
                    .onTapGesture {
                        if textViewAnimationState {
                            keyBoardState = false
                        }
                    }
                
                if style.type == .match {
                    matchBoxView(proxy)
                } else {
                    likeBoxView(proxy)
                }
                
                btnView(proxy)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                // 계산식 해당 VStack은 사진의 사이즈 절발만큼 올라가야한다
                // 현재 사진의 top inset인 124를 더하고
                // 사진의 높이는 디바이스 사이즈에서 좌우 여백 12를 뺀 값이므로 proxy.size.width - 24를 더해준다.
                // 그리고 인풋박스는 박스의 높이의 절반만큼 밀어줘야 하므로 boxHeight / 2 만큼 뺴준다음
                // 처음 스타트를 20밑에서부터 시작하므로 20 더해준다.
                print("ZStack onAppear")
                inputOffsetY = 124 + proxy.size.width - 24 - (boxHeight / 2)  + 20


                // Match 버튼과 Cancel 버튼의 offset은 인풋박스의 maxY에서 32만큼 더해주면된다.
                // 그 다음 첫 스타트를 20밑에서부터 시작하므로 20 더해준다.
                btnOffsetY = 124 + proxy.size.width - 24 + (boxHeight / 2) + 32 + 20
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
                        
                        shadowState = false
                        
                        withAnimation(.linear(duration: duration)) {
                            textViewAnimationState = true
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
                    
                    shadowState = true
                    
                    withAnimation(.linear(duration: duration)) {
                        textViewAnimationState = false
                    }
                    
                    withAnimation(.easeIn(duration: duration - 0.05)) {
                        inputOffsetY = proxy.size.width - (boxHeight / 2) - 24 + 124
                    }
                }
            }
        }
        .overlay {
            if showLikeAnimation {
                SendLikeAnimation()
                    .onDisappear {
                        print("SendLikeAnimation onDisappear")
                        showLikeAnimation = false
                    }
            }
            
            if matchAnimation {
                MatchAnimation()
                    .onDisappear {
                        print("MatchAnimation onDisappear")
                        matchAnimation = false
                    }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .all)
    }
    
    private func makeAttributedString() -> AttributedString {
        var originalString = ""
        
        if style.type == .Like {
            originalString = "Send Like"
        } else {
            originalString = "Match with" + " \(style.ptrName)"
        }
        
        var string = AttributedString(originalString)

        if let this = string.range(of: style.ptrName) {
            string[this].font = .system(size: 16, weight: .bold)
            string[this].foregroundColor = .matchText
        }

        return string
    }
}

public extension LikesSendView {
    
    @ViewBuilder
    private func matchBoxView(_ proxy: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("Comment")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.graya4)
                
                Spacer()
                
                if style.comment != "Liked your photo" && style.comment != "Liked your \"about me\"" && style.comment != "Liked your video" {
                    Text("Translate")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.warmgrey)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .onTapGesture {
                            print("Translate")
                        }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 38)
            .padding(.top, 4)
            .padding(.leading, 16)
            
            Text(style.comment)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.commentText)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
        }
        .background {
            GeometryReader { backProxy in
                Color.clear
                    .onAppear {
                        boxHeight = backProxy.size.height
                        inputOffsetY = 124 + proxy.size.width - 24 - (boxHeight / 2)
                        btnOffsetY = 124 + proxy.size.width - 24 + (boxHeight / 2) + 32
                    }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
        .fixedSize(horizontal: false, vertical: true)
        .background(.white)
        .cornerRadius(8)
        .padding(.horizontal, 20)
        .shadow(color: .black.opacity(0.16), radius: 6, x: 0, y: 2)
        .offset(y: inputOffsetY)
    }
    
    @ViewBuilder
    private func likeBoxView(_ proxy: GeometryProxy) -> some View {
        HStack(alignment: .top, spacing: 0) {
            TextView(text: $commentText,
                     style: TextViewStyle(placeholderText: "Add a commnent",
                                          placeholderColor: .placeHolderColor,
                                          placeholderFont: .boldSystemFont(ofSize: 15),
                                          focusColor: .commentTextColor,
                                          focusFont: .boldSystemFont(ofSize: 15)))
            .isScrollEnabled(false)
            .limitCount(150)
            .limitLine(5)
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
            .textCount { count in
                sendState = count > 0
            }
                .focused($keyBoardState)
                .frame(width: proxy.size.width - 72, height: textViewHeight, alignment: .topLeading)
                .padding(.vertical, 16)
                .padding(.leading, 16)
            
            
            if textViewAnimationState {
                Image(sendState ? "iconInput" : "iconInputDisabled")
                    .resizable()
                    .frame(width: 24, height: 24, alignment: .topTrailing)
                    .padding(.all, 8)
                    .padding(.top, 12)
                    .padding(.leading, 4)
                    .onTapGesture {
                        keyBoardState = false
                    }
            }
        }
        .frame(height: boxHeight, alignment: .top)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .cornerRadius(textViewAnimationState ? 0 : 8)
        .padding(.horizontal, textViewAnimationState ? 0 : 20)
        .shadow(color: .black.opacity(shadowState ? 0.16 : 0), radius: 6, x: 0, y: 2)
        .offset(y: inputOffsetY)
    }
    
}

public extension LikesSendView {
    
    @ViewBuilder
    private func btnView(_ proxy: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            
            if style.type == .match {
                freeBtnView
            } else {
                if style.amberType == .free {
                    freeBtnView
                } else if style.amberType == .amber {
                    amberBtnView
                } else {
                    amberWithFreeBtnView
                }
            }
            
            Text("Cancel")
                .font(.system(size: 16, weight: .medium))
                .frame(height: 24)
                .foregroundColor(.cancelTexT)
                .padding(.vertical, 13)
                .padding(.horizontal, 14)
                .padding(.top, 4)
                .onTapGesture {
                    print("Cancel")
                    if style.mainCard == .image || style.mainCard == .video {
                        withAnimation(.spring()) {
                            openState = false
                        }
                    } else {
                        withAnimation(.linear(duration: 0.2)) {
                            openState = false
                        }
                    }
                }
        }
        .onAppear {
            print("btnView onAppear")
            withAnimation(.spring()) {
                inputOffsetY = proxy.size.width - (boxHeight / 2) - 24 + 124
                btnOffsetY = 124 + proxy.size.width - 24 + (boxHeight / 2) + 32
            }
            
            shadowState = true
        }
        .frame(maxWidth: .infinity)
        .padding(.top, btnOffsetY)
    }
    
    @ViewBuilder
    var freeBtnView: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(.yellow)
            .frame(height: 50)
            .padding(.horizontal, 12)
            .overlay {
                Text(makeAttributedString())
                    .lineLimit(1)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray20)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 13)
            }
            .onTapGesture {
                if style.type == .Like {
                    showLikeAnimation = true
                } else {
                    matchAnimation = true
                }
            }
    }
    
    @ViewBuilder
    var amberBtnView: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(.yellow)
            .frame(height: 50)
            .padding(.horizontal, 12)
            .overlay {
                HStack(spacing: 4) {
                    Image("imgAmberS")
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    Text("Amber")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray20)
                        .lineLimit(1)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 13)
            }
    }
    
    @ViewBuilder
    var amberWithFreeBtnView: some View {
        HStack(spacing: 8) {
            
            HStack(spacing: 4) {
                Image("imgAmberS")
                    .resizable()
                    .frame(width: 20, height: 20)
                
                Text("Amber")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray20)
                    .lineLimit(1)
            }
            .padding(.vertical, 13)
            .padding(.horizontal, 16)
            .frame(maxHeight: 50)
            .background(.yellow)
            .cornerRadius(25)
            
            
            RoundedRectangle(cornerRadius: 25)
                .fill(.primary300)
                .frame(height: 50)
                .overlay {
                    Text(makeAttributedString())
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray50)
                        .lineLimit(1)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 13)
                }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
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
