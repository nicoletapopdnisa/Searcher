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
import FLAnimatedImage

class TableViewController: UITableViewController, UISearchBarDelegate {
    
    let GIF_URL = "https://api.tenor.com/v1/search?"
    let API_KEY = "AWMHIP5GIBF3"
    var nextOne = 0
    var gifs = [String]()
    var params: [String: String] = ["q": "", "key": "AWMHIP5GIBF3", "limit": "5", "pos": "0"]
    var stringToSearch = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.estimatedRowHeight = 600.0
        self.tableView.rowHeight = UITableView.automaticDimension
        
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width/1.5, height: 100.0))
        
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Search..."
        searchBar.delegate = self
        searchBar.isHidden = true
        
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        params["pos"] = String(self.nextOne)
        
        getGifData()
    }
    
    //MARK: - Networking
    
    func getGifData() {
        
        
        Alamofire.request(GIF_URL, method: .get, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                print("Succes! Got the data.")
                print(self.params)
                let gifJSON : JSON = JSON(response.result.value!)
                
                
                self.processJSON(json: gifJSON)
                print(self.gifs)
                self.tableView.reloadData()
                
                self.nextOne = self.nextOne + 5
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

    @IBAction func searchButtonPressed(_ sender: Any) {
        let searchBar = self.navigationItem.leftBarButtonItem!.customView
        if searchBar?.isHidden == true {
            searchBar?.isHidden = false
            searchBar?.endEditing(false)
        }
        else {
            searchBar?.isHidden = true
            searchBar?.endEditing(true)
        }
        
    }
    
    // MARK: - Table view data source
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        self.nextOne = 0
        params["q"] = searchText
        params["pos"] = String(self.nextOne)
        self.gifs = []
        self.tableView.reloadData()
        getGifData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.endEditing(true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gifs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myTableViewCell", for: indexPath) as! TableViewCell
    
        
        let url = URL(string: gifs[indexPath.row])!
        let imageData = try? Data(contentsOf: url)
        
        let animatedImage = FLAnimatedImage(animatedGIFData: imageData)
        cell.animatedImageView.animatedImage = animatedImage
        
        
        return cell
    }
    
    //MARK: - Scroll View delegate methods
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            getGifData()
        }
    }
    

}
