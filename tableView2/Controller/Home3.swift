//
//  Home3.swift
//  passepartooth
//
//  Created by Anna Cvasniuc on 10/03/21.
//

import UIKit

class Home3: UIViewController {
    @IBOutlet weak var labelText: UILabel!
    
    let preferredLanguage = NSLocale.preferredLanguages[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attrs = [NSAttributedString.Key.foregroundColor : UIColor(displayP3Red: 18/255, green: 89/255, blue: 248/255, alpha: 1)]
        let attrs2 = [NSAttributedString.Key.foregroundColor : UIColor(displayP3Red: 1/255, green: 31/255, blue: 99/255, alpha: 1)]
        
      
        if preferredLanguage.starts(with: "it") {
          //  print("this is italian")
 
            let attributedString = NSMutableAttributedString(string:"\nClicca sul pulsante \ncon il + per aggiungere \nla tua prima carta", attributes:attrs2)

            attributedString.append(attributedString)
    
            self.labelText.attributedText = attributedString
           
        } else {
            
            print("this is english")
            
        }
    }
        
 
    
   
    @IBAction func addButton(_ sender: Any) {
        performSegue(withIdentifier: "goToNewCard", sender: self)
    }
}
