//
//  RecognitionViewController.swift
//  KanjiFlashCard
//
//  Created by Musashi Sakamoto on 2017/03/04.
//  Copyright © 2017年 Nur Sabrina binti Zuraimi. All rights reserved.
//

import UIKit

class RecognitionViewController: UIViewController {
  
  let translator = AzureMicrosoftTranslator.sharedTranslator

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      setupTranslator()
      translator.translate(text: "男", toLang: "en") { (text, response, error) in
        guard error == nil else {
          return
        }
        
        print(text!)
      }
    }
  
  func setupTranslator() {
    translator.key = "12446ed2d0dc485aa0285dd51cf8d70b"
    
  }
}
