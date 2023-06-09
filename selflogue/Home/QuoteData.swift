//
//  BookData.swift
//  Week05Lab
//
//  Created by Chew Jun Pin on 5/4/2023.
//

import UIKit


/// QuoteData is a model class that represents the structure of a quote received from the quotable API.
///
/// It conforms to the Decodable protocol to facilitate the decoding of JSON data into Swift objects.
/// The QuoteData class defines properties for the quote content and author.
/// It has a required initializer that performs the decoding of the quote data from a decoder.
///
/// QuoteData adheres to the OOP principles by encapsulating the quote data and providing a clear representation of the data structure.
///
/// QuoteData is used by the Quote class to decode the JSON response received from the API and extract the relevant quote information.


class QuoteData: NSObject, Decodable {
    
    var content: String?
    var author: String?
    
    private enum QuoteKeys: String, CodingKey {
        case content
        case author
    }
    
    required init(from decoder: Decoder) throws {
        
        let quoteContainer = try decoder.container(keyedBy: QuoteKeys.self)
        
        // Get the quote info
        content = try quoteContainer.decode(String.self, forKey: .content)
        author = try quoteContainer.decode(String.self, forKey: .author)
        
    }
    
}
