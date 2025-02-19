//
//  Request.swift
//  Eagle_Pop
//
//  Created by 최시훈 on 2023/09/08.
//

import Foundation
import Alamofire

class Requests {
    static func simple(_ url: String,
                       _ method: HTTPMethod,
                       params: [String: Any]? = nil,
                       completion: @escaping () -> Void) {
        AF.request(url,
                   method: method,
                   parameters: params,
                   encoding: method == .get ? URLEncoding.default : JSONEncoding.default,
                   interceptor: Interceptor()
        )
        .validate()
        .responseData { response in
            switch response.result {
            case .success:
                completion()
            case .failure:
                print("error")
            }
        }
    }
    
    static func request<T: Codable>(_ url: String,
                                    _ method: HTTPMethod,
                                    params: [String: Any]? = nil,
                                    _ model: T.Type,
                                    completion: @escaping (T) -> Void) {
        AF.request(url,
                   method: method,
                   parameters: params,
                   encoding: method == .get ? URLEncoding.default : JSONEncoding.default,
                   headers: ["Authorization": "KakaoAK"],
                   interceptor: Interceptor()
        )
        .validate()
        .responseData { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    if let decodedData = try? decoder.decode(T.self, from: data) {
                        DispatchQueue.main.async {
                            completion(decodedData)
                        }
                    }
                }
            case .failure:
                print("error")
            }
        }
    }
}

