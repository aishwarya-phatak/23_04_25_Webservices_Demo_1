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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jsonSerialization()
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
        }
        dataTask?.resume()
    }
}
