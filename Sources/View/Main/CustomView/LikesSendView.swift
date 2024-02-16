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
            let _ = print("proxy -> \(proxy.size)")
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
                    SUTextView(text: $commentTexT,
                               model: SUTextViewModel(placeholderText: "Add a commnent",
                                                      placeholderColor: .placeHolderColor,
                                                      placeholderFont: .boldSystemFont(ofSize: 15),
                                                      focusColor: .commentTextColor,
                                                      focusFont: .boldSystemFont(ofSize: 15)))
                        .focused($keyBoardState)
                        .frame(width: proxy.size.width - 72, height: 66, alignment: .topLeading)
//                        .fixedSize()
                        .padding(.top, 16)
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
                .matchedGeometryEffect(id: "HStack", in: animation)
                .frame(height: 98, alignment: .top)
                .frame(maxWidth: .infinity, alignment: .leading)
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
                    // 계산식 해당 VStack은 사진 bottom부터 47만큼 올라가야한다
                    // 그래서 사진은 top에 124만큼 위치해 있어서 124만큼 더해주고
                    // 사진의 아래쪽에 배치하기 위해 proxy.size.width 만큼 더해주는데
                    // 이때 사진의 크기를 최대 넓이의 좌우 여백 12만큼 준게 사진의 크기이므로
                    // 24를 빼준다. 그리고 47만큼 올라가야 하니까 47도 빼주고 나서
                    // 애니메이션을 20만큼 아래에서부터 올라오도록 설정해달라고 해서 20만큼 밀어준다
                    inputOffsetY = proxy.size.width - 49 - 24 + 124 + 20
                    
                    
                    // Match 버튼과 Cancel 버튼의 offset은 사진의 top inset, 사진의 크기, 첫 스타트 지점 20만큼 더해주고
                    // 사진의 크기가 전체 크기에서 -24만큼 여백을 준 상황이므로 24를 빼주면 완성이다
                    
                    btnOffsetY = proxy.size.width + 124 + 81 + 20 - 24
                }
                .frame(maxWidth: .infinity)
                .padding(.top, btnOffsetY)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                withAnimation(.spring()) {
                    inputOffsetY = proxy.size.width - 49 - 24 + 124
                    btnOffsetY = proxy.size.width + 124 + 81 - 24
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { output in
                print("keyboardWillShowNotification")
                if let userinfo = output.userInfo {
                    if let size = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                        guard let duration = userinfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
                            return
                        }
                        
                        let offsetY = proxy.size.height - (size.height - proxy.safeAreaInsets.bottom) - 98
                        
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
                        inputOffsetY = proxy.size.width - 49 - 24 + 124
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
