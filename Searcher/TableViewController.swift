//
//  TableViewController.swift
//  Searcher
//
//  Created by user148651 on 1/13/19.
//  Copyright © 2019 user148651. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftyGif

class TableViewController: UITableViewController, UISearchBarDelegate {
    
    let GIF_URL = "https://api.tenor.com/v1/search?"
    let API_KEY = "AWMHIP5GIBF3"
    var nextOne = 0
    var gifs = [String]()
    var params: [String: String] = ["q": "", "key": "AWMHIP5GIBF3", "limit": "20", "pos": "0"]
    var stringToSearch = ""
    var imageCache = NSCache<NSNumber, UIImage>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.estimatedRowHeight = 300.0
            self.tableView.layer.masksToBounds = true
            
        }
        
        
        setUpSearchBar()
        
        params["pos"] = String(self.nextOne)
        
        getGifData()
    }

    //MARK: - Searchbar setup
    
    func setUpSearchBar() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width/1.5, height: 100.0))
        
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Search..."
        searchBar.delegate = self
        searchBar.isHidden = true
        
        DispatchQueue.main.async {
            let leftNavBarButton = UIBarButtonItem(customView:searchBar)
            self.navigationItem.leftBarButtonItem = leftNavBarButton
        }

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        getGifData()
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        let searchBar = self.navigationItem.leftBarButtonItem!.customView
        if searchBar?.isHidden == true {
            searchBar?.isHidden = false
            searchBar?.endEditing(false)
            searchBar?.becomeFirstResponder()
        }
        else {
            searchBar?.isHidden = true
            searchBar?.endEditing(true)
        }
        
    }
    
    //MARK: - Search bar delegate methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.stringToSearch = searchText
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reload), object: nil)
        self.perform(#selector(reload), with: nil, afterDelay: 0.2)
    }
    
    @objc func reload() {
        self.gifs.removeAll()
        self.tableView.reloadData()
        self.nextOne = 0
        self.imageCache = NSCache<NSNumber, UIImage>()
        params["pos"] = String(self.nextOne)
        params["q"] = self.stringToSearch
        
        getGifData()
    }
    
    //MARK: - Networking
    
    func getGifData() {
        let queue = DispatchQueue(label: "com.tenor.api", qos: .background, attributes: .concurrent)
        Alamofire.request(GIF_URL, method: .get, parameters: params).responseJSON(queue: queue) {
            response in
            if response.result.isSuccess {
                print("Succes! Got the data.")
            
                let gifJSON : JSON = JSON(response.result.value!)
                self.processJSON(json: gifJSON)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
                self.nextOne = self.nextOne + 20
                self.params["pos"] = String(self.nextOne)

            }
            else {
               print("Error! Could not get data.")
            }
        }
    }
    
    //MARK: - JSON Parsing
    
    func processJSON(json: JSON) {
        let result = json["results"]
        
        for tuple in result {
            let jsonObject = tuple.1
            let jsonMedia = jsonObject["media"][0]
            let jsonUrl = jsonMedia["gif"]["url"].string
            gifs.append(jsonUrl!)
            
        }
}
    
    // MARK: - Table view data source methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gifs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myTableViewCell", for: indexPath) as! TableViewCell
        
        cell.gifImage.delegate = self
        cell.gifImage.attachedIndexPath = indexPath.row
        var loadFromUrl: Bool = true
        let image = imageCache.object(forKey: cell.gifImage.attachedIndexPath as NSNumber)
        if image != nil {
            loadFromUrl = false
        }
        
        cell.configure(gifUrl: self.gifs[indexPath.row], loadFromUrl: loadFromUrl, image: image)
        return cell
        
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK: - Scroll View delegate methods

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
           
            getGifData()
        }
    }

}

//MARK: - SwiftyGif delegate methods

extension TableViewController: SwiftyGifDelegate {
    func gifURLDidFinish(sender: UIImageView) {
        if imageCache.object(forKey: sender.attachedIndexPath as NSNumber) == nil {
            imageCache.setObject(sender.gifImage!, forKey: sender.attachedIndexPath as NSNumber)
            print("\(sender.attachedIndexPath) - \(sender)")
        }
    }
}
