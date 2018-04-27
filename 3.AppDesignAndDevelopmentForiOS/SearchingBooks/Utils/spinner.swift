//
//  spinner.swift
//  SearchingBooks
//
//  Created by Developer 1 on 4/25/18.
//  Copyright © 2018 comDeveloper. All rights reserved.
//

import UIKit

class Spinner: UIViewController {
    var boxView = UIView()
    
    func showSpinner(message: String, controller: AnyObject) {
        // You only need to adjust this frame to move it anywhere you want
        boxView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 180, height: 50))
        boxView.backgroundColor = UIColor.lightGray
        boxView.alpha = 0.8
        boxView.layer.cornerRadius = 10
        
        //Here the spinnier is initialized
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.startAnimating()
        
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 100, height: 50))
        textLabel.textColor = UIColor.darkGray
        textLabel.text = message
        
        boxView.addSubview(activityView)
        boxView.addSubview(textLabel)
        
        controller.view.addSubview(boxView)
    }
    
    func hiddenSpinner() {
        //When button is pressed it removes the boxView from screen
        boxView.removeFromSuperview()
    }
}
