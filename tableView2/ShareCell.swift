//
//  ShareCell.swift
//  passepartooth
//
//  Created by Anna Cvasniuc on 09/02/21.
//

import UIKit

class ShareCell: UITableViewCell {

    static let id = "ShareCell"
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var cognome: UILabel!
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var nomeCard: UILabel!
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var shareCell: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //definiamo i prototipi della nostra cella, come vogliamo vederla
    func cellView() {
        //l'altezza della cella
        shareCell.heightAnchor.constraint(equalToConstant:108).isActive = true
       
        //la foto e rotonda
        photo.layer.cornerRadius = photo.frame.size.width / 2
        //la cella ha gli angoli rotondi
        viewCell.layer.cornerRadius = 16
        
    }
    func selectedCell(){

       // viewCell.backgroundColor = UIColor(displayP3Red: 163/255, green: 192/255, blue: 255/255, alpha: 1)
        viewCell.backgroundColor = UIColor(displayP3Red: 234/255, green: 244/255, blue: 254/255, alpha: 1)
        viewCell.layer.borderWidth = 1
        viewCell.layer.borderColor = UIColor(displayP3Red: 163/255, green: 192/255, blue: 255/255, alpha: 1).cgColor
      
        nomeCard.textColor = UIColor.black
        nome.textColor = UIColor.black
        cognome.textColor = UIColor.black
    }
    func deselectedCell(){
        
        nomeCard.textColor = UIColor.white
        nome.textColor = UIColor.white
        cognome.textColor = UIColor.white
        
        viewCell.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        viewCell.backgroundColor = UIColor.secondarySystemBackground
        
    }
    
}
