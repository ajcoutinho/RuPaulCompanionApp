//
//  ShowCell.swift
//  RuPaulAppSecondTake
//
//  Created by Alex Coutinho on 2022-09-30.
//

import UIKit

class QueenCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var queenImage: UIImageView!
    @IBOutlet weak var queenLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
