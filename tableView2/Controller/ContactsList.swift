//
//  ContactsList.swift
//  passepartooth
//
//  Created by Anna Cvasniuc on 04/03/21.
//

import UIKit
import RealmSwift
import SwipeCellKit

class ContactsList: PeripheralManager, UITableViewDelegate, UITableViewDataSource{

   
    var selectedContact: ContactList!
    let realm = try! Realm()
    var contacts: Results<ContactList>{
        get{
            return realm.objects(ContactList.self)
        }
    }
    
    
    @IBOutlet weak var tableView: UITableView!
   
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        if contacts.count == 0 {
            performSegue(withIdentifier: "goToDemo2", sender: self)
           
        } else {
            print("ho dei contatti")
        }
    }
    //****************************************************************************
    override func viewDidAppear(_ animated: Bool) {
     
        print("data base contacts - ", contacts.description)
        tableView.reloadData()
        
    }
    
    //****************************************************************************
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
              
            return contacts.count

        //print("contacts.count ",contacts.count)
        
    }
    
    //****************************************************************************
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
        
        
        let myContact = contacts[indexPath.row]
        //assegna le informazioni dal db nelle celle
        //cell.nomeCard.text = myContact.titleCard
        cell.nomeCard.text = myContact.nome + " " + myContact.cognome
        cell.phone.text = myContact.cellulare
        cell.mail.text = myContact.email
        
       
        let filename = "\(myContact.id).jpg"
        
        //check if the image is in the .directory
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        
       
        if let pathComponent = url.appendingPathComponent(filename) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            
           
            if fileManager.fileExists(atPath: filePath) {
                let image = UIImage(contentsOfFile: pathComponent.path)
                
             
                if myContact.isPhotoAvailable == true {
                    
                    cell.photo.image = image
                    
                }
                else {
                    cell.photo.image = UIImage(named: "Image")
                }
            } else {
                cell.photo.image = UIImage(named: "Image")
            }
        }
         
        return cell
    }
    
    //****************************************************************************
    //MARK: - < See button
    func seeInfo(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(style: .normal, title: "See") {_,_,_ in
            
            let item = self.contacts[indexPath.row]
            self.selectedContact = item
            
            try! self.realm.write({
                item.done = !item.done
            })
            
            // self.tableView.reloadRows(at: [indexPath], with: .automatic)
            self.performSegue(withIdentifier: "goToSeeContact", sender: self)
            
        }
        action.image = UIImage(named: "Details")
        action.backgroundColor = UIColor(displayP3Red: 18/255, green: 89/255, blue: 248/255, alpha: 1)
        
        return action
    }
    
    //****************************************************************************
    //   MARK: - < Delete button
    func delete(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(style: .normal, title: "Delete") { [self]_,_,_ in
            
            let item = contacts[indexPath.row]
            selectedContact = item
            
            try! self.realm.write({
                item.done = !item.done
            })
            
            // tableView.reloadData()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            performSegue(withIdentifier: "goToDeleteContact", sender: self)
            
        }
        action.image = UIImage(named: "delete")
        action.backgroundColor = UIColor(displayP3Red: 18/255, green: 89/255, blue: 248/255, alpha: 1)
        
        
        return action
    }
    
    //****************************************************************************
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let seeInfo = self.seeInfo(rowIndexPathAt: indexPath)
        let delete = self.delete(rowIndexPathAt: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [seeInfo,delete])
        return swipe
    }
    
    //****************************************************************************
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
         if (segue.identifier == "goToDeleteContact") {
            
            let destinationVC = segue.destination as! DeleteContact
            destinationVC.selected = self.selectedContact
          
         } else if (segue.identifier == "goToSeeContact"){
            
            let destinationVC = segue.destination as! VisualizzaContatto
            destinationVC.selectedContact = self.selectedContact
            
         }
    }
    
}
