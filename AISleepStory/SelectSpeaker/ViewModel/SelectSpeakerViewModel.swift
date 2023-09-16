//
//  SelectSpeakerViewModel.swift
//  AISleepStory
//
//  Created by xbm on 2023/9/15.
//

import Foundation
import Combine
import AVFoundation

class SelectSpeakerViewModel: ObservableObject {
    var items: [Speaker] = [];
    
    init() {
        AVSpeechSynthesisVoice.speechVoices() // <--  fetch voice dependencies
        let voices = AVSpeechSynthesisVoice.speechVoices(); // <--  fetch voice dependencies
        for voice in voices {
            if voice.language == "en-US" {
                print(voice);
                let speaker = Speaker(name: voice.name, voice: voice);
                
                items.append(speaker);
            }
        }
    }
    
}
