//
//  AddBookController.swift
//  SearchingBooks
//
//  Created by Developer 1 on 4/22/18.
//  Copyright © 2018 comDeveloper. All rights reserved.
//

import UIKit

class AddBookController: UIViewController {
    
    @IBOutlet weak var lblBookTitle: UILabel!
    @IBOutlet weak var lblIsbn: UILabel!
    @IBOutlet weak var lblAuthors: UILabel!
    @IBOutlet weak var lblPublisher: UILabel!
    @IBOutlet weak var lblPublishedDate: UILabel!
    @IBOutlet weak var lblPages: UILabel!
    @IBOutlet weak var bookCover: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }

    @IBAction func addBook(_ sender: UIButton) {
        if sender.titleLabel?.text == "Add to my list" {
            sender.titleLabel?.text = "Remove from my list"
            db.addBook(bookItem: detailItem!)
            db.save()
        }
        else{
            sender.titleLabel?.text = "Add to my list"
            var _ = db.deleteBook(isbn: (detailItem?.isbn)!)
            db.save()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        
        if db.verifyBook(isbn: (detailItem?.isbn)!){
            btnAdd.titleLabel?.text = "Remove from my list"
        }
        
        lblBookTitle.text = detailItem?.name
        lblIsbn.text = detailItem?.isbn
        lblAuthors.text = detailItem?.authors
        lblPublisher.text = detailItem?.publisher
        lblPublishedDate.text = detailItem?.publishedDate
        lblPages.text = detailItem?.pages
        bookCover.image = detailItem?.cover
        lblDescription.text = detailItem?.description
    }

    var detailItem: BookControl.Book? {
        didSet {
            // Update the view.
            //configureView()
        }
    }    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
