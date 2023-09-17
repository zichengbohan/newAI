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
    var storyTapPublisher = PassthroughSubject<AVSpeechSynthesisVoice, Never>()
    private var cancellables: Set<AnyCancellable> = [];
    
    private let textToSpeak: String = "你是一个英语口语练习老师，你的学生是刚开始学英语的3-6岁的儿童，词汇要尽量简单一些，不要有难懂的词汇，所有的信息都要以小于6岁儿童适应为第一准则, 用英语随便打个招呼吧，然后你要讲一个小故事。讲完一个后你要用汉语分析这个英语小故事的词汇和内容";
    
     override init() {
         super.init();
         self.speechSynthesizer.delegate = self;
         storyTapPublisher
             .sink { [self] voice in
                 speackStory(with: voice);
             }
             .store(in: &cancellables)
    }

    func speackStory(with voice: AVSpeechSynthesisVoice) {
        self.speechSynthesizer.stopSpeaking(at: .word);
        let message = Message(role: "user", content: textToSpeak)
        XAINetRequest().requestChatMessage(message: message) { [weak self] (value, success) in
            if !success {
                let content = value["result"] as! String;
                NSLog("Value:%@", content)

                let speechUtterance = AVSpeechUtterance(string: content);
                speechUtterance.voice = voice;
                self?.speechSynthesizer.speak(speechUtterance);
//                self?.speechText = value["result"] as! String;
            }
        };
    }
}

extension XBMSynthViewModel: AVSpeechSynthesizerDelegate {
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
      self.speechText = utterance.speechString;

    print("started")
  }
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
    print("paused")
  }
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {}
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {}
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
      print("")
  }
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
    print("finished")
  }
}
