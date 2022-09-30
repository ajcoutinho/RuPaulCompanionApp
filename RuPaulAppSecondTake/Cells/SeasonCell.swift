//
//  SeasonCell.swift
//  RuPaulAppSecondTake
//
//  Created by Alex Coutinho on 2022-09-30.
//

import UIKit

class SeasonCell: UITableViewCell {
    
    @IBOutlet weak var seasonTitle: UILabel!
    @IBOutlet weak var seasonImage: UIImageView!
    var id = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
