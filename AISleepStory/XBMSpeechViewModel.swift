//
//  XBMSpeechViewModel.swift
//  AISleepStory
//
//  Created by xbm on 2023/9/10.
//

import Foundation
import AVFoundation
import Combine


class XBMSynthViewModel: NSObject, ObservableObject {
    let speechSynthesizer = AVSpeechSynthesizer() // 创建语音合成器
    @Published var speechText: String = ""
    var storyTapPublisher = PassthroughSubject<String, Never>()
    private var cancellables: Set<AnyCancellable> = [];

    
     override init() {
         super.init();
         self.speechSynthesizer.delegate = self;
         storyTapPublisher
             .sink { [self] sayHello in
                 speackStory(textToSpeak: sayHello);
             }
             .store(in: &cancellables)
    }

    func speackStory(textToSpeak: String) {
        let message = Message(role: "user", content: textToSpeak)
        XAINetRequest().requestChatMessage(message: message) { [weak self] value in
            print("value", value["result"])
            let speechUtterance = AVSpeechUtterance(string: value["result"] as! String);
//            speechUtterance.voice = AVSpeechSynthesisVoice(language: "zh-CN");
            self?.speechSynthesizer.speak(speechUtterance);
            self?.speechText = value["result"] as! String;
        };
    }
}

extension XBMSynthViewModel: AVSpeechSynthesizerDelegate {
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
    print("started")
  }
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
    print("paused")
  }
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {}
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {}
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {}
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
    print("finished")
  }
}
