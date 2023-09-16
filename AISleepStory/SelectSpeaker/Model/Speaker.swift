//
//  Speaker.swift
//  AISleepStory
//
//  Created by xbm on 2023/9/16.
//

import Foundation

struct Speaker: Identifiable, Hashable  {
    var id = UUID();
    var language: String;
    var name: String;
    var identifier: String;
}

#if DEBUG
let testData = [
    Speaker(language: "en-US", name: "Samantha", identifier: "com.apple.voice.enhanced.en-US.Samantha"),
    Speaker(language: "en-US", name: "Flo", identifier: "com.apple.eloquence.en-US.Flo")
];

#endif
