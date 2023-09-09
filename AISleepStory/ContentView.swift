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
        AVSpeechSynthesisVoice.speechVoices() // <--  fetch voice dependencies
      }
    var body: some View {
        VStack {
            Text("Text-to-Speech").font(.title)
            TextEditor(text: $textToSpeak)
                .padding()
                .border(Color.gray, width: 1)
            Button {
                speakText()
                
            } label: {
                Text("Speak")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(.blue)
                    .cornerRadius(12)
            }
        }
        .padding()
    }
    
    func speakText() {
        let speechUtterance = AVSpeechUtterance(string: textToSpeak)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        self.synthesizer.speak(speechUtterance)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
