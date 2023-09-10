//
//  XAINetRequest.swift
//  AISleepStory
//
//  Created by xbm on 2023/9/9.
//

import Foundation
import Alamofire

// 定义目标 URL
let url = "https://aip.baidubce.com/rpc/2.0/ai_custom/v1/wenxinworkshop/chat/eb-instant?access_token=24.e0005181b8a7083658d05f9a68f142f5.2592000.1696865676.282335-39059758"

struct DecodableType: Decodable { let url: String }
struct Message: Codable {
    let role: String
    let content: String
}



class XAINetRequest {
    
    public func requestChatMessage(message: Message, sucessBack: @escaping (NSDictionary) -> Void) {
        let parameters: [String: [Message]] = [
            "messages": [message]
        ];

        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate() // 可选：用于验证响应的状态码和内容
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    // 请求成功，处理返回的 JSON 数据
                    print("JSON 响应：\(value)")
                    sucessBack(value as! NSDictionary);
                case .failure(let error):
                    // 请求失败，处理错误
                    print("请求失败：\(error)")
                }
            }
        
    }
}
