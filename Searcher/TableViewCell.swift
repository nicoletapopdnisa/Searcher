//
//  TableViewCell.swift
//  Searcher
//
//  Created by user148651 on 1/13/19.
//  Copyright © 2019 user148651. All rights reserved.
//

import UIKit
import SwiftyGif

class TableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var gifImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(gifUrl: String, loadFromUrl: Bool, image: UIImage?){
        self.gifImage.setGifImage(UIImage())
        if loadFromUrl {
            let url = URL(string: gifUrl)
            
            DispatchQueue.main.async {
                self.gifImage.setGifFromURL(url, manager: SwiftyGifManager.defaultManager, loopCount: -1, showLoader: false)
            }
        }
        else {
            DispatchQueue.main.async {
                self.gifImage.setGifImage(image!, manager: SwiftyGifManager.defaultManager, loopCount: -1)
            }
            
        }
        
        
    }

}
