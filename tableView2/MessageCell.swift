//
//  MessageCell.swift
//  tableView2
//
//  Created by Anna Cvasniuc on 16/12/2020.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!
  
    //Nib is the oldest name from xib
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //this is my messageBubble un po' rotondino il height e necessario se abbiamo un messaggiopiu grande allora il mio rotondo diventa piu grande
  //      stackView.layer.cornerRadius = stackView.frame.size.height / 5
       // rightImageView.layer.cornerRadius = rightImageView.frame.size.width / 2.0
      //  rightImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
