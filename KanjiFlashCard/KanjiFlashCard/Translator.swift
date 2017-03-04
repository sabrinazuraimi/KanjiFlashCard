//
//  Translator.swift
//  KanjiFlashCard
//
//  Created by Musashi Sakamoto on 2017/03/04.
//  Copyright © 2017年 Nur Sabrina binti Zuraimi. All rights reserved.
//

import Foundation

class Translator {
    
  static func translate(text: String, toLang: String,  completion block: @escaping (String?, URLResponse?, Error?) -> Void) {
    AzureMicrosoftTranslator.sharedTranslator.translate(text: <#T##String#>, toLang: <#T##String#>, completion: <#T##(String?, URLResponse?, Error?) -> Void#>)
  }
}
