//
//  db.swift
//  SearchingBooks
//
//  Created by Developer 1 on 4/13/18.
//  Copyright © 2018 comDeveloper. All rights reserved.
//

import UIKit
import CoreData

public class db {
    static var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Section Control
    
    static func queryExample(){
        //Para los procedimiento almacenados, debe ir un custom predicate field == $parametro
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        //Let’s work on our request. We want to fetch just a one record:
        userFetch.fetchLimit = 1
        
        //and only when a name is “John”:
        userFetch.predicate = NSPredicate(format: "name = %@", "John")
        
        //Moreover, we want to sort by an email address with ascending order:
        userFetch.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: true)]
        
        //Let’s execute the query:
        //let users = try! self.context.fetch(userFetch)
        
        //Now we can pick the first result and print how many cars he has :)
        /*let john: User = users.first as! User
         print("Email: \(john.email!)")
         let johnCars = john.cars?.allObjects as! [Car]
         print("has \(johnCars.count)")*/
        
        
        /*
         let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
         request.predicate = NSPredicate(format: "age = %@", "12")
         request.returnsObjectsAsFaults = false
         do {
         let result = try context.fetch(request)
         for data in result as! [NSManagedObject] {
         print(data.value(forKey: "username") as! String)
         }
         
         } catch {
         
         print("Failed")
         }
         */
    }
    
    static func verifyBook(isbn: String) -> Bool {
        //Query with a storeProcedure
        
        let objReceived = NSEntityDescription.entity(forEntityName: "Book", in: self.context)
        let request = objReceived?.managedObjectModel.fetchRequestFromTemplate(withName: "getBook", substitutionVariables: ["isbn" : isbn])
        
        do{
            let requestResult = try self.context.fetch(request!)
            
            if requestResult.count > 0{
                return true
            }
            else{
                return false
            }
        }
        catch{
            return false
        }
    }
    
    static func getBook(isbn: String) -> BookControl.Book{
        var book = BookControl.Book()
        
        let objReceived = NSEntityDescription.entity(forEntityName: "Book", in: self.context)
        let request = objReceived?.managedObjectModel.fetchRequestFromTemplate(withName: "getBook", substitutionVariables: ["isbn" : isbn])
        
        do{
            let requestResult = try self.context.fetch(request!)
            
            if requestResult.count > 0{
                let data = requestResult.first as! NSManagedObject
                
                book.name = data.value(forKey: "name") as! String
                book.isbn = data.value(forKey: "isbn") as! String
                book.authors = data.value(forKey: "authors") as! String
                let coverImg = data.value(forKey: "cover") as! NSData
                if let cover = UIImage(data: coverImg as Data){
                    book.cover = cover
                }
                else{
                    book.cover = #imageLiteral(resourceName: "imgNotAvailable")
                }
            }
        }
        catch{
        }
        
        return book
    }
    
    static func deleteBook(isbn: String) -> Bool{
        
        let objReceived = NSEntityDescription.entity(forEntityName: "Book", in: self.context)
        let request = objReceived?.managedObjectModel.fetchRequestFromTemplate(withName: "getBook", substitutionVariables: ["isbn" : isbn])
        
        do{
            let requestResult = try self.context.fetch(request!)
            
            if requestResult.count > 0{
                self.context.delete(requestResult.first as! NSManagedObject)
                return true
            }
            else{
                return false                
            }
        }
        catch{
            return false
        }
    }
    
    static func getBooks() ->[BookControl.Book] {
        var books: [BookControl.Book] = []
        
        let objReceived = NSEntityDescription.entity(forEntityName: "Book", in: self.context)
        let request = objReceived?.managedObjectModel.fetchRequestTemplate(forName: "getBooks")
        
        do{
            let result = try self.context.fetch(request!)
            
            for data in result as! [NSManagedObject] {
                
                var book = BookControl.Book()
                
                book.name = data.value(forKey: "name") as! String
                book.isbn = data.value(forKey: "isbn") as! String
                book.authors = data.value(forKey: "authors") as! String
                 book.pages = data.value(forKey: "pages") as! String
                 book.publishedDate = data.value(forKey: "publishedDate") as! String
                 book.publisher = data.value(forKey: "publisher") as! String
                 book.description = data.value(forKey: "review") as! String
                let coverImg = data.value(forKey: "cover") as! NSData
                if let cover = UIImage(data: coverImg as Data){
                    book.cover = cover
                }
                else{
                    book.cover = #imageLiteral(resourceName: "imgNotAvailable")
                }
                books.append(book)
            }
        }
        catch{
        }
        
        return books
    }
    
    static func addBook(name:String, isbn:String, cover:UIImage, authors:String) {
        let bookEntity = NSEntityDescription.entity(forEntityName: "Book", in: self.context)!
        let book = NSManagedObject(entity: bookEntity, insertInto: self.context)
        
        book.setValue(name, forKey: "name")
        book.setValue(isbn, forKey: "isbn")
        book.setValue(authors, forKey: "authors")
        book.setValue(UIImagePNGRepresentation(cover), forKey: "cover")
    }
    
    static func addBook(bookItem: BookControl.Book) {
        let bookEntity = NSEntityDescription.entity(forEntityName: "Book", in: self.context)!
        let book = NSManagedObject(entity: bookEntity, insertInto: self.context)
        
        book.setValue(bookItem.name, forKey: "name")
        book.setValue(bookItem.isbn, forKey: "isbn")
        book.setValue(bookItem.authors, forKey: "authors")
        book.setValue(bookItem.pages, forKey: "pages")
        book.setValue(bookItem.publishedDate, forKey: "publishedDate")
        book.setValue(bookItem.publisher, forKey: "publisher")
        book.setValue(bookItem.description, forKey: "review")
        book.setValue(UIImagePNGRepresentation(bookItem.cover!), forKey: "cover")
    }
    
    static func save(){
        do{
            try self.context.save()
        }
        catch{
        }
    }
}

