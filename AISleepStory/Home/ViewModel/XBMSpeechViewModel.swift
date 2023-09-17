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
    let speechSynthesizer = AVSpeechSynthesizer(); // 创建语音合成器
    @Published var speechTexts: [SpeakText];
    @Published var willSpeakItem: SpeakText = SpeakText(content: "");
    @Published var speakLocation = 0;
    @Published var isPausing = false;
    var storyTapPublisher = PassthroughSubject<AVSpeechSynthesisVoice, Never>();
    private var cancellables: Set<AnyCancellable> = [];
    private let textToSpeak: String = "你是一个英语口语练习老师，你的学生是刚开始学英语的3-6岁的儿童，词汇要尽量简单一些，不要有难懂的词汇，所有的信息都要以小于6岁儿童适应为第一准则, 用英语随便打个招呼吧，然后你要讲一个小故事。讲完一个后你要用汉语分析这个英语小故事的词汇和内容";
    let separators = CharacterSet(charactersIn: ".?!")

     override init() {
         self.speechTexts = [];
         super.init();
         self.speechSynthesizer.delegate = self;
         storyTapPublisher
             .sink { [self] voice in
                 speackStory(with: voice);
             }
             .store(in: &cancellables)
    }

    func speackStory(with voice: AVSpeechSynthesisVoice) {
        self.stopSpeak();
        let message = Message(role: "user", content: textToSpeak)
        XAINetRequest().requestChatMessage(message: message) { [weak self] (value, success) in
            guard let strongSelf = self else {
                return // self 已释放
            }
            let content = value["result"] as! String;
            NSLog("Value:%@", content)
            strongSelf.processWords(with: content);
            for speakText in strongSelf.speechTexts {
                let speechUtterance = AVSpeechUtterance(string: speakText.content);
                speechUtterance.voice = voice;
                strongSelf.speechSynthesizer.speak(speechUtterance);
            }
        };
    }
    
    // 处理返回的内容
    func processWords(with content: String) {
        let contents = content.components(separatedBy: separators);
        for content in contents {
            let speakText = SpeakText(content: content);
            self.speechTexts.append(speakText);
        }
    }
    
    // 停止说话
    func stopSpeak() {
        self.speechSynthesizer.stopSpeaking(at: .word);
        self.speechTexts = [];
        self.speakLocation = 0;
        self.willSpeakItem = SpeakText(content: "");
    }
    
    // 暂停说话
    func pauseSpeak() {
        self.speechSynthesizer.pauseSpeaking(at: .immediate);
        self.isPausing = true;
    }
    
    func continueSpeak()  {
        self.speechSynthesizer.continueSpeaking();
        self.isPausing = false;
    }
    
}

extension XBMSynthViewModel: AVSpeechSynthesizerDelegate {
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
      print("started")
      self.willSpeakItem = self.speechTexts[self.speakLocation];
      self.speakLocation += 1;
  }
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
    print("paused")
  }
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {}
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {}
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
      let content = utterance.speechString;
      let startIndex = content.index(content.startIndex, offsetBy: characterRange.location)
      let endIndex = content.index(content.startIndex, offsetBy: characterRange.location + characterRange.length);
      print("willSpeakRangeOfSpeechString", characterRange.location , "," , characterRange.length)
  }
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
    print("finished")
  }
}
