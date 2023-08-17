//
//  ViewController.swift
//  Task-ApiIntergration-Post
//
//  Created by Ananth Nair on 16/08/23.
//

import UIKit

class ViewController: UIViewController {
    
    var jsonData : Root?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRespone()
        // Do any additional setup after loading the view.
    }
    
    // MARK: -  Response Function
    
    func getRespone(){
        
        let url = "https://kuwycredit.in/servlet/rest/ltv/forecast/ltvModels"
      
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var param : [String:Any] = ["year":"2020","make":"RENAULT"]
        
        do{
            request.httpBody =  try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions())
            let task = URLSession.shared.dataTask(with: request as URLRequest ,completionHandler: {(data, response, error) in
                
                // response
                if let response = response {
                    let nsHTTPResponse = response as! HTTPURLResponse
                    let statusCode = nsHTTPResponse.statusCode
                    print("statusCode ----->>>> \(statusCode)")
                    
                }
                // error
                if let error = error {
                    print(error)
                }
                // data
                if let data = data {
                    do {
                        let content = try? JSONDecoder().decode(Root.self, from: data)
                        self.jsonData = content
                        print(content as Any)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                }
            })
            task.resume()
            
            
        } catch {
            print("somting is went wrong ")
            
            
            
        }
    }
    

}
extension ViewController : UITableViewDelegate {
    
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonData?.modelList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vc = tableView.dequeueReusableCell(withIdentifier: "cell")
        vc?.textLabel?.text = jsonData?.modelList[indexPath.row]
        return vc!
    }
    
    
}

