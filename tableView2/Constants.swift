//
//  Constants.swift
//  passepartooth
//
//  Created by Anna Cvasniuc on 02/03/21.
//
import CoreBluetooth
import Foundation

struct K {
    //le UUID un servizio per iniviare le mie caratt.
    static var myUUID2 = CBUUID(string: "4423022c-f04b-4d62-bcb3-104a16d92c1e")
   // static var myUUID3 = CBUUID(string: "5523022c-f04b-4d62-bcb3-104a16d92c1e")
    
    //le UUID per le mie 3 caratteristiche: nome, phone, email
    static let myCharNomeCardUUID: CBUUID = CBUUID(string: "A8B1F71C-1B8B-4546-9EB7-CBFB1471C31B")
    static let myCharNomeUUID: CBUUID = CBUUID(string: "A9B2F71C-1B8B-4546-9EB7-CBFB1471C31B")
    static let myCharCognomeUUID: CBUUID = CBUUID(string: "A7B3F71C-1B8B-4546-9EB7-CBFB1471C31B")

    //**********************************************************************************
    //x scrivere, per ricevere una card (un servizio e le sue caratteristiche
    static var myUUID = CBUUID(string: "5323022c-f04b-4d62-bcb3-104a16d92c1e")
    //per le caractt da scrivere, le card
    static let charDefault: CBUUID = CBUUID(string: "1411022c-f04b-4d62-bcb3-104a16d92c4f")
    
}
