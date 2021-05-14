//
//  Category.swift
//  passepartooth
//
//  Created by Anna Cvasniuc on 29/12/2020.
//

import Foundation
import RealmSwift

class Category: Object {
    //@objc dynamic var categoryReference: Category? 
    
    @objc dynamic var id: Int = 0
    @objc dynamic var done = false //need to know the status of a cell for checkmark
    @objc dynamic var defaultCard = false // è la mia card predefinita 
    @objc dynamic var titleCard = ""
    @objc dynamic var nome: String = ""
    @objc dynamic var cognome = ""
    @objc dynamic var cellulare = ""
    @objc dynamic var telefono = ""
    @objc dynamic var email = ""
    @objc dynamic var web = ""
    @objc dynamic var linkdin = ""
    @objc dynamic var facebook = ""
    @objc dynamic var instagram = ""
    @objc dynamic var note = ""
    
    
    @objc dynamic var photoDataString: String = ""
    @objc dynamic var photoData: NSData? = nil
    @objc dynamic var isPhotoAvailable = false
   
  
    

}
class ContactList: Object {
   
    @objc dynamic var id: Int = 0
    @objc dynamic var done = false //need to know the status of a cell for checkmark
    @objc dynamic var defaultCard = false // è la mia card predefinita
    @objc dynamic var titleCard = ""
    @objc dynamic var nome: String = ""
    @objc dynamic var cognome = ""
    @objc dynamic var cellulare = ""
    @objc dynamic var telefono = ""
    @objc dynamic var email = ""
    @objc dynamic var web = ""
    @objc dynamic var linkdin = ""
    @objc dynamic var facebook = ""
    @objc dynamic var instagram = ""
    @objc dynamic var note = ""
    @objc dynamic var data = Data()   //la data quando ho ricevuto questo contatto/card
    
    @objc dynamic var photoDataString: String = ""
    @objc dynamic var photoData: NSData? = nil
    @objc dynamic var isPhotoAvailable = false

}

