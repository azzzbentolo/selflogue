//
//  BookData.swift
//  Week05Lab
//
//  Created by Chew Jun Pin on 5/4/2023.
//

import UIKit

class QuoteData: NSObject, Decodable {
    
    var content: String?
    var author: String?
    
    private enum QuoteKeys: String, CodingKey {
        case content
        case author
    }
    
    required init(from decoder: Decoder) throws {
        
        // Get the book container for most info
        let quoteContainer = try decoder.container(keyedBy: QuoteKeys.self)
        
        // Get the quote info
        content = try quoteContainer.decode(String.self, forKey: .content)
        author = try quoteContainer.decode(String.self, forKey: .author)
        
    }
    
}
