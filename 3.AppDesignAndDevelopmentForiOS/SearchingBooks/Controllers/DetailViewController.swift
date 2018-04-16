//
//  DetailViewController.swift
//  ConsultaLibros
//
//  Created by Developer 1 on 4/3/18.
//  Copyright © 2018 comDeveloper. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthors: UILabel!
    @IBOutlet weak var imgCover: UIImageView!
    

    func configureView() {
        lblTitle.text = detailItem?.name
        lblAuthors.text = detailItem?.authors
        imgCover.image = detailItem?.cover
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: BookControl.Book? {
        didSet {
            // Update the view.
            //configureView()
        }
    }
}

