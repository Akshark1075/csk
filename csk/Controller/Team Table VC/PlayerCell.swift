//
//  PlayerCell.swift
//  csk
//
//  Created by Arvind K on 18/02/24.
//

import UIKit

class PlayerCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var playerImage: UIImageView!

    @IBOutlet weak var playerName: UILabel!
    
    @IBOutlet weak var playerRole: UILabel!
    
    @IBOutlet weak var viewProfile: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
