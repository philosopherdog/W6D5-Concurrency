//
//  DetailViewController.swift
//  SwiftBlockingExample
//
//  Created by steve on 2016-12-05.
//  Copyright © 2016 steve. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    private let url: URL! = URL(string: "https://www.dropbox.com/s/d8fht3uhbim6fgv/1.jpg?raw=1")
    
    private var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Lifecyle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = self.view.viewWithTag(200) as! UIActivityIndicatorView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.startAnimating()
        
        fetchImageOnMainQueue {[unowned self] (data: Data) in
            guard let image = UIImage(data: data) else {
                print(#line, "couldn't make an image from it")
                return
            }
            self.imageView.image = image
            self.activityIndicator.stopAnimating()
            Timer.stop()
        }
        
        // Fix by calling fetchImageOnBackGroundQueue
    }
}

// Network code on MainQ (Never do this)

extension DetailViewController {
    private func fetchImageOnMainQueue(completionHandler:@escaping (Data)->()) {
        Timer.start()
        do {
            let data = try Data(contentsOf: url)
            completionHandler(data)
        }
        catch {
            print(#line, "Where is my data?!")
            return
        }
    }
}

// backgroundQ Way
extension DetailViewController {
    private func fetchImageOnBackGroundQueue(completionHandler:@escaping (Data)->()) {
        Timer.start()
        // What type of Q is this?
        let backgroundQ = DispatchQueue(label: "com.cocoanutmobile.SwiftBlocking", qos: .userInitiated)
        backgroundQ.async {
            [unowned self] in
            var data: Data!
            do {
                data = try Data(contentsOf: self.url)
            }
            catch {
                print(#line, "error: \(error.localizedDescription) getting data from url")
                return
            }
            completionHandler(data)
        }
    }
}
