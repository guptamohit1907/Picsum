//
//  Extensions.swift
//  Picsum
//
//  Created by Megi Sila on 3.12.22.
//

import UIKit

// MARK: - Optimises the download URL by descreasing width and height parameters
extension String {
    func optimiseURL() -> String {
        let urlWoHeight = self.replacingCharacters(in: self.lastIndex(of: "/")!..<self.endIndex, with: "")
        let urlWoHeightWidth = urlWoHeight.replacingCharacters(in: urlWoHeight.lastIndex(of: "/")!..<urlWoHeight.endIndex, with: "")
        
        return urlWoHeightWidth.appending("/500/300")
    }
}
