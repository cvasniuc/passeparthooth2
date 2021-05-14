//
//  DeleteContact.swift
//  passepartooth
//
//  Created by Anna Cvasniuc on 07/03/21.
//

//
//  DeleteVC.swift
//  passepartooth
//
//  Created by Anna Cvasniuc on 17/01/2021.
//

import UIKit
import RealmSwift

class DeleteContact: UIViewController {
    
    @IBOutlet weak var viewPopUp: UIView!
    
    @IBOutlet weak var rimuoviButton: UIButton!
    @IBOutlet weak var anullaButton: UIButton!
    var selected: ContactList!
    let realm = try! Realm()
    var imageControll: Bool = false
    
    @IBAction func annullaButton(_ sender: UIButton) {
        _ = navigationController?.popToRootViewController(animated: true)
        
    }
    
    @IBAction func rimuoviButton(_ sender: UIButton) {
        
     


        if let currentContact = self.selected {
            do {
                try self.realm.write{

                    //verifico se nel mio db esiste la foto nella categoria selezionata per cancellare
                    if currentContact.isPhotoAvailable == true {
                        print("delete foto from db",currentContact.isPhotoAvailable)

                        deleteFotoFromDB()

                        realm.delete(currentContact)
                    } else {
                        realm.delete(currentContact)
                    }
                    _ = navigationController?.popToRootViewController(animated: true)

                }
            } catch {
                print("Error deleting the category, \(error)")
            }
        }
  
    }
    
    func deleteFotoFromDB(){
        
        if let currentCategory = self.selected {
            //verifico se ho una foto nel mio db per poter cancellare
            // if currentCategory.isPhotoAvailable == true {
            let filename = "\(currentCategory.id).jpg"
            
            //check if the image is in the .directory
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
            
            if let pathComponent = url.appendingPathComponent(filename) {
                let filePath = pathComponent.path
                let fileManager = FileManager.default
                
                if fileManager.fileExists(atPath: filePath) {
                    let image = UIImage(contentsOfFile: pathComponent.path)
                    
                    //cancello la foto
                    
                    try! fileManager.removeItem(at: pathComponent)
                }
            }
        }
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewPopUp.layer.cornerRadius = 8
        self.viewPopUp.layer.masksToBounds = true
        
        rimuoviButton.layer.cornerRadius = 10
        anullaButton.layer.borderWidth = 1
        anullaButton.layer.cornerRadius = 10
        anullaButton.layer.borderColor = UIColor(displayP3Red: 4/255, green: 51/255, blue: 255/255, alpha: 1).cgColor
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        
    }
}

