//
//  Quote.swift
//  selflogue
//
//  Created by Chew Jun Pin on 29/4/2023.
//

import Foundation

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



    
    


  
