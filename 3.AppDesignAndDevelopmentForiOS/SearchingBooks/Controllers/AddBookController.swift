//
//  AddBookController.swift
//  SearchingBooks
//
//  Created by Developer 1 on 4/22/18.
//  Copyright © 2018 comDeveloper. All rights reserved.
//

import UIKit

class AddBookController: UIViewController {
    var previousVC : MasterViewController = MasterViewController()
    
    
    @IBOutlet weak var viewContentHeight: NSLayoutConstraint!
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
        if btnAdd.titleLabel?.text == "Add to my list" {
            btnAdd.setTitle("Remove from my list", for: .normal)
            db.addBook(bookItem: detailItem!)
            db.save()
        }
        else{
             btnAdd.setTitle("Add to my list", for: .normal)
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
           btnAdd.setTitle("Remove from my list", for: .normal)
        }
        
        lblBookTitle.text = detailItem?.name
        lblIsbn.text = detailItem?.isbn
        lblAuthors.text = detailItem?.authors
        lblPublisher.text = detailItem?.publisher
        lblPublishedDate.text = detailItem?.publishedDate
        lblPages.text = detailItem?.pages
        bookCover.image = detailItem?.cover
        lblDescription.text = detailItem?.description

        let greet4Height = lblDescription.optimalHeight
        lblDescription.frame = CGRect(x: lblDescription.frame.origin.x, y: lblDescription.frame.origin.y, width: lblDescription.frame.width, height: greet4Height)
        lblDescription.backgroundColor = UIColor.yellow
        
        viewContentHeight.constant += greet4Height
        self.view.layoutIfNeeded()
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
