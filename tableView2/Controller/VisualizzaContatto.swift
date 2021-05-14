//
//  EditCard.swift
//  passepartooth
//
//  Created by Anna Cvasniuc on 18/01/2021.
//

import UIKit
import RealmSwift

class VisualizzaContatto: PeripheralManager, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var selectedContact: ContactList!
    let realm = try! Realm()
    var tableView: UITableView!
    
    
    @IBOutlet weak var seeImage: UIButton!
    
    @IBOutlet weak var nomeContatto: UILabel!
    
    var imageControll: Bool = false
    var imageName: String!
    var imagePicker : UIImagePickerController!
    var imgPicked: UIImage!
    
    @IBAction func backButton(_ sender: UIButton) {
        _ = navigationController?.popToRootViewController(animated: true)
        // self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var cardName: UITextField!
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        separatorLine()
        //la foto e rotonda
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        
        
        loadItems()
        
    }
    //****************************************************************************
    //MARK: - < Separator Line aggiungo la riga sotto le mie celle
    func addSeparatorLine()-> UIView{
        
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
    @IBAction func seeFoto(_ sender: UIButton) {
        imagePressed()
    }
    
    func imagePressed(){
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(imageTap)
        
        seeImage.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    //****************************************************************************
    @objc func openImagePicker(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                 in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key + ".jpg")
        
    }
    
    //****************************************************************************
    //MARK: - <loadItems
    func loadItems() {
        
        let currentContact = self.selectedContact
        
        nomeContatto.text = currentContact?.nome
        cardName.text = currentContact?.titleCard
        nome.text = currentContact?.nome
        cognome.text = currentContact?.cognome
        cellulare.text = currentContact?.cellulare
        telefono.text = currentContact?.telefono
        email.text = currentContact?.email
        web.text = currentContact?.web
        linkedin.text = currentContact?.linkdin
        facebook.text = currentContact?.facebook
        instagram.text = currentContact?.instagram
        note.text = currentContact?.note
        
        //check if it is an image
        if currentContact?.isPhotoAvailable == true {
            
            let filename = "\(currentContact!.id).jpg"
            //check if the image is in the .directory
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
            
            
            
            if let pathComponent = url.appendingPathComponent(filename) {
                let filePath = pathComponent.path
                let fileManager = FileManager.default
                
                if fileManager.fileExists(atPath: filePath) {
                    let image = UIImage(contentsOfFile: pathComponent.path)
                    
                    profileImage.image = image
                    
                    
                    if currentContact?.isPhotoAvailable == true {
                        
                        profileImage.image = image
                        
                    }
                    else {
                        profileImage.image = UIImage(named: "Image")
                        
                    }
                } else {
                    profileImage.image = UIImage(named: "Image")
                    
                }
            }
            
        }else {
            print("errore!")
        }
        
    }
}
