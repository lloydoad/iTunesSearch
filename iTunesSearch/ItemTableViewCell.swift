//
//  ItemTableViewCell.swift
//  iTunesSearch
//
//  Created by Lloyd Dapaah on 6/16/18.
//  Copyright © 2018 Caleb Hicks. All rights reserved.
//

import UIKit
import AVFoundation

class ItemTableViewCell: UITableViewCell {
    
    var item: Item?
    var player: AVPlayer!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var artworkImageView: UIImageView!
    
    // music preview progress bar
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var progressBarView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        priceButton.layer.borderWidth = 1
        priceButton.layer.cornerRadius = 2.2
        priceButton.layer.borderColor = UIColor(red: 45/255, green: 123/255, blue: 246/255, alpha: 1).cgColor
        // Initialization code
    }
    
    @IBAction func previewButtonPressed(_ sender: Any) {
        // fetch data
        // if valid, animate and play song
        playSongWithAnimation()
    }
    
    func parseSong() {
        if let songFront = item,
            let previewUrl = songFront.preview {
            
            player = AVPlayer(url: previewUrl)
            player.play()
        } else {
            print("Preview Url: nil")
        }
    }
    
    func playSongWithAnimation() {
        previewButton.isHidden = true
        progressBarView.isHidden = false
        progressBarView.alpha = 0
        progressBarView.frame = CGRect(x: 0, y: 2, width: 1, height: 8)
        
        UIView.animate(withDuration: 1.5, animations: {
            self.progressBarView.alpha = 1.0
        }) { (_) in
            
            self.parseSong()
            UIView.animate(withDuration: 31.5, animations: {
                self.progressBarView.frame = CGRect(x: 0, y: 2, width: 240, height: 8)
            }, completion: { (_) in
                
                UIView.animate(withDuration: 1.5, animations: {
                    self.progressBarView.alpha = 0
                    
                    self.previewButton.isHidden = false
                    self.progressBarView.isHidden = true
                })
            })
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
