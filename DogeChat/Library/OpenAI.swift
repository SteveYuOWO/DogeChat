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

    func validateOpenAIAPIKey() -> Bool {
        guard OPEN_AI_API_KEY.count == 51 else { return false }
        guard OPEN_AI_API_KEY.hasPrefix("sk-") else { return false }
        return true
    }
    
    init(OPEN_AI_API_KEY: String, OPEN_AI_ORIGIN: String) {
        self.OPEN_AI_API_KEY = OPEN_AI_API_KEY
        self.OPEN_AI_ORIGIN = OPEN_AI_ORIGIN
    }
    
    private func getStartDateAndEndDate() -> (startDate: String, endDate: String) {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        return ("\(year)-\(month)-01", "\(year)-\(month + 1)-01")
    }
    func usage() async -> UsageResponse {
        do {
            let (startDate, endDate) = getStartDateAndEndDate()
            /// exp: /dashboard/billing/usage?end_date=2023-04-01&start_date=2023-03-01
            return try await AF.request("\(OPEN_AI_ORIGIN)/dashboard/billing/usage?end_date=\(endDate)&start_date=\(startDate)", headers: headers)
                .serializingDecodable(UsageResponse.self).value
        } catch {
            print(error.localizedDescription)
            return UsageResponse()
        }
    }
    func creditGrants() async -> CreditGrantsResponse {
        do {
            return try await AF.request("\(OPEN_AI_ORIGIN)/dashboard/billing/credit_grants", headers: headers)
                .serializingDecodable(CreditGrantsResponse.self).value
        } catch {
            print(error.localizedDescription)
            return CreditGrantsResponse(
                error: ResponseError(message: error.localizedDescription, type: "Serializing Error", code: "500")
            )
        }
    }
}

struct ResponseError: Codable {
    var message: String
    var type: String
    var param: String?
    var code: String
}

struct GrantsData: Codable {
    var object: String
    var id: String
    var grant_amount: Float
    var used_amount: Float
    var effective_at: Float
}

struct Grants: Codable {
    var object: String
    var data: [GrantsData]
}

struct UsageResponse: Codable {
    var total_usage: Float?
}

struct CreditGrantsResponse: Codable {
    var object: String?
    var total_granted: Float?
    var total_used: Float?
    var total_available: Float?
    var grants: Grants?
    var error: ResponseError?
}
