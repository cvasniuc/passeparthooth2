//
//  Home.swift
//  passepartooth
//
//  Created by Anna Cvasniuc on 10/03/21.
//

import UIKit

class Home: PeripheralManager {
    
    @IBOutlet weak var labelText: UILabel!
    //let preferredLanguage = NSLocale.preferredLanguages[0]
    
    override func viewDidLoad() {
        //forzo l'interfaccia di essere sempre light e mai in dark mode
        overrideUserInterfaceStyle = .light
        
        super.viewDidLoad()
        let attrs = [NSAttributedString.Key.foregroundColor : UIColor(displayP3Red: 18/255, green: 89/255, blue: 248/255, alpha: 1)]
        let attrs2 = [NSAttributedString.Key.foregroundColor : UIColor(displayP3Red: 1/255, green: 31/255, blue: 99/255, alpha: 1)]
        
        if preferredLanguage.starts(with: "it") {
            print("this is italian")
            
            
            
            let attributedString1 = NSMutableAttributedString(string:"Facciamo qualcosa! \nseleziona ", attributes:attrs)
            
            let attributedString2 = NSMutableAttributedString(string:"Le mie Cards", attributes:attrs2)
            
            let attributedString3 = NSMutableAttributedString(string:"\ndal menù sottostante.", attributes:attrs)
            
            attributedString1.append(attributedString2)
            attributedString1.append(attributedString3)
            self.labelText.attributedText = attributedString1
        } else {
            
            print("this is english")
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

