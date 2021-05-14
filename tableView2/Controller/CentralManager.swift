//
//  ScanPeripheral.swift
//  passepartooth
//
//  Created by Anna Cvasniuc on 08/02/21.
//

import UIKit
import RealmSwift
import CoreBluetooth

class CentralManager: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, UIImagePickerControllerDelegate {
    
    var discovererChars : [String: CBCharacteristic] = [:]
    
    let realm = try! Realm()
    //la specifica categoria selezionata
    var category: Category!
    
    var categories: Results<Category>{
        get{
            return realm.objects(Category.self)
        }
    }
    
    var contact: ContactList!
    var discoveredPeripheral : CBPeripheral?
    
    var bLEDevices : [CBPeripheral] = []
    var devicesSelected : [CBPeripheral] = []
    var selectedIndexPaths = [IndexPath]()
    var nrIndexPath : Int = 0
    
    var provaService : CBService!
    var writeIterationsComplete = 0
    var lasrP = 0
    var nrTotalPachetti = 0
    let defaultIterations = 20 // change this value based on test usecase
    
    var sendDataIndex = 0
    
    var myDevices = [String]() //i dispositivi trovati
    var photoString : String = ""
    var selectedContact : Bool!
    var selected : Bool = false //the index path
    var peripheral: CBPeripheral!
    var CBmanager : CBCentralManager!
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //le mie variabile per visualizzare le info delle peripheral trovate
    var nomeCard : String = ""
    var nome : String = ""
    var cognome : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "ShareCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        CBmanager = CBCentralManager(delegate: self, queue: nil, options: nil)
        shareButton.layer.cornerRadius = 12
        
        //salvaButton.setBackgroundColor(.white, for: .highlighted)
        shareButton.setBackgroundColor(.white, for: .highlighted)
    }
    //****************************************************************************
    //    func filePath(forKey key: String) -> URL? {
    //        let fileManager = FileManager.default
    //        guard let documentURL = fileManager.urls(for: .documentDirectory,
    //                                                 in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
    //
    //        return documentURL.appendingPathComponent(key + ".jpg")
    //
    //    }
    
    //****************************************************************************
    //    //Save profile image
    //    func store(image: UIImage,
    //               forKey key: String,
    //               withStorageType storageType: StorageType) {
    //        if let pngRepresentation = image.jpegData(compressionQuality: 0.8) {
    //            switch storageType {
    //            case .fileSystem:
    //                if let filePath = filePath(forKey: key) {
    //                    do  {
    //                        try pngRepresentation.write(to: filePath,
    //                                                    options: .atomic)
    //
    //                    } catch let err {
    //                        print("Saving file resulted in error: ", err)
    //                    }
    //                }
    //            case .userDefaults:
    //                UserDefaults.standard.set(pngRepresentation,
    //                                          forKey: key)
    //            }
    //        }
    //    }
    //****************************************************************************
    //MARK: - < Share Button
    
    @IBAction func shareButton(_ sender: UIButton) {
        //need to do a handler with the contact founded
        
        if selectedContact == true {
            
            print("PROVA -- selectedContact == true ")
            //mi ricconetto alla peripheral scelta
            connectBleDivace(peripheral: devicesSelected[nrIndexPath])
            
        } else {
            print("devi selezionare un contatto ")
        }
    }
    
    //****************************************************************************
    //MARK: - < Back Button
    @IBAction func BackButton(_ sender: UIButton) {
        _ = navigationController?.popToRootViewController(animated: true)
        
    }
    
    //****************************************************************************
    //MARK: - < central Manager update state
    //centralManagerDidUpdateState delegates methods in order get notified Bluetooth has powered on, and then we can start scanning peripherals, by calling .scanForPeripherals
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch (central.state) {
        
        case .unknown:
            print("CoreBluetooth BLE state is unknown")
        case .resetting:
            print("CoreBluetooth BLE is resetting")
        case .unsupported:
            print("CoreBluetooth BLE hardware is unsupported on this platform")
        case .unauthorized:
            print("CoreBluetooth BLE state is unauthorized")
        case .poweredOff:
            print("CoreBluetooth BLE hardware is powered off")
        case .poweredOn:
            print("CoreBluetooth BLE hardware is powered on and ready")
            print("Scanning perifierals for services that I want")
            
            //faccio la scansione di tutti i dispositivi che trovo
            central.scanForPeripherals(withServices: [K.myUUID], options: nil)
            
        @unknown default:
            print("Error\(Error.self)")
        }
    }
    
    //****************************************************************************
    //MARK: - Received_RSSI to determinate the distance and discover peripheral
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any] = [CBCentralManagerScanOptionAllowDuplicatesKey:NSNumber(value: false)] , rssi RSSI: NSNumber) {
        
        let distance = RSSI.intValue
        
        if (distance > -70 )  {
            
            self.peripheral?.delegate = self
            myDevices.append(peripheral.name ?? "No name")
            bLEDevices.append(peripheral)
            
            //mi connetto con tutti i dispositivi trovati intorno a me
            connectBleDivace(peripheral: peripheral)
            
        } else {
            print("Devices din't found!")
            
        }
        
    }
    //****************************************************************************
    //MARK: - < Disconnect from peripheral
    func disconnect(peripheral: CBPeripheral){
        
        CBmanager!.cancelPeripheralConnection(peripheral)
        print("Disconect")
        
    }
    //****************************************************************************
    //MARK: - < Create a connection with peripheral
    func connectBleDivace (peripheral: CBPeripheral) {
        
        CBmanager!.connect(peripheral, options: nil)
        
        switch peripheral.state {
        case .connecting:
            print("*** Connecting ... ",peripheral )
            self.discoveredPeripheral = peripheral
        case .connected:
            print("*** connected ... ",peripheral )
            
        case .disconnected:
            print("*** Disconnected....")
        default:
            print("*** Errore --- ",peripheral )
        }
    }
    
    //****************************************************************************
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        // self.CBmanager.stopScan()
        peripheral.delegate = self
        self.peripheral = peripheral
        
        if peripheral.state == .connected{
            self.CBmanager.stopScan()
            spinner.stopAnimating()
            
            peripheral.discoverServices(nil)
            
        } else {
            print("peripheral is disconnected --- Did Connect")
        }
        
    }
    //****************************************************************************
    //MARK: - < Peripheral did discover Services
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if let error = error {
            print("did discover Service fail \(error)")
            return
        }
        
        for service in (peripheral.services)! {
            
            peripheral.discoverServices([K.myUUID2])
            //mi chiama la funzione didUpdateValueFor characteristic
            
            peripheral.discoverCharacteristics([K.myCharNomeCardUUID,K.myCharNomeUUID, K.myCharCognomeUUID, K.charDefault], for: service)
            // peripheral.discoverCharacteristics(nil, for: service)
            
        }
    }
    
    //****************************************************************************
    func readCharacteristics( char: CBCharacteristic) {
        
        if (char.value != nil && char.uuid == K.myCharNomeCardUUID ){
            let messageText = String(data: char.value as! Data, encoding: String.Encoding.utf8) as String?
            
            nomeCard = String(messageText!)
            myDevices.append(nomeCard)
            
        } else {
            print("char.value K.myCharNomeUUID ERRORE")
        }
        //**************************************************
        if (char.value != nil && char.uuid == K.myCharNomeUUID){
            let messageText = String(data: char.value as! Data, encoding: String.Encoding.utf8) as String?
            
            print("******** nome",nome)
            nome = String(messageText!)
            myDevices.append(nome)
            
        } else {
            print("char.value K.myCharPhoneUUID ERRORE 2")
        }
        //**************************************************
        if (char.value != nil && char.uuid == K.myCharCognomeUUID){
            
            let messageText = String(data: char.value as! Data, encoding: String.Encoding.utf8) as String?
            
            cognome = String(messageText!)
            myDevices.append(cognome)
            
        } else {
            
            print("Errore char.value is NIL ")
        }
    }
    
    //****************************************************************************
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if let error = error {
            print(" didDiscoverCharacteristicsFor service error \(error.localizedDescription)")
            return
        }
        
        //Cerco tutte le charatteritiche nel mio servizio trovato
        for char in service.characteristics! {
            provaService = service
            
            if char.properties.contains(.read) {
                
                discovererChars[char.uuid.uuidString] = char
                //mi chiama la funzione didUpdateValueFor characteristic che mi legge le caratteristiche
                self.peripheral.readValue(for: char)
                readCharacteristics(char: char)
                
            } else {
                print("errore 1 else")
            }
            
            //***********************************************************************
            
            if (selectedContact == true && char.properties.contains(.write)){
                
                
                let jsonObject = ContactCodable(titleCard: category.titleCard, nome: category.nome, cognome: category.cognome, cellulare: category.cellulare, telefono: category.telefono, email: category.email, web: category.web, linkdin: category.linkdin, facebook: category.facebook, instagram: category.instagram, note: category.note)
                
                let jsonObjectData = try? JSONEncoder().encode(jsonObject)
                
                peripheral.writeValue(jsonObjectData!, for: discovererChars[char.uuid.uuidString]!, type: .withResponse)
                
            }  else {
                print("Error to send JSON data")
            }
        }
        tableView.reloadData()
        
    }
    
    //****************************************************************************
    // Convert from JSON to nsdata
    func jsonToNSData(json: AnyObject) -> NSData?{
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil;
    }
    
    
    //****************************************************************************
    //MARK: - < Peripheral Write Value for Characteritic
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if let error = error {
            print("Did Write Value For characteristic service error \(error.localizedDescription)")
            return
        }
        
        let alert = UIAlertController(title: "", message: "Contatto Inviato Correttamente", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        print("didWriteValueFor characteristic success")
        disconnect(peripheral: peripheral)
    }
}

//****************************************************************************
// MARK: - Table view data source

extension CentralManager :  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var sum = 0
        if bLEDevices.count == 0 {
            //print("myDevices.count == 0")
            return 0
        } else {
            sum = bLEDevices.count
            return sum
        }
    }
    
    //****************************************************************************
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ShareCell
        
        
        let category = categories[indexPath.row]
        
        //assegna le informazioni trovate dalle peripheriche nella mia cella
        cell.nomeCard.text = nomeCard
        cell.nome.text = nome
        cell.cognome.text = cognome
        
        
        return cell
        
    }
    
    //****************************************************************************
    //MARK: - < Select the row/ contact a chi li voglio inviare la mia card
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.allowsSelection = true
        //let cell = tableView.cellForRow(at: indexPath)
        
        var cellSelected = tableView.cellForRow(at: indexPath) as! ShareCell
        
        cellSelected.selectedCell()
        //append tutti i dispostivi trovati
        devicesSelected.append(bLEDevices[indexPath.row])
        //deselect it if the row is selected
        if let index = selectedIndexPaths.index(of: indexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            cellSelected.deselectedCell()
            shareButton.backgroundColor = UIColor(displayP3Red: 234/255, green: 244/255, blue: 254/255, alpha: 1)
            // shareButton.setBackgroundImage(UIImage(named: "BTN"), for: .normal)
            selectedIndexPaths.remove(at: index)
            selectedContact = false
            
            
        }
        else { //select it if the row is deselected
            
            cellSelected.selectedCell()
            shareButton.backgroundColor = UIColor(displayP3Red: 4/255, green: 51/255, blue: 255/255, alpha: 1)
            //shareButton.setBackgroundImage(UIImage(named: "BTN2"), for: .normal)
            selectedIndexPaths.append(indexPath)
            selectedContact = true
            
            //aggiungo nel nuovo array tutti i dispositivi selezionati
            devicesSelected.append(bLEDevices[indexPath.row])
            nrIndexPath = indexPath.row
            //print("nrIndexPath",nrIndexPath)
            
            //mi disconetto dalle peripheral
            disconnect(peripheral: peripheral)
            //print("2 Stato ",peripheral.description)
            
        }
        selected = true
        
    }
    //****************************************************************************
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        var cellSelected = tableView.cellForRow(at: indexPath) as! MessageCell
        //control if the row is selected, (if it's -> diselected)
        if selected == true {
            
            tableView.deselectRow(at: indexPath, animated: true)
            cellSelected.deselectedCell()
            shareButton.backgroundColor = UIColor(displayP3Red: 234/255, green: 244/255, blue: 254/255, alpha: 1)
            selectedContact = false
            
            tableView.reloadData()
        }
        else {
            
            cellSelected.selectedCell()
            shareButton.backgroundColor = UIColor(displayP3Red: 4/255, green: 51/255, blue: 255/255, alpha: 1)
            selectedContact = true
            
            tableView.reloadData()
        }
    }
}

//****************************************************************************
extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}

extension UIButton {
    
    private func image(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(image(withColor: color), for: state)
    }
}


