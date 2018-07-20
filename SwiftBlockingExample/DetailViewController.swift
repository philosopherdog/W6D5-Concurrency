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
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    activityIndicator.startAnimating()
    
    fetchImageOnMainQueue {[unowned self] (data: Data) in
      guard let image = UIImage(data: data) else {
        print(#line, "error getting image from data")
        return
      }
      self.imageView.image = image
      self.activityIndicator.stopAnimating()
      Timer.stop()
    }
    
    // Fix by calling fetchImageOnBackGroundQueue
//    fetchImageOnBackGroundQueue {[unowned self] (data) in
//      DispatchQueue.main.async {
//        let image = UIImage(data: data)
//        self.imageView.image = image
//        Timer.stop()
//      }
//    }
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
    let q = DispatchQueue(label: "com.steve.thompson", qos: .userInitiated)
    q.async {[unowned self] in
      do {
        let data = try Data(contentsOf: self.url)
        completionHandler(data)
      }
      catch {
        print(#line, error.localizedDescription)
      }
    }
  }
}
