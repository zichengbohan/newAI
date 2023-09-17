//
//  SpeakText.swift
//  AISleepStory
//
//  Created by xbm on 2023/9/17.
//
//    @State private var textToSpeak: String = "你是一个英语口语练习老师，你的学生是刚开始学英语的3-6岁的儿童，词汇要尽量简单一些，不要有难懂的词汇，所有的信息都要以小于6岁儿童适应为第一准则, 用英语随便打个招呼吧，你的回答最终都要以问句结束";
   

import Foundation

struct SpeakText: Identifiable, Hashable {
    var id = UUID();
    var content: String;
}
