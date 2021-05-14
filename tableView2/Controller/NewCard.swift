//
//  EditInfo.swift
//  passepartooth
//
//  Created by Anna Cvasniuc on 10/01/2021.
//

import UIKit
import RealmSwift

class NewCard: PeripheralManager, UITextFieldDelegate {
    
    var selected: Category!
    let realm = try! Realm()
    var tableView: UITableView!
    var categories: Results<Category>{
        get{
            return realm.objects(Category.self)
        }
    }
    
    
    @IBOutlet weak var salvaButton: UIButton!
    @IBOutlet weak var cardName: UITextField!
    
    @IBOutlet weak var defaultCard: UISwitch!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var cognomeTxt: UITextField!
    @IBOutlet weak var cellulare: UITextField!
    @IBOutlet weak var telefono: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var web: UITextField!
    @IBOutlet weak var linkedin: UITextField!
    @IBOutlet weak var facebook: UITextField!
    @IBOutlet weak var instagram: UITextField!
    @IBOutlet weak var note: UITextField!
    
    var imageName: String!
    var imgPicked: UIImage!
    var imageControll: Bool = false
    @IBOutlet weak var profileImage: UIImageView!
  //  @IBOutlet weak var imageChange: UIButton!
  //  var imagePicker : UIImagePickerController!
    
    @IBAction func backButton(_ sender: UIButton) {
        
        _ = navigationController?.popToRootViewController(animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardName.delegate = self
        nome.delegate = self
        cognomeTxt.delegate = self
        cellulare.delegate = self
        telefono.delegate = self
        email.delegate = self
        web.delegate = self
        linkedin.delegate = self
        facebook.delegate = self
        instagram.delegate = self
        note.delegate = self
        
        separatorLine()
        
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        salvaButton.layer.cornerRadius = 12
        
        // Add tap gesture to view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        //imposto come Card predefinita la prima
        if categories.count == 0{
            defaultCard.isOn = true
        } else {
            defaultCard.isOn = false
        }
        
    }
    
    //****************************************************************************
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //add observers to recive UIKeyboardWillShow and UIKeyboardWillHide notification
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // remouve observers to not riceve notification when viewController is in the background
        removeObservers()
    }
    
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
    
    // Method to remove observers
    func removeObservers(){
        NotificationCenter.default.removeObserver(self)
    }
    
    // Method to handle keyboardWillShow notification, we're using this method to adjust scrollview to show hidden textfield under keyboard
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
    
    //****************************************************************************
    //dismiss keyboard when is touching "done"/"invio"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
//    @IBAction func aggiungiFoto(_ sender: UIButton) {
//        imagePressed()
//    }
    
//    func imagePressed(){
//
//        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
//        profileImage.isUserInteractionEnabled = true
//        profileImage.addGestureRecognizer(imageTap)
//
//        imageChange.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
//
//        imagePicker = UIImagePickerController()
//        imagePicker.allowsEditing = true
//        imagePicker.sourceType = .photoLibrary
//        imagePicker.delegate = self
//
//        present(imagePicker, animated: true, completion: nil)
//    }
    
    
//    @objc func openImagePicker(_ sender: Any) {
//        self.present(imagePicker, animated: true, completion: nil)
//
//    }
    
    //****************************************************************************
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
        self.cognomeTxt.addSubview(addSeparatorLine())
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
        //cancello il testo (nome della mia nuova card)
        cardName.text = ""
    }
    
    //****************************************************************************
    @IBAction func defaultButton(_ sender: UISwitch) {
        
        //se il mio db = vuoto allora la mia prima Card = true
        if defaultCard.isOn == true {
            if categories.count == 0{
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
            
            if categories.count == 0{
                defaultCard.isOn = true
                
            } else {
                defaultCard.isOn = false
            }
        }
    }
    
    //****************************************************************************
    //MARK: - < Save info into db
    
    @IBAction func saveInfo(_ sender: UIButton) {
        
        let newCategory = Category()
        
        newCategory.titleCard = cardName.text!
        newCategory.nome = nome.text!
        newCategory.cognome = cognomeTxt.text!
        newCategory.cellulare = cellulare.text!
        newCategory.telefono = telefono.text!
        newCategory.email = email.text!
        newCategory.web = web.text!
        newCategory.linkdin = linkedin.text!
        newCategory.facebook = facebook.text!
        newCategory.instagram = instagram.text!
        newCategory.note = note.text!
        //   newCategory.defaultCard = defaultCard.isOn
        
        if realm.isEmpty{
            newCategory.defaultCard = defaultCard.isOn
        } else {
            newCategory.defaultCard = defaultCard.isOpaque
        }
        
        
        do {
            if ((newCategory.nome == "") || (newCategory.cognome == "")){
                let alert = UIAlertController(title: "Errore", message: "Devi inserire un nome e un cognome", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else if(newCategory.cellulare == "") {
                let alert = UIAlertController(title: "Errore", message: "Devi inserire un numero", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                do {
                    try self.realm.write{
                        newCategory.titleCard = cardName.text!
                        newCategory.id = incrementID()
                        newCategory.defaultCard = defaultCard.isOn
                        
                        //image name avrà lo stesso nome come l'id
                        if imageControll == true{
                            imageName = String(newCategory.id)
                            //con "true" dico nel mio db che ho una foto 
                            newCategory.isPhotoAvailable = true
                            //save the image I choose for profile image into .fileSystem
                            let buildingImage = self.store(image: imgPicked, forKey: imageName, withStorageType: .fileSystem)
                            
                        } 
                        
                        realm.add(newCategory)
                        // self.dismiss(animated: true, completion: nil)
                    }
                } catch {
                    print("Error adding a new Category, \(error)")
                }
            }
        }

        _ = navigationController?.popToRootViewController(animated: true)
        
    }
    
    func incrementID() -> Int {
        
        return (realm.objects(Category.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    
    func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                 in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key + ".jpg")
        
    }
    //Save profile image
    func store(image: UIImage,
               forKey key: String,
               withStorageType storageType: StorageType) {
        if let pngRepresentation = image.jpegData(compressionQuality: 0.8) {
            switch storageType {
            case .fileSystem:
                if let filePath = filePath(forKey: key) {
                    do  {
                        try pngRepresentation.write(to: filePath,
                                                    options: .atomic)
                        
                    } catch let err {
                        print("Saving file resulted in error: ", err)
                    }
                }
            case .userDefaults:
                UserDefaults.standard.set(pngRepresentation,
                                          forKey: key)
            }
        }
    }
}

//****************************************************************************
extension NewCard: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //if the image is deleted
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            print("picked image 1")
            self.profileImage.image = pickedImage
            imgPicked = pickedImage
            imageControll = true //controllo che ho scelto un imagine
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
