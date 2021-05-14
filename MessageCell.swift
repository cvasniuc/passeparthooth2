//
//  MessageCell.swift
//  passepartooth
//
//  Created by Anna Cvasniuc on 08/01/2021.
//

import UIKit

class MessageCell: UITableViewCell {
    
    weak var delegate: MyCellHandlerProtocol?
    static let id = "MessageCell"
    private var nr: Int = 0
    
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var messCell: UIView!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var nomeCard: UILabel!
    @IBOutlet weak var photo: UIImageView!
   
    

    override func awakeFromNib() {
        super.awakeFromNib()
  
        cellView()
    }

    //definiamo i prototipi della nostra cella, come vogliamo vederla
    func cellView() {
        //l'altezza della cella
        messCell.heightAnchor.constraint(equalToConstant:90).isActive = true
       
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
        phone.textColor = UIColor.black
        mail.textColor = UIColor.black
        
      //  shareButton.setImage(UIImage(named: "BTN2"), for: .normal)
    }
    func deselectedCell(){
//        viewCell.layer.borderColor = UIColor.white.cgColor
//        viewCell.backgroundColor = UIColor.white
        nomeCard.textColor = UIColor.white
        phone.textColor = UIColor.white
        mail.textColor = UIColor.white
        viewCell.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        viewCell.backgroundColor = UIColor.secondarySystemBackground
        
      //  shareButton.setImage(UIImage(named: "BTN2"), for: .normal)
    }
    
    @IBAction func didTapDetails() {
        print("static pressed")
        nr = 1
        delegate?.didTapButtonDetails(with: nr)
    }    
}
