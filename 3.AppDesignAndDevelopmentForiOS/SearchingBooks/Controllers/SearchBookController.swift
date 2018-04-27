//
//  AddBookController.swift
//  ConsultaLibros
//
//  Created by Developer 1 on 4/3/18.
//  Copyright © 2018 comDeveloper. All rights reserved.
//

import UIKit
private let reuseIdentifier = "resultCell"
var spinner = Spinner()
class SearchBookController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
        
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var divContainer: UIView!
    var search : SearchControl.Search = SearchControl.Search()
    
    @IBAction func searchBook(_ sender: UITextField) {
        spinner.showSpinner(message: "Searching", controller: self)
        search = SearchControl.Search()
        divContainer.isHidden = true
        sender.resignFirstResponder()
        let criteria = sender.text!.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: " ", with: "+")
        
        let urls: String = "https://www.googleapis.com/books/v1/volumes?q=" + criteria.replacingOccurrences(of: "ñ", with: "n")
        
        //978-84-376-0494-7"
        
        let url = NSURL(string: urls)
        let datos:NSData? = NSData(contentsOf: url! as URL)
        
        if (datos != nil) {
            let texto = NSString(data: datos! as Data, encoding: String.Encoding.utf8.rawValue)
            let dataString = String(data: datos! as Data, encoding: .utf8)
            print(dataString!)
            if (texto?.length)! <= 2 {
                spinner.hiddenSpinner()
                let message = "no results founds for: " + criteria
                let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                do{
                    guard let json = try JSONSerialization.jsonObject(with: datos! as Data, options: [])
                        as? NSDictionary else {
                            spinner.hiddenSpinner()
                            let alert = UIAlertController(title: "Alert", message: "Try again", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            return
                    }
                    search.criteria = criteria.replacingOccurrences(of: "+", with: " ")
                    let items = json["items"] as! NSArray
                    
                    for itemArray in items{
                        let item = itemArray as! NSDictionary
                        var book = BookControl.Book()
                        
                        let volumeInfo = item["volumeInfo"] as! NSDictionary
                        let title = volumeInfo["title"] as! String
                        let authorsArray = volumeInfo["authors"] as? NSArray
                        var authors = ""
                        
                        if authorsArray != nil{
                            for author in authorsArray!{
                                authors += author as! String
                            }
                        }
                        let publisher = volumeInfo["publisher"] as? String
                        let publishedDate = volumeInfo["publishedDate"] as? String
                        let description = volumeInfo["description"] as? String
                        
                        let industryIdentifiers = volumeInfo["industryIdentifiers"] as? NSArray
                        var isbn = ""
                        
                        if industryIdentifiers != nil{
                            for identifierArray in industryIdentifiers!{
                                let identifier = identifierArray as! NSDictionary
                                isbn = identifier["identifier"] as! String
                                break
                            }
                        }
                        
                        let pageCount = volumeInfo["pageCount"] as? NSNumber
                        
                        let covers = volumeInfo["imageLinks"] as? NSDictionary
                        
                        if(covers != nil){
                            
                            let coverUrl = covers?["thumbnail"] as! NSString as String
                            
                            var firstTodoUrlRequest = URLRequest(url: URL(string: coverUrl)!)
                            firstTodoUrlRequest.httpMethod = "GET"
                            
                            let session = URLSession.shared
                            
                            let task = session.dataTask(with: firstTodoUrlRequest) {
                                (data, response, error) in
                                guard let _ = data else {
                                    
                                    print("error " + (error?.localizedDescription)!)
                                    book.cover = #imageLiteral(resourceName: "imgNotAvailable")
                                    book.name = title
                                    book.authors = authors
                                    if publisher != nil {
                                        book.publisher = publisher!
                                    }
                                    
                                    if publishedDate != nil {
                                        book.publishedDate = publishedDate!
                                    }
                                    
                                    if description != nil {
                                        book.description = description!
                                    }
                                    
                                    if pageCount != nil {
                                        book.pages = pageCount!.description
                                    }
                                    book.isbn = isbn
                                    
                                    if book.isbn != "" && !db.verifyBook(isbn: book.isbn) {
                                        self.search.books.append(book)
                                        self.collectionView.reloadData()
                                    }
                                    spinner.hiddenSpinner()
                                    return
                                }
                                if let image = UIImage(data : data! as Data){
                                    book.cover = image
                                }else{
                                    book.cover = #imageLiteral(resourceName: "imgNotAvailable")
                                }
                                
                                book.name = title
                                book.authors = authors
                                if publisher != nil {
                                    book.publisher = publisher!
                                }
                               
                                if publishedDate != nil {
                                    book.publishedDate = publishedDate!
                                }
                                
                                if description != nil {
                                    book.description = description!
                                }
                                
                                if pageCount != nil {
                                    book.pages = pageCount!.description
                                }
                                book.isbn = isbn
                                
                                if book.isbn != "" && !db.verifyBook(isbn: book.isbn) {
                                    self.search.books.append(book)
                                    self.collectionView.reloadData()
                                }
                                spinner.hiddenSpinner()
                            }
                            task.resume()
                        }
                        else{
                            book.cover = #imageLiteral(resourceName: "imgNotAvailable")
                            book.name = title
                            book.authors = authors
                            if publisher != nil {
                                book.publisher = publisher!
                            }
                            if publishedDate != nil {
                                book.publishedDate = publishedDate!
                            }
                            
                            if description != nil {
                                book.description = description!
                            }
                            
                            if pageCount != nil {
                                book.pages = pageCount!.description
                            }
                            book.isbn = isbn
                            
                            if book.isbn != "" && !db.verifyBook(isbn: book.isbn) {
                                search.books.append(book)
                                collectionView.reloadData()
                            }
                            spinner.hiddenSpinner()
                        }
                    }
                    //spinner.hiddenSpinner()
                    divContainer.isHidden = false
                }
                catch {
                    spinner.hiddenSpinner()
                }
            }
        } else {
            spinner.hiddenSpinner()
            let alert = UIAlertController(title: "Alert", message: "No connection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        divContainer.isHidden = true
        search = SearchControl.Search()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        //Suppose that I selected the day of monday and the day thursday
        //get the datasource from the previousVC UIViewController and set the correct selected days
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addBook" {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                let object = self.search.books[indexPath.row]
                let controller = segue.destination as! AddBookController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            } 
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.search.books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Result
        
        // Configure the cell
        cell.imgCover.image = search.books[indexPath.item].cover
        cell.lblBookTitle.text = search.books[indexPath.item].name
        
        return cell
    }
}
