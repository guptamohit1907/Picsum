//
//  Picture.swift
//  Picsum
//
//  Created by Megi Sila on 3.12.22.
//

import Foundation

typealias Pictures = [Picture]

// MARK: - Picture
struct Picture: Codable {
    let id, author: String
    let width, height: Int
    let url, downloadURL: String

    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }
}
