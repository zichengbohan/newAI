//
//  XAINetRequest.swift
//  AISleepStory
//
//  Created by xbm on 2023/9/9.
//

import Foundation
import Alamofire

// 定义目标 URL
let url = "https://aip.baidubce.com/rpc/2.0/ai_custom/v1/wenxinworkshop/chat/eb-instant?access_token=24.adb6e3730b9220660975554727a0ee4f.2592000.1701083283.282335-39059758"

struct DecodableType: Decodable { let url: String }
struct Message: Codable {
    let role: String
    let content: String
}

struct Paramters: Encodable {
    var messages: [Message]
    var stream: Bool
}

class XAINetRequest {
    
    public func requestChatMessage(message: Message, sucessBack: @escaping (NSDictionary, Bool) -> Void) {
        let param = Paramters(messages: [message], stream: false);
        NSLog("SpeakerStart")
        AF.request(url, method: .post, parameters: param, encoder: JSONParameterEncoder.default)
            .validate() // 可选：用于验证响应的状态码和内容
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    // 请求成功，处理返回的 JSON 数据
                    NSLog("Speakerend")

                    print("JSON 响应：\(value)")
                    sucessBack(value as! NSDictionary, false);
                case .failure(let error):
                    // 请求失败，处理错误
                    print("请求失败：\(error)")
                }
            }
    }
    
    public func requestChatMessageStream(message: Message, sucessBack: @escaping (NSDictionary, Bool) -> Void) {
        let param = Paramters(messages: [message], stream: true);
        NSLog("SpeakerStart")
        AF.streamRequest(url, method: .post, parameters: param, encoder: JSONParameterEncoder.default)
            .responseStreamString { stream in
            switch stream.event {
            case let .stream(result):
                switch result {
                case let .success(string):
                    NSLog("Speakerend")
                    let jsonString = string.replacingOccurrences(of: "data:", with: "");
                    if let data = jsonString.data(using: .utf8) {
                        do {
                            if let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                                // 使用转换后的字典
                                print(dictionary)
                                sucessBack(dictionary, false);
                            }
                        } catch {
                            print("转换失败：\(error.localizedDescription)")
                        }
                    }
                }
            case let .complete(completion):
                print(completion)
                sucessBack([:], true);

            }
        }
    }
}
