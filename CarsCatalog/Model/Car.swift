//
//  Car.swift
//  CarsCatalog
//
//  Created by Илья Ершов on 07/10/2019.
//  Copyright © 2019 Ilia Ershov. All rights reserved.
//

import Foundation


class Car: Codable {
    
    // MARK: - ENUMERATIONS
    enum BodyType: String, Codable {
        case Hatchback = "Hatchback"
        case Sedan = "Sedan"
        case Cabriolet = "Cabriolet"
    }
    
    enum Color: String, Codable {
        case Red = "Red"
        case Green = "Green"
        case Blue = "Blue"
        case Black = "Black"
        case White = "White"
    }
    
    // MARK: - CONSTANTS
    let releaseYear: Date
    let producer: String
    let model: String
    let id = UUID()
    
    var bodyType: BodyType
    var color: Color = .Black
    var amount: UInt = 1
    
    //TODO: - images
    
    // MARK: - INITIALIZER
    init(releaseYear: Date, producer: String, model: String, bodyType: BodyType, color: Color, amount: UInt) {
        self.releaseYear = releaseYear
        self.producer = producer
        self.model = model
        self.bodyType = bodyType
        self.color = color
        self.amount = amount
    }
    
    
}

