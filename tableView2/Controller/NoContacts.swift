//
//  NoContacts.swift
//  passepartooth
//
//  Created by Anna Cvasniuc on 18/03/21.
//

import UIKit

class NoContacts: UIViewController {

    @IBOutlet weak var text: UILabel!
    let preferredLanguage = NSLocale.preferredLanguages[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attrs = [NSAttributedString.Key.foregroundColor : UIColor(displayP3Red: 18/255, green: 89/255, blue: 248/255, alpha: 1)]
        let attrs2 = [NSAttributedString.Key.foregroundColor : UIColor(displayP3Red: 1/255, green: 31/255, blue: 99/255, alpha: 1)]
        
        if preferredLanguage.starts(with: "it") {
            print("this is italian")
            
            let attributedString1 = NSMutableAttributedString(string:" Qui troverai un elenco di tutti \ni contatti che hai scambiato. \nVai avanti, corri su ", attributes:attrs)
            
            let attributedString2 = NSMutableAttributedString(string:"Le mie Carte", attributes:attrs2)
            
            let attributedString3 = NSMutableAttributedString(string:"\ne inizia a fare nuove amicizie!", attributes:attrs)
            
            attributedString1.append(attributedString2)
            attributedString1.append(attributedString3)
            self.text.attributedText = attributedString1
        } else {
            
            print("this is english")
            
        }
    }


 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
