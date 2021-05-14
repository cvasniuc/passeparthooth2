//
//  TurnOnProtocoll.swift
//  passepartooth
//
//  Created by Anna Cvasniuc on 09/02/21.
//

import Foundation
import CoreBluetooth

protocol TurnOnProtocoll {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager)
}
