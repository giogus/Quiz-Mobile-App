//
//  Service.swift
//  Quiz
//
//  Created by Gustavo Severo on 09/02/20.
//  Copyright © 2020 Severo. All rights reserved.
//

import UIKit

// MARK: Router Enum
enum Router {
    case getQuiz
    
    var endpoint: String {
        switch self {
        case .getQuiz:
            return AppConstants.quizEndpoint
        }
    }
    
    var method: String {
        switch self {
        case .getQuiz:
            return "GET"
        }
    }
}

// MARK: Service Class
class Service {
    class func request<T: Codable>(router: Router, completion: @escaping (T?) -> ()) {

        let session = URLSession(configuration: .default)
        guard let url = URL(string: router.endpoint) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else { return }
            guard response != nil else { return }
            guard let data = data else { return }
            
            let response = try? JSONDecoder().decode(T.self, from: data)
            
            DispatchQueue.main.async {
                completion(response)
            }
        }
        dataTask.resume()
      }
}
