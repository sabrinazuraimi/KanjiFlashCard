import Foundation

class AzureMicrosoftTranslator: NSObject {
  
  static let sharedTranslator = AzureMicrosoftTranslator()
  
  // Please remember to initialize
  let key = "12446ed2d0dc485aa0285dd51cf8d70b"

  func translate(text: String, toLang lang: String, completion block: @escaping (String?, URLResponse?, Error?) -> Void) {
    
//    guard let key = key else {
//      block(nil, nil, AzureMicrosoftTranslatorError.APIKeyIsNotInitialized as NSError)
//      return
//    }
    print("getToken")
    getToken(key: key) { (data, response, error) in
      if let error = error {
        print("1111")
        block(nil, response, error)
        return
      }
      
      guard let data = data, let token = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) as? String else {
        print("aa")
        block(nil, response, AzureMicrosoftTranslatorError.TokenParseError as NSError)
        return
      }
      
      self.msTranslate(token: token, translate: text, toLang: lang) { (data, response, error) in
        print("msTranslate")
        if let error = error {
          print("error")
          block(nil, response, error)
          return
        }
        
        guard let data = data,
          let xml = NSString(data: data, encoding: String.Encoding.utf8.rawValue),
          let result = self.extract(text: xml) else {
            print("called")
            block(nil, response, AzureMicrosoftTranslatorError.TextParseError as NSError)
            return
        }
        print(xml)
        block(result, response, nil)
      }
    }
  }
  
  private func getToken(key: String, completion block: @escaping (Data?, URLResponse?, Error?) -> Void) {
    
    let request = NSMutableURLRequest(url: URL(string: "https://api.cognitive.microsoft.com/sts/v1.0/issueToken")!)
    request.httpMethod = "POST"
    request.addValue(key, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
    
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest, completionHandler: block)
    
    task.resume()
  }
  
  private func msTranslate(token: String, translate text: String, toLang lang: String, completion block: @escaping (Data?, URLResponse?, Error?) -> Void) {
    
    let c = NSURLComponents(string: "http://api.microsofttranslator.com/v2/Http.svc/Translate")
    
    c?.queryItems = [
      URLQueryItem(name: "text", value: text) as URLQueryItem,
      URLQueryItem(name: "to", value: lang)
    ]
    
    guard let url = c?.url else {
      return
    }
    
    let request = NSMutableURLRequest(url: url)
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest, completionHandler: block)
    
    task.resume()
  }
  
  private func extract(text: NSString) -> String? {
    
    guard let regex = try? NSRegularExpression(pattern: "^<string[^>]*>(.*?)</string>$", options: .dotMatchesLineSeparators) else {
      return nil
    }
    
    return regex.stringByReplacingMatches(in: text as String, options: [], range: NSRange(location: 0, length: text.length), withTemplate: "$1")
  }
}
