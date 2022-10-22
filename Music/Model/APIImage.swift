//
//  APIImage.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/25.
//

import Foundation

struct APIImage: Codable {
    let url: URL?
    
    private enum CodingKeys: String, CodingKey {
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let urlStr = try container.decode(String.self, forKey: .url)
        url = URL(string: urlStr)
    }
    
    init(url: URL?) {
        self.url = url
    }
}
