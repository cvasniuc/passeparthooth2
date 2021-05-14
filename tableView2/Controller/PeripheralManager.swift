//
//  Ble.swift
//  passepartooth
//
//  Created by Anna Cvasniuc on 09/02/21.
//
import UIKit
import Contacts
import ContactsUI
import RealmSwift
import Foundation
import CoreBluetooth

class PeripheralManager: UIViewController, CBPeripheralManagerDelegate, CBPeripheralDelegate {
    
    
    let real = try! Realm()
    
    var defCard: Results<Category>{
        get{
            return real.objects(Category.self)
        }
    }
    //vado a vedere tutti i contatti nel mio database
    var allContacts: Results<ContactList>{
        get{
            return real.objects(ContactList.self)
        }
    }
    
    let preferredLanguage = NSLocale.preferredLanguages[0]
    var connectedCentral: CBCentral?
    var sendDataIndex: Int = 0
    static var sendingEOM = false //EOM end-of message
    var myService: CBMutableService!
    private var peripheralManager : CBPeripheralManager!
    var start: Bool = false
    var idPhoto : Int = 0
    var imageData : NSData!
    var content : Data!
    var provaChar: CBMutableCharacteristic!
    
    let contact = CNMutableContact()
    let contact2 = CNMutableContact()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
        
        //the notification when the app is "turn back" (turn ON)
        NotificationCenter.default.addObserver(self, selector: #selector(appTurnBack), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        //the notification when the app is in the background
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
    }
    
    //*******************************************************************
    @objc func appMovedToBackground() {
        peripheralManager.stopAdvertising()
        print("App moved to background!")
        
        // notificationCenter.removeObserver(self)
    }
    //*******************************************************************
    @objc func appTurnBack(){
        print("app turn back --- is ON")
        startAdvertising()
    }
    //*******************************************************************
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
        print("category.defaultCard ")
        
    }
    //*******************************************************************
    override func viewDidAppear(_ animated: Bool) {
        
        if start == true {
            startAdvertising()
            print("Start == true")
        } else {
            print("Start == false")
        }
    }
    //*******************************************************************
    override func viewDidDisappear(_ animated: Bool) {
        peripheralManager.stopAdvertising()
        
    }
    //****************************************************************************
    //MARK: - < Build our service.
    func addServices() {
        
        let myService = CBMutableService(type: K.myUUID, primary: true)
        //  Add characteristics to the service

        let writeCharacteristics = CBMutableCharacteristic(type: K.charDefault, properties: [.read,.write,.notify], value: nil, permissions: [ .readable,.writeable])
        
        
        myService.characteristics = [writeCharacteristics]
        peripheralManager.add(myService)
        
        
        //MARK: - < Default Characteristics
        //vado a prendere le mie info dal db per mia default Card
        for defaultCard in defCard {
            if defaultCard.defaultCard == true {
                print("default card ", defaultCard.titleCard)
                
                let titleCard = defaultCard.titleCard
                let dataCard = titleCard.data(using: .utf8)
                
                let nome = defaultCard.nome
                let dataNome = nome.data(using: .utf8)
                
                let cognome = defaultCard.cognome
                let dataCognome = cognome.data(using: .utf8)
                
                let myService2 = CBMutableService(type: K.myUUID2, primary: true)
                
                let charTitle = CBMutableCharacteristic(type: K.myCharNomeCardUUID, properties: [.read], value: dataCard, permissions: [.readable])
                
                
                let charNome = CBMutableCharacteristic(type: K.myCharNomeUUID, properties: [.read], value: dataNome, permissions: [.readable])
                
                let charCognome = CBMutableCharacteristic(type: K.myCharCognomeUUID, properties: [.read], value: dataCognome, permissions: [.readable])
                
                
                print("nome.. ",defaultCard.nome, ".. ", defaultCard.cognome)
                
                myService2.characteristics = [charTitle,charNome,charCognome]
                peripheralManager.add(myService2)
                
                print("myService2",myService2.description)
            }
        }
        
        startAdvertising()
    }
    
    //****************************************************************************
    func startAdvertising() {
        
        peripheralManager.startAdvertising(
            [CBAdvertisementDataLocalNameKey : "Passepartooth", CBAdvertisementDataServiceUUIDsKey : [K.myUUID, K.myUUID2]])
        
        print("Started Advertising")
        
        start = true
    }
    
    
    //****************************************************************************
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .unknown:
            print("Bluetooth Device is UNKNOWN")
        case .unsupported:
            print("Bluetooth Device is UNSUPPORTED")
        case .unauthorized:
            print("Bluetooth Device is UNAUTHORIZED")
        case .resetting:
            print("Bluetooth Device is RESETTING")
        case .poweredOff:
            print("Bluetooth Device is POWERED OFF")
        case .poweredOn:
            print("Bluetooth Device is POWERED ON")
            addServices()
            
        @unknown default:
            fatalError()
        }
    }
    
    //****************************************************************************
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        
        let newContact = ContactList()
        peripheralManager.stopAdvertising()
        
        for request in requests {
            
            if let value = request.value {
                
                
                let json = try? JSONDecoder().decode(ContactCodable.self, from: value)
                
                
                try! real.write {
                    
                    newContact.titleCard = json?.titleCard ?? ""
                    newContact.nome = json?.nome ?? ""
                    newContact.cognome = json?.cognome ?? ""
                    newContact.cellulare = json!.cellulare
                    newContact.telefono = json?.telefono ?? ""
                    newContact.email = json?.email ?? ""
                    newContact.web = json?.web ?? ""
                    newContact.linkdin = json?.linkdin ?? ""
                    newContact.facebook = json?.facebook ?? ""
                    newContact.instagram = json?.instagram ?? ""
                    newContact.note = json?.note ?? ""
                    
                    
                    real.add(newContact)
                    peripheralManager.stopAdvertising()
                    print("Contatto AGGiunto")
                    print("new contact", newContact.description)
                    
                    if preferredLanguage.starts(with: "it") {
                        
                    let alert = UIAlertController(title: "", message: "Contatto Aggiunto Correttamente nelle tue Carte. Vuoi aggiungerlo alla Rubrica telefonica?", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Aggiungi", style: UIAlertAction.Style.default, handler: { [self](action ) in
                        
                        
                        saveToContacts(newContact: newContact)
                        
                    }
                    ))
                    alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "", message: "Contact Added Correctly in your Cards. You want to add it to the Phone Book?", preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: { [self](action ) in
                            
                            
                                                        saveToContacts(newContact: newContact)
                            
                        }
                        ))
                        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        }
                    }
                
                
                    }
                
                self.peripheralManager.respond(to: request, withResult: .success)
                
        }
            print("********** didReceiveWrite SUCCESS*****************")
            
        
    }
    func saveToContacts(newContact: ContactList){
        
    
    
            
            
            contact2.givenName =  newContact.nome
            contact2.familyName = newContact.cognome
            contact2.phoneNumbers = [CNLabeledValue(
                                        label: CNLabelPhoneNumberiPhone,
                                        value: CNPhoneNumber(stringValue: newContact.cellulare))]
           
            let store = CNContactStore()
            let saveRequest = CNSaveRequest()
            saveRequest.add(contact2, toContainerWithIdentifier: nil)
            do {
                try store.execute(saveRequest)
            } catch {
                print("Saving contact failed, error: \(error)")
                // Handle the error
            }
            
        }
        

    //****************************************************************************
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if let error = error {
            print("did discover Service fail \(error)")
            return
        }
        guard let services = peripheral.services else { return }
        for service in services {
            print("SPAKA:PERIPHERALSERVICES============>\(service)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    //****************************************************************************
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if let characteristic = service.characteristics{
            for char in characteristic {
                print("Characteristic --- ",char)
            }
        }
    }
    
    //****************************************************************************
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if let error = error {
            print("Did Write Value For characteristic service error \(error.localizedDescription)")
            return
        }
        
        
        print("didWriteValueFor characteristic success")
    }
}




