//
//  BookControl.swift
//  ConsultaLibros
//
//  Created by Developer 1 on 4/9/18.
//  Copyright © 2018 comDeveloper. All rights reserved.
//

import UIKit

class BookControl {
    
    struct  Book {
        var name : String
        var isbn : String
        var cover : UIImage?
        var authors: String
        var description: String
        var publisher: String
        var publishedDate: String
        
        init() {
            self.name = ""
            self.isbn = ""
            self.authors = ""
            self.cover = nil
            self.description = ""
            self.publisher = ""
            self.publishedDate = ""
        }
        
        init(name:String, isbn:String, cover:UIImage?, authors:String) {
            self.name = name
            self.isbn=isbn
            self.cover = cover
            self.authors = authors
            self.description = ""
            self.publisher = ""
            self.publishedDate = ""
        }
        
        init(name:String, isbn:String, cover:UIImage?, authors:String, description: String, publisher: String, publishedDate: String) {
            self.name = name
            self.isbn=isbn
            self.cover = cover
            self.authors = authors
            self.description = description
            self.publisher = publisher
            self.publishedDate = publishedDate
        }
    }    
}
