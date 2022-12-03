//
//  PictureListNetworking.swift
//  Picsum
//
//  Created by Megi Sila on 3.12.22.
//

import Foundation

protocol PictureListNetworkingProtocol {
    func getPictures(completion: @escaping (_ success: Bool, _ results: Pictures?, _ error: String?) -> ())
}

class PictureListNetworking: PictureListNetworkingProtocol {
    func getPictures(completion: @escaping (Bool, Pictures?, String?) -> ()) {
        let url = "https://picsum.photos/v2/list?"
        let header = "application_json"
        let method = "GET"
        
        guard let url = URL(string: url) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue(header, forHTTPHeaderField: "Content-Type")
        
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(false, nil, "🚩Error: Cannot call GET")
                return
            }
            guard let data = data else {
                completion(false, nil, "🚩Error: Cannot receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                completion(false, nil, "🚩Error: GET request failed")
                return
            }
            
            do {
                let model = try JSONDecoder().decode(Pictures.self, from: data)
                completion(true, model, nil)
            } catch {
                completion(false, nil, "🚩Error: Trying to parse data to Pictures model")
            }
        }.resume()
    }
}
