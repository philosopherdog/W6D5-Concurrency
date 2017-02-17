//
//  DetailViewController.swift
//  SwiftBlockingExample
//
//  Created by steve on 2016-12-05.
//  Copyright © 2016 steve. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  @IBOutlet fileprivate weak var imageView: UIImageView!
  fileprivate let url:URL! = URL(string: "https://dl.dropboxusercontent.com/u/580418/1.jpg")
  fileprivate var activityIndicator: UIActivityIndicatorView!
  
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
    
    //    fetchImageOnMainQueue { (data:Data) in
    //      guard let image = UIImage(data: data) else {
    //        print(#line, "couldn't make an image from it")
    //        return
    //      }
    //      self.imageView.image = image
    //      activityIndicator.stopAnimating()
    //      Timer.stop()
    //    }
    
    fetchImageOnBackGroundQueue { data in
      // we're in a background Q here
      guard let image = UIImage(data: data) else {
        print(#line, "Where's my image?")
        return
      }
      DispatchQueue.main.async {
        self.imageView.image = image
        Timer.stop()
        self.activityIndicator.stopAnimating()
      }
    }
  }
}

// Network code on MainQ (Never do this)
extension DetailViewController {
  fileprivate func fetchImageOnMainQueue(completionHandler:@escaping (Data)->()) {
    Timer.start()
    var data: Data!
    do {
      data = try Data(contentsOf: url)
    }
    catch {
      print(#line, "Where is my data?!")
      return
    }
    completionHandler(data)
  }
}

// backgroundQ Way
extension DetailViewController {
  fileprivate func fetchImageOnBackGroundQueue(completionHandler:@escaping (Data)->()) {
    Timer.start()
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
