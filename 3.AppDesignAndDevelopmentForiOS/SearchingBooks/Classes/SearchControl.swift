//
//  SearchControl.swift
//  SearchingBooks
//
//  Created by Developer 1 on 4/22/18.
//  Copyright © 2018 comDeveloper. All rights reserved.
//

import UIKit
class SearchControl {    
    struct  Search {
        var criteria : String
        var books : [BookControl.Book]
        
        init() {
            self.criteria = ""
            self.books = []
        }
    }
}
