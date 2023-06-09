import Foundation


/// `Quote` is a class responsible for requesting a random quote from the quotable API.
///
/// It follows the OOP principles.
/// The `Quote` class encapsulates the functionality related to fetching quotes, including building the request URL, sending the network request, and parsing the response.
///
/// It has properties for the quote content and author, which are updated after a successful network request.
/// The `requestQuote(maxLength:)` method performs an asynchronous network request to retrieve a random quote with a maximum length.
///
/// The `Quote` class plays a role in providing quotes to the `MainViewController`, which then displays the fetched quote on the UI.


// This class manages requesting a quote from the API.
class Quote {
    
    
    // The base URL of the quote API.
    let BASEURL = "https://api.quotable.io"
    
    // The quote retrieved from the API.
    var quote: String?
    
    // The author of the retrieved quote.
    var quoteAuthor: String?

    
    // This method makes an API request to fetch a quote.
    func requestQuote(maxLength: Int) async {
        
        // Building the request URL.
        guard let requestURL = URL(string: "\(BASEURL)/random?maxLength=\(maxLength)") else {
            print("Invalid URL.")
            return
        }
        
        // Creating a URLRequest object.
        let urlRequest = URLRequest(url: requestURL)
        
        // Fetching data from API.
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            do {
                // Decoding the data.
                let decoder = JSONDecoder()
                let quoteData = try decoder.decode(QuoteData.self, from: data)
                if let content = quoteData.content {
                    quote = content
                }
                if let author = quoteData.author {
                    quoteAuthor = author
                }
            }
            catch let error { print(error) }
        }
        catch let error { print(error) }
            
    }
    
}



    
    


  
