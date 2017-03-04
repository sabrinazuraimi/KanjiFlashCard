//
//  RecognitionViewController.swift
//  KanjiFlashCard
//
//  Created by Musashi Sakamoto on 2017/03/04.
//  Copyright © 2017年 Nur Sabrina binti Zuraimi. All rights reserved.
//

import UIKit
import Firebase

class RecognitionViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var words:[FIRDataSnapshot] = []
  fileprivate var _refHandle: FIRDatabaseHandle?
  let ref = FIRDatabase.database().reference()
  
  let translator = AzureMicrosoftTranslator.sharedTranslator

    override func viewDidLoad() {
        super.viewDidLoad()
      tableView.dataSource = self
      configureDatabase()
        // Do any additional setup after loading the view.
      translate(text: "鉛筆", toLang: "en")
  }
  
  deinit {
    if let refHandle = _refHandle {
      self.ref.child("words").removeObserver(withHandle: refHandle)
    }
  }
  
  func translate(text: String, toLang: String) {
    translator.translate(text: text, toLang: toLang) { (translated, response, error) in
      guard error == nil else {
        return
      }
      
      print(translated!)
      self.addToWord(from: text, to: translated!)
    }
  }
  
  func addToWord(from: String, to: String) {
    var data: [String: String] = [:]
    data["kanji"] = from
    data["trans"] = to
    self.ref.child("words").childByAutoId().setValue(data)
  }
  
  func configureDatabase() {
    ref.child("words").observe(.childAdded, with: { [weak self](snapshot) in
      guard let strongSelf = self else { return }
      strongSelf.words.append(snapshot)
      strongSelf.tableView.insertRows(at: [IndexPath(row: strongSelf.words.count - 1, section: 0)], with: .automatic)
    })
  }
}

extension RecognitionViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return words.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RecognitionTableViewCell
    
    let wordSnapshot: FIRDataSnapshot! = self.words[indexPath.row]
    guard let word = wordSnapshot.value as? [String: String] else { return cell! }
    cell?.kanjiLabel.text = word["kanji"] ?? ""
    cell?.translationLabel.text = word["trans"] ?? ""
    
    return cell!
  }
}
