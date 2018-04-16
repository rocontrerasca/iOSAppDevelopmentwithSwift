//
//  AddBookController.swift
//  ConsultaLibros
//
//  Created by Developer 1 on 4/3/18.
//  Copyright © 2018 comDeveloper. All rights reserved.
//

import UIKit

class AddBookController: UIViewController {

    var previousVC : MasterViewController = MasterViewController()

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthors: UILabel!
    @IBOutlet weak var imgCover: UIImageView!
    
    @IBOutlet weak var divContainer: UIStackView!
    
    var book : BookControl.Book = BookControl.Book()
    
    @IBAction func searchBook(_ sender: UITextField) {
        book = BookControl.Book()
        divContainer.isHidden = true
        sender.resignFirstResponder()
        let ISBN = sender.text!.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: ".", with: "")
        
        let urls: String = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + ISBN
        
        //978-84-376-0494-7"
        
        if !db.verifyBook(isbn: ISBN){
        
        let url = NSURL(string: urls)
        let datos:NSData? = NSData(contentsOf: url! as URL)
        
        if (datos != nil) {
            let texto = NSString(data: datos! as Data, encoding: String.Encoding.utf8.rawValue)
            if (texto?.length)! <= 2 {
                let message = "No se ha encontrado ningun resultado para el ISBN: " + ISBN
                let alert = UIAlertController(title: "Mensaje", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                do{
                    guard let json = try JSONSerialization.jsonObject(with: datos! as Data, options: [])
                        as? NSDictionary else {
                            print("error trying to convert data to JSON")
                            return
                    }
                    
                    let info = json["ISBN:" + ISBN] as! NSDictionary
                    let authorsArray = (info["authors"]! as! NSArray).mutableCopy() as! NSMutableArray
                    
                    let authors = authorsArray[0] as! NSDictionary
                    
                    let authorsName = authors ["name"] as? String
                    
                    let title = info["title"] as? String
                    
                    let covers = info["cover"] as? NSDictionary
                    
                    if(covers != nil){
                        let coverUrl = covers?["medium"] as! NSString as String
                        
                        let urlCover = NSURL(string: coverUrl)
                        let imgData : NSData? = NSData(contentsOf: urlCover! as URL)
                        if(imgData != nil){
                            if let image = UIImage(data : imgData! as Data){
                                imgCover.image = image
                            }
                        }
                    }
                    else{
                        imgCover.image = #imageLiteral(resourceName: "imgNotAvailable")
                    }
                    lblAuthors.text = authorsName
                    
                    lblTitle.text = title
                    
                    book.name = title!
                    book.authors = authorsName!
                    book.isbn = ISBN
                    book.cover = imgCover.image
                    
                    divContainer.isHidden = false
                    
                    if book.name != ""  {
                            db.addBook(name: book.name, isbn: book.isbn, cover: book.cover!, authors: book.authors)
                            db.save()
                            previousVC.historyBooks.append(book)
                        sender.text = nil                        
                    }
                }
                catch {
                    
                }
            }
        } else {
            let alert = UIAlertController(title: "Mensaje", message: "No hay conexión a internet", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        }
        else{
            book = db.getBook(isbn: ISBN)
            lblAuthors.text = book.authors
            lblTitle.text = book.name
            imgCover.image = book.cover
            divContainer.isHidden = false
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        divContainer.isHidden = true
        book = BookControl.Book()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let masterController = segue.destination as! MasterViewController
        
        masterController.historyBooks.append(Book(name: "Prueba", isbn: "621211211212"))
    }*/
}
