//
//  OpenAI.swift
//  DogeChat
//
//  Created by Steve Yu on 2023/3/21.
//

import Foundation
import OpenAIStreamingCompletions
import Alamofire

class OpenAIAPITools {
    let OPEN_AI_API_KEY: String
    let OPEN_AI_ORIGIN: String
    
    var headers: HTTPHeaders {
        [
            "Authorization": "Bearer \(OPEN_AI_API_KEY)",
            "Accept": "application/json"
        ]
    }

    
    func validateOpenAIAPIKey() async -> Bool {
        guard OPEN_AI_API_KEY.count == 51 else { return false }
        guard OPEN_AI_API_KEY.hasPrefix("sk-") else { return false }
        return (await self.creditGrants()).error == nil
    }
    
    init(OPEN_AI_API_KEY: String, OPEN_AI_ORIGIN: String) {
        self.OPEN_AI_API_KEY = OPEN_AI_API_KEY
        self.OPEN_AI_ORIGIN = OPEN_AI_ORIGIN
    }
    
    func creditGrants() async -> CreditGrantsResponse {
//        let value = try await AF.request("\(OPEN_AI_ORIGIN)/dashboard/billing/credit_grants").serializingDecodable(TestResponse.self).value
        return try! await AF.request("\(OPEN_AI_ORIGIN)/dashboard/billing/credit_grants", headers: headers)
            .serializingDecodable(CreditGrantsResponse.self).value
    }
}

struct ResponseError: Codable {
    var message: String
    var type: String
    var param: String?
    var code: String
}

struct CreditGrantsResponse: Codable {
    var error: ResponseError?
}
