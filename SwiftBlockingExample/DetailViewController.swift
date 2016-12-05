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
  
  let url:URL! = URL(string: "https://dl.dropboxusercontent.com/u/580418/1.jpg")
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchImage()
  }
  
  private func fetchImage() {
    guard let data = NSData(contentsOf: url) as? Data else {
      print(#line, "where's my damn data?")
      return
    }
    let image = UIImage(data: data)
    self.imageView.image = image
  }
}
