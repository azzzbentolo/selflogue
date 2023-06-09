//
//  Quote.swift
//  selflogue
//
//  Created by Chew Jun Pin on 29/4/2023.
//

import Foundation


/// Quote is a class responsible for requesting a random quote from the quotable API.
///
/// It follows the OOP (Object-Oriented Programming) principles.
/// The Quote class encapsulates the functionality related to fetching quotes, including building the request URL, sending the network request, and parsing the response.
///
/// It has properties for the quote content and author, which are updated after a successful network request.
/// The requestQuote(maxLength:) method performs an asynchronous network request to retrieve a random quote with a maximum length.
///
/// The Quote class plays a role in providing quotes to the MainViewController, which then displays the fetched quote on the UI.


class Quote {
    
    
    let BASEURL = "https://api.quotable.io"
    var quote: String?
    var quoteAuthor: String?

    
    func requestQuote(maxLength: Int) async {
        
        guard let requestURL = URL(string: "\(BASEURL)/random?maxLength=\(maxLength)") else {
            print("Invalid URL.")
            return
        }
        
        let urlRequest = URLRequest(url: requestURL)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            do {
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



    
    


  
