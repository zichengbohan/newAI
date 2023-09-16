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
     
//    @State private var aiSpeakContent: String = "";
    @State private var buttonTitle = "开始讲个英语故事";
    @State private var selectedVoice = AVSpeechSynthesisVoice();
    
    var body: some View {
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
                            NavigationLink(destination: SelectSpeakerView(selectedVoice: $selectedVoice)) {
                                Text("选择喜欢的声音")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.bottom, 20)

                            }
                            HStack {
                                Button {
                                    viewModel.storyTapPublisher.send(selectedVoice);
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
