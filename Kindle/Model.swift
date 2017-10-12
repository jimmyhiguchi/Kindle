//
//  Model.swift
//  Kindle
//
//  Created by Jimmy Higuchi on 10/5/17.
//  Copyright © 2017 Jimmy Higuchi. All rights reserved.
//

import UIKit

// create Classes here:
class Book {
    let title: String
    let author: String
    let pages: [Page]
    let coverImageUrl: String
    
    init(dictionary: [String: Any]) {
        title = dictionary["title"] as? String ?? ""
        author = dictionary["author"] as? String ?? ""
        coverImageUrl = dictionary["coverImageUrl"] as? String ?? ""
        
        var bookPages = [Page]()
        
        // loading page content from JSON
        // note: [[String: Any]] casting to Array of dictionary
        if let pageDictionaries = dictionary["pages"] as? [[String: Any]] {

            for pageDictionary in pageDictionaries {
                
                if let pageText = pageDictionary["text"] as? String {
                    let page = Page(number: 1, text: pageText)
                    
                    bookPages.append(page)
                }
            }
        }
        pages = bookPages
    }
}

class Page {
    let number: Int
    let text: String
    
    init(number: Int, text: String) {
        self.number = number
        self.text = text
    }
}
