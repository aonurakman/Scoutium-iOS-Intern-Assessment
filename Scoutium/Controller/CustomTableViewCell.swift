//
//  CustomTableViewCell.swift
//  Scoutium
//
//  Created by Ahmet Onur Akman on 13.12.2020.
//

import UIKit
import SDWebImage

// Our very own basic custom table view cell, containing a label and imageView
class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    static let identifier = "CustomTableViewCell"
    static let baseURL = "https://storage.googleapis.com/anvato-sample-dataset-nl-au-s1/life-1/"
    // The prefix for the image URLs
    
    static func nib() -> UINib {
        return UINib(nibName: CustomTableViewCell.identifier, bundle: nil)
    }
    
    // A function to be called for configuring the cell params
    func configure(imageURL: String, cellText: String){
        self.cellLabel.text = cellText
        cellImage.sd_setImage(with: URL(string: CustomTableViewCell.baseURL+imageURL), placeholderImage: UIImage(named: "bgRemoved.png"))
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
