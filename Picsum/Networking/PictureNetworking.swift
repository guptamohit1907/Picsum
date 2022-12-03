//
//  PictureNetworking.swift
//  Picsum
//
//  Created by Megi Sila on 3.12.22.
//

import UIKit

enum Filter {
    case none
    case blur
    case grayscale
}

class PictureNetworking {
    func getFilteredPicture(url: String, filter: Filter, completion: @escaping (Bool, String?, _ image: UIImage?) -> ()) {
        let header = "application_json"
        var param = ""
        let method = "GET"
        
        switch filter {
        case .none:
            param = ""
        case .grayscale:
            param = "grayscale"
        case .blur:
            param = "blur"
        }
        guard let url = URL(string: "\(url)?\(param)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue(header, forHTTPHeaderField: "Content-Type")
        
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(false, "🚩Error: Cannot call GET", nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                completion(false, "🚩Error: GET request failed", nil)
                return
            }
            
            let responseURL = response.value(forKey: "URL") as! NSURL
            if let data = try? Data(contentsOf: responseURL as URL) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(true, nil, image)
                    }
                }
            }
        }.resume()
    }
    
    func getBlurredRatioPicture(url: String, ratio: Int, completion: @escaping (Bool, String?, _ image: UIImage?) -> ()) {
        let header = "application_json"
        let method = "GET"
        
        guard let url = URL(string: "\(url)?blur=\(ratio)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue(header, forHTTPHeaderField: "Content-Type")
        
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(false, "🚩Error: Cannot call GET", nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                completion(false, "🚩Error: GET request failed", nil)
                return
            }
            
            let responseURL = response.value(forKey: "URL") as! NSURL
            print("Url with blur ratio is: \(responseURL)")
            if let data = try? Data(contentsOf: responseURL as URL) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(true, nil, image)
                    }
                }
            }
        }.resume()
    }
}
