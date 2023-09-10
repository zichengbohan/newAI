//
//  ContentView.swift
//  AISleepStory
//
//  Created by xbm on 2023/9/9.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    let synthesizer = AVSpeechSynthesizer() // 创建语音合成器
//    @State private var textToSpeak: String = "你是一个英语口语练习老师，你的学生是刚开始学英语的3-6岁的儿童，词汇要尽量简单一些，不要有难懂的词汇，所有的信息都要以小于6岁儿童适应为第一准则, 用英语随便打个招呼吧，你的回答最终都要以问句结束";
    @State private var textToSpeak: String = "你是一个英语口语练习老师，你的学生是刚开始学英语的3-6岁的儿童，词汇要尽量简单一些，不要有难懂的词汇，所有的信息都要以小于6岁儿童适应为第一准则, 用英语随便打个招呼吧，然后你要讲一个小故事。讲完一个后你要用汉语分析这个英语小故事的词汇和内容";
    @State private var aiSpeakContent: String = "";
    @State private var buttonTitle = "开始讲个英语故事";
    
    init() {
        let vices = AVSpeechSynthesisVoice.speechVoices(); // <--  fetch voice dependencies
        print("voices:", vices);
    }
    var body: some View {
        VStack {
//            Text("Text-to-Speech").font(.title)
//            TextEditor(text: $textToSpeak)
//                .padding()
//                .border(Color.gray, width: 1)
            GeometryReader { geometry in
                        ZStack {
                            Image("home_bg") // 替换为您的图像名称
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .clipped()
                            
                            VStack {
                                ScrollView {
                                    Text($aiSpeakContent.wrappedValue)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .padding(.top, 64)
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                                HStack {
                                    Button {
                                        speakText()
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
    
    func speakText() {
        let message = Message(role: "user", content: textToSpeak)
        XAINetRequest().requestChatMessage(message: message) { value in
            print("value", value["result"])
            let speechUtterance = AVSpeechUtterance(string: value["result"] as! String);
//            speechUtterance.voice = AVSpeechSynthesisVoice(language: "zh-CN");
            self.synthesizer.speak(speechUtterance);
            aiSpeakContent = value["result"] as! String;
        };
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
