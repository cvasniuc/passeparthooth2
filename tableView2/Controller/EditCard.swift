//
//  EditCard.swift
//  passepartooth
//
//  Created by Anna Cvasniuc on 18/01/2021.
//

import UIKit
import RealmSwift

class EditCard: PeripheralManager, UITextFieldDelegate {
    
    var selected: Category!
    let realm = try! Realm()
    var tableView: UITableView!
    
    
    
    // @IBOutlet weak var imageChange: UIButton!
    @IBOutlet weak var salvaButton: UIButton!
    var imageControll: Bool = false
    var imageName: String!
    var imagePicker : UIImagePickerController!
    var imgPicked: UIImage! //la variabile che uso per salvare la foto in .fileSystem
    
    @IBAction func backButton(_ sender: UIButton) {
        _ = navigationController?.popToRootViewController(animated: true)
        // self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cardName: UITextField!
    // @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var cognome: UITextField!
    @IBOutlet weak var cellulare: UITextField!
    @IBOutlet weak var telefono: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var web: UITextField!
    @IBOutlet weak var linkedin: UITextField!
    @IBOutlet weak var facebook: UITextField!
    @IBOutlet weak var instagram: UITextField!
    @IBOutlet weak var note: UITextField!
    
    @IBOutlet var profileImage: UIImageView!
    
    @IBOutlet weak var defaultCard: UISwitch!
    
    @IBAction func defaultCard(_ sender: Any) {
        
        //de il mio db = vuoto allora la mia prima Card = true
        if defaultCard.isOn == true {
            if realm.isEmpty == true{
                defaultCard.isOn = true
                
            } else {
                // se il mio db NON e vuoto, cambio la mia Default Card
                let changeDefault = realm.objects(Category.self).filter("defaultCard == true").first
                try! realm.write {
                    changeDefault!.defaultCard = false
                    //defaultCard!.isOn = true
                }
            }
        }
        // se il mio DB = vuoto la mia prima card = Default Card
        else {
            defaultCard.isOn = false
            
            if realm.isEmpty == true{
                defaultCard.isOn = true
                
            } else {
                defaultCard.isOn = false
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        separatorLine()
        //la foto e rotonda
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        salvaButton.layer.cornerRadius = 12
        
        loadItems()
        
        cardName.delegate = self
        nome.delegate = self
        cognome.delegate = self
        cellulare.delegate = self
        telefono.delegate = self
        email.delegate = self
        web.delegate = self
        linkedin.delegate = self
        facebook.delegate = self
        instagram.delegate = self
        note.delegate = self
        
        // Add tap gesture to view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        let currentCategory = self.selected
        
        if currentCategory?.defaultCard == true{
            defaultCard.isOn = true
        } else {
            defaultCard.isOn = false
        }
        
    }
    
    //****************************************************************************
    //MARK: - <Keyboard 
    
    // Method to handle tap event on the view and dismiss keyboard
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        //this shoud hide kwyboard for the view
        view.endEditing(true)
    }
    
    // Observers for 'UIKeyboardWillShow' and 'UIKeyboardWillHide' notification
    @objc func addObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) {
            notification in
            self.keyboardWillShow(notification: notification as NSNotification)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) {
            notification in
            self.keyboardWillHide(notification: notification)
        }
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self)
    }
    
    //  we're using this method to adjust scrollview to show hidden textfield under keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView.contentInset = contentInset
    }
    // Method to reset scrollView when keyboard is hidden
    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
    }
    //dismiss keyboard when is touching "done"/"invio"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //***********************************************************************************
    //MARK: - < Separator Line aggiungo la riga sotto le mie celle
    func addSeparatorLine()-> UIView{
        
        //calcolo la larghezza del mio schermo e vado a togliere "-15" per avere la riga piu corta
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width - 15
        
        //disegno la riga sotto le mie celle (textField)
        let lineView = UIView(frame: CGRect(x: 0, y: 40, width: screenWidth, height: 1.0))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor.lightGray.cgColor
        return lineView
    }
    //****************************************************************************
    func separatorLine(){
        
        self.nome.addSubview(addSeparatorLine())
        self.cognome.addSubview(addSeparatorLine())
        self.cellulare.addSubview(addSeparatorLine())
        self.telefono.addSubview(addSeparatorLine())
        self.email.addSubview(addSeparatorLine())
        self.web.addSubview(addSeparatorLine())
        self.linkedin.addSubview(addSeparatorLine())
        self.facebook.addSubview(addSeparatorLine())
        self.instagram.addSubview(addSeparatorLine())
        self.note.addSubview(addSeparatorLine())
    }
    
    //****************************************************************************
    @IBAction func editButtin(_ sender: UIButton) {
        cardName.text = ""
        
    }
    
    //****************************************************************************
    //MARK: - < Save info
    
    
    @IBAction func saveInfo(_ sender: UIButton) {
        
        if let currentCategory = self.selected {
            
            try! realm.write{
                
                currentCategory.titleCard = cardName.text!
                currentCategory.nome = nome.text!
                currentCategory.cognome = cognome.text!
                currentCategory.cellulare = cellulare.text!
                currentCategory.telefono = telefono.text!
                currentCategory.email = email.text!
                currentCategory.web = web.text!
                currentCategory.linkdin = linkedin.text!
                currentCategory.facebook = facebook.text!
                currentCategory.instagram = instagram.text!
                currentCategory.note = note.text!
                
                
                do{
                    if ((currentCategory.nome == "") && (currentCategory.cognome == "")){
                        let alert = UIAlertController(title: "Errore", message: "Devi inserire un nome o un cognome", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    } else if(currentCategory.cellulare == "") {
                        let alert = UIAlertController(title: "Errore", message: "Devi inserire un numero", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        _ = navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
        
    }
    
    //***********************************************************************************
    //MARK: - <loadItems
    func loadItems() {
        
        let currentCategory = self.selected
        
        cardName.text = currentCategory?.titleCard
        nome.text = currentCategory?.nome
        cognome.text = currentCategory?.cognome
        cellulare.text = currentCategory?.cellulare
        telefono.text = currentCategory?.telefono
        email.text = currentCategory?.email
        web.text = currentCategory?.web
        linkedin.text = currentCategory?.linkdin
        facebook.text = currentCategory?.facebook
        instagram.text = currentCategory?.instagram
        note.text = currentCategory?.note
        
        
    }
}

