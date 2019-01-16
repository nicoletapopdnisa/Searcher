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
    
    func configure(gifUrl: String) {
        let url = URL(string: gifUrl)
        
        DispatchQueue.main.async {
            self.gifImage.image = nil
            self.gifImage.setGifFromURL(url, manager: SwiftyGifManager.defaultManager, loopCount: -1, showLoader: false)
        }
        
        
    }

}
