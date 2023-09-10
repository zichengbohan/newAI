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
    @State private var textToSpeak: String = "Hello, this is a text-to-speech example."
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
                                Spacer()
                                HStack {
                                    Button {
                                        speakText()
                                    } label: {
                                        Text("Speak")
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
        let message = Message(role: "user", content: "介绍一下你自己, use english")
        XAINetRequest().requestChatMessage(message: message) { value in
            print("value", value["result"])
            let speechUtterance = AVSpeechUtterance(string: value["result"] as! String);
//            speechUtterance.voice = AVSpeechSynthesisVoice(language: "zh-CN");
            self.synthesizer.speak(speechUtterance);        };
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
