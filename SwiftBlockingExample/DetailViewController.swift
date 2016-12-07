//
//  DetailViewController.swift
//  SwiftBlockingExample
//
//  Created by steve on 2016-12-05.
//  Copyright © 2016 steve. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  
  private let url:URL! = URL(string: "https://dl.dropboxusercontent.com/u/580418/1.jpg")
  private var activityIndicator: UIActivityIndicatorView!
  
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
    fetchImageOnMainQueue()
//    fetchImageOnBackGroundQueue()
  }
  
  private func fetchImageOnMainQueue() {
    Timer.start()
    guard let data = NSData(contentsOf: url) as? Data else {
      print(#line, "where's my damn data?")
      return
    }
    let image = UIImage(data: data)
    self.imageView.image = image
    Timer.stop()
    activityIndicator.stopAnimating()
  }
  /*
  private func fetchImageOnBackGroundQueue() {
    Timer.start()
    let backgroundQ = DispatchQueue(label: "com.cocoanutmobile.SwiftBlocking", qos: .userInitiated)
    backgroundQ.async {
      [unowned self] in
      guard let data = NSData(contentsOf: self.url) as? Data else {
        print(#line, "where's my damn data?")
        return
      }
      let image = UIImage(data: data)
      DispatchQueue.main.async {
        self.imageView.image = image!
        Timer.stop()
        self.activityIndicator.stopAnimating()
      }
    }
  }
 */
}
