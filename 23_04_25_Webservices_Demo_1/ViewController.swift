//
//  ViewController.swift
//  23_04_25_Webservices_Demo_1
//
//  Created by Vishal Jagtap on 26/06/25.
//

import UIKit

class ViewController: UIViewController {

    var url : URL?
    var urlRequest : URLRequest?
    var urlSession : URLSession?
    var posts : [Post] = []
    var resueIdentifierForCell = "PostTableViewCell"
    
    @IBOutlet var postTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerPostTableViewWithXIBAndInitialize()
        jsonSerialization()
    }
    
    func registerPostTableViewWithXIBAndInitialize(){
        postTableView.delegate = self
        postTableView.dataSource = self
        let uiNib = UINib(nibName: resueIdentifierForCell, bundle: nil)
        self.postTableView.register(uiNib, forCellReuseIdentifier: resueIdentifierForCell)
    }
    
    func jsonSerialization(){
        url = URL(string: "https://jsonplaceholder.typicode.com/posts")
        urlRequest = URLRequest(url: url!)
        urlSession = URLSession(configuration: .default)
        
        let dataTask = urlSession?.dataTask(with: urlRequest!) { data, urlResponse, error in
            
            print(data!)
            print(urlResponse!)
            print(error)
            
            if((urlResponse as! HTTPURLResponse).statusCode == 200){
                let jsonPostResponse = try! JSONSerialization.jsonObject(with: data!) as! [[String : Any]]
                
                print(jsonPostResponse)
                
                for eachPost in jsonPostResponse{
                    let postObject = eachPost as [String : Any]
                    
                    let eachPostUserId = postObject["userId"] as! Int
                    let eachPostId = postObject["id"] as! Int
                    let eachPostTitle = postObject["title"] as! String
                    let eachPostBody = postObject["body"] as! String
                    
                    let newPost = Post(userId: eachPostUserId,
                                       id: eachPostId,
                                       title: eachPostTitle,
                                       body: eachPostBody)
                    
                    self.posts.append(newPost)
                }
                print(self.posts)
            }
            
            DispatchQueue.main.async{
                self.postTableView.reloadData()
            }
        }
        dataTask?.resume()
    }
}

//MARK : UITableViewDelegate Used
extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

//MARK : UITableViewDataSource Used
extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postTableViewCell = self.postTableView.dequeueReusableCell(withIdentifier: resueIdentifierForCell, for: indexPath) as! PostTableViewCell
        
        postTableViewCell.userIdLabel.text = "\(self.posts[indexPath.row].id)"
        return postTableViewCell
    }
}
