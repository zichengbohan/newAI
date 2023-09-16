//
//  ContentView.swift
//  AISleepStory
//
//  Created by xbm on 2023/9/9.
//

import SwiftUI
import AVFoundation
import Combine

struct XBMSpeechStoryView: View {
    @ObservedObject var viewModel = XBMSynthViewModel()
//    @State private var textToSpeak: String = "你是一个英语口语练习老师，你的学生是刚开始学英语的3-6岁的儿童，词汇要尽量简单一些，不要有难懂的词汇，所有的信息都要以小于6岁儿童适应为第一准则, 用英语随便打个招呼吧，你的回答最终都要以问句结束";
     private let textToSpeak: String = "你是一个英语口语练习老师，你的学生是刚开始学英语的3-6岁的儿童，词汇要尽量简单一些，不要有难懂的词汇，所有的信息都要以小于6岁儿童适应为第一准则, 用英语随便打个招呼吧，然后你要讲一个小故事。讲完一个后你要用汉语分析这个英语小故事的词汇和内容";
//    @State private var aiSpeakContent: String = "";
    @State private var buttonTitle = "开始讲个英语故事";
    
    init() {
       AVSpeechSynthesisVoice.speechVoices() // <--  fetch voice dependencies
       let vices = AVSpeechSynthesisVoice.speechVoices(); // <--  fetch voice dependencies
       print("voices:", vices);
      }
    
    var body: some View {
        @StateObject var listViewModel = SelectSpeakerViewModel()
        @State var isListVisible = false

        NavigationView {
            
            VStack {
                GeometryReader { geometry in
                    ZStack {
                        Image("home_bg") // 替换为您的图像名称
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                        
                        VStack {
                            ScrollView {
                                Text(viewModel.speechText)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding(.top, 64)
                                    .foregroundColor(.white)
                            }
//                            Button("显示列表") {
//                                                listViewModel.updateData(with: ["Item 1", "Item 2", "Item 3"])
//                                                isListVisible = true
//                                            }
//                                            .padding()
//                                            .background(Color.blue)
//                                            .foregroundColor(.white)
//                                            .cornerRadius(10)
//                                            .sheet(isPresented: $isListVisible) {
//                                                SelectSpeakerView(viewModel: listViewModel)
//                                            }
                            NavigationLink(destination: SelectSpeakerView(viewModel: SelectSpeakerViewModel())) {
                                Text("选择人物")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.bottom, 20)

                            }
                            HStack {
                                Button {
                                    viewModel.storyTapPublisher.send(textToSpeak);
                                } label: {
                                    Text($buttonTitle.wrappedValue)
                                        .frame(maxWidth: .infinity)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(.blue)
                                        .cornerRadius(16)
                                }
                                .padding(.horizontal, 20) // 设置按钮两边距离为 20 点
                            }
                            .padding(.bottom, 40) // 设置按钮与底部距离为 20 点
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        XBMSpeechStoryView()
    }
}
