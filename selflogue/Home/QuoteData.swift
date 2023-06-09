import UIKit


/// `QuoteData` is a model class that represents the structure of a quote received from the quotable API.
///
/// It conforms to the Decodable protocol to facilitate the decoding of JSON data into Swift objects.
/// The `QuoteData `class defines properties for the quote content and author.
/// It has a required initializer that performs the decoding of the quote data from a decoder.
///
/// `QuoteData` adheres to the OOP principles by encapsulating the quote data and providing a clear representation of the data structure.
///
/// `QuoteData` is used by the `Quote` class to decode the JSON response received from the API and extract the relevant quote information.


// This class represents the quote data fetched from the API.
class QuoteData: NSObject, Decodable {
    
    // The content of the quote.
    var content: String?
    
    // The author of the quote.
    var author: String?
    
    
    // The keys used in JSON response.
    private enum QuoteKeys: String, CodingKey {
        case content
        case author
    }
    
    
    // Init method to decode JSON response.
    required init(from decoder: Decoder) throws {
        
        // Creating a decoding container.
        let quoteContainer = try decoder.container(keyedBy: QuoteKeys.self)
        
        // Decoding the quote information.
        content = try quoteContainer.decode(String.self, forKey: .content)
        author = try quoteContainer.decode(String.self, forKey: .author)
        
    }
    
}
