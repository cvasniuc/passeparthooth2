//
//  CategoryVC.swift
//  passepartooth
//
//  Created by Anna Cvasniuc on 29/12/2020.
//

import UIKit
import RealmSwift
import SwipeCellKit

class MyCards: PeripheralManager {
    
    let realm = try! Realm()
    var selectedCategory: Category! //use this property to store the curent category
    var cards = try! Realm().objects(Category.self).sorted(byKeyPath: "titleCard",ascending: true)
    var selectedIndexPaths = [IndexPath]()
    var selected : Bool = false //the index path
    var selectedCard : Bool!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shareButton: UIButton!
    
    
    var url : URL!
    var categories: Results<Category>{
        get{
            return realm.objects(Category.self)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        //  tableView.reloadData()
        
        self.tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        shareButton.layer.cornerRadius = 12
        
        // print(Realm.Configuration.defaultConfiguration.fileURL)
        print("Categoriesc.count",categories.count)
        
        if categories.count == 0{
            goToDemo()
        } else {
           print("controllo se ho delle card")
        }

    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        
    }
    func goToDemo(){
        performSegue(withIdentifier: "goToDemo", sender: self)
    }
    //****************************************************************************
    //MARK: - Add New Card
    @IBAction func addCard(_ sender: Any) {
        
        performSegue(withIdentifier: "goToNewCard", sender: self)
        
        //self.tableView.reloadData()
    }
}

//****************************************************************************
//MARK: - < Add DataSource Methods
extension MyCards: UITableViewDataSource, UITableViewDelegate{
    
    //MARK: - < Edit button
    func edit(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(style: .normal, title: "Edit") {_,_,_ in
            
            let item = self.categories[indexPath.row]
            self.selectedCategory = item
            
            try! self.realm.write({
                item.done = !item.done
            })
            
            // self.tableView.reloadRows(at: [indexPath], with: .automatic)
            self.performSegue(withIdentifier: "goToEdit", sender: self)
            
        }
        action.image = UIImage(named: "edit2")
        action.backgroundColor = UIColor(displayP3Red: 18/255, green: 89/255, blue: 248/255, alpha: 1)
        
        return action
    }
    
    //****************************************************************************
    //   MARK: - < Delete button
    func delete(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(style: .normal, title: "Delete") { [self]_,_,_ in
            
            let item = categories[indexPath.row]
            selectedCategory = item
            
            try! self.realm.write({
                item.done = !item.done
            })
            
            // tableView.reloadData()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            performSegue(withIdentifier: "goToDelete", sender: self)
            
        }
        action.image = UIImage(named: "delete")
        action.backgroundColor = UIColor(displayP3Red: 18/255, green: 89/255, blue: 248/255, alpha: 1)
        
        
        return action
    }
    
    //****************************************************************************
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = self.edit(rowIndexPathAt: indexPath)
        let delete = self.delete(rowIndexPathAt: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [edit,delete])
        return swipe
    }
    
    //****************************************************************************
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        return categories.count
    }
    
    //****************************************************************************
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
        
        
        let category = categories[indexPath.row]
        //assegna le informazioni dal db nelle celle
        cell.nomeCard.text = category.titleCard
        //cell.nomeCard.text = category.nome + " " + category.cognome
        cell.phone.text = category.cellulare
        cell.mail.text = category.email
        
        
        let filename = "\(category.id).jpg"
        
        //check if the image is in the .directory
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        
        
        if let pathComponent = url.appendingPathComponent(filename) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            
            
            if fileManager.fileExists(atPath: filePath) {
                let image = UIImage(contentsOfFile: pathComponent.path)
                
                if category.isPhotoAvailable == true {
                    
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
    //MARK: - < Chechmark
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //tableView.allowsSelection = true
        // tableView.backgroundView?.backgroundColor = .white
        let cell = tableView.cellForRow(at: indexPath)
        
        
        var cellSelected = tableView.cellForRow(at: indexPath) as! MessageCell
        cellSelected.selectedCell()
        
        //deselect it if the row is selected
        if let index = selectedIndexPaths.index(of: indexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            cellSelected.deselectedCell()
            
            shareButton.backgroundColor = UIColor(displayP3Red: 179/255, green: 191/255, blue: 222/255, alpha: 1)
            // shareButton.setBackgroundImage(UIImage(named: "BTN"), for: .normal)
            
            
            selectedIndexPaths.remove(at: index)
            selectedCard = false
            
            
        }
        else { //select it if the row is deselected
            cellSelected.selectedCell()
            shareButton.backgroundColor = UIColor(displayP3Red: 4/255, green: 51/255, blue: 255/255, alpha: 1)
            //shareButton.setBackgroundImage(UIImage(named: "BTN2"), for: .normal)
            selectedIndexPaths.append(indexPath)
            //cellSelected.nomeCard.textColor = UIColor.secondarySystemBackground
            //cellSelected.nomeCard.backgroundColor = UIColor.secondarySystemBackground
            selectedCard = true
            
            let item = categories[indexPath.row]
            selectedCategory = item
            
        }
        selected = true
        
    }
    
    //****************************************************************************
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        var cellSelected = tableView.cellForRow(at: indexPath) as! MessageCell
        
        if selected == true {
            
            // shareButton.isHighlighted = false
            tableView.deselectRow(at: indexPath, animated: true)
            cellSelected.deselectedCell()
            
            shareButton.backgroundColor = UIColor(displayP3Red: 234/255, green: 244/255, blue: 254/255, alpha: 1)
            selectedCard = false
            
            tableView.reloadData()
        }
        else {
            cellSelected.selectedCell()
            shareButton.backgroundColor = UIColor(displayP3Red: 4/255, green: 51/255, blue: 255/255, alpha: 1)
            selectedCard = true
            
            tableView.reloadData()
        }
    }
    
    //****************************************************************************
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //  let selectedCardIndexPath = self.tableView?.indexPathForSelectedRow?.row ?? 0
        
        if( segue.identifier == "goToNewCard"){
            
            let destinationVC = segue.destination as! NewCard
            destinationVC.selected = selectedCategory
            destinationVC.tableView = self.tableView
            
        }
        
        else if (segue.identifier == "goToDelete") {
            
            let destinationVC = segue.destination as! DeleteVC
            destinationVC.selected = self.selectedCategory
            
        }
        else if (segue.identifier == "goToEdit") {
            
            let destinationVC = segue.destination as! EditCard
            destinationVC.selected = self.selectedCategory
            destinationVC.tableView = self.tableView
            
        }
        else if (segue.identifier == "goToScan"){
            
            let destinationVC = segue.destination as! CentralManager
            destinationVC.category = self.selectedCategory
            
        }
    }
    
    //****************************************************************************
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // selected row for addind more information (editInfo)
    //****************************************************************************
    func didTapButtonDetails(with nr: Int) {
        
        print("nr-> \(nr)")
        self.performSegue(withIdentifier: "goToNewCard", sender: self)
    }
    
    //****************************************************************************
    @IBAction func shareButton(_ sender: UIButton) {
        
        if (selectedCard == true) {
            self.performSegue(withIdentifier: "goToScan", sender: self)
        } else {
            print("you need to select a card to share")
        }
        
    }
    
}
