//
//  CarsCatalog.swift
//  CarsCatalog
//
//  Created by Илья Ершов on 08/10/2019.
//  Copyright © 2019 Ilia Ershov. All rights reserved.
//

import Foundation

class CarsCatalog: Codable {
    // SINGLETONE
    static var instance = CarsCatalog()
 
    // SAVING PATH
    let archiveURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!.appendingPathComponent("carsCatalog1").appendingPathExtension("json")
    
    var catalog: [Car] = []
    
    // MARK: - INITIALIZER
    init() {
        // Default cars
        let car1 = Car.init(releaseYear: Date(), producer: "Kia", model: "Rio", bodyType: .Sedan, color: .Red, amount: 1)
        let car2 = Car.init(releaseYear: Date(), producer: "BMW", model: "X5", bodyType: .Cabriolet, color: .Blue
            , amount: 1)
        let car3 = Car.init(releaseYear: Date(), producer: "Merceides", model: "Benz", bodyType: .Hatchback, color: .Black, amount: 1)
        catalog.append(car1)
        catalog.append(car2)
        catalog.append(car3)
    }
    
    // MARK: - METHODS OF CLASS
    
    class func setColor(color: Car.Color, at index: Int) {
        CarsCatalog.instance.catalog[index].color = color
        CarsCatalog.saveData()
    }
    
    class func setAmount(amount: UInt, at index: Int) {
        CarsCatalog.instance.catalog[index].amount = amount
        CarsCatalog.saveData()
    }
    
    class func saveData() {
        let encodedData = try? JSONEncoder().encode(CarsCatalog.instance)
        try? encodedData?.write(to: CarsCatalog.instance.archiveURL)
    }
    
    class func loadData() {
        let jsonDecoder = JSONDecoder()
        if let retrievedData = try? Data(contentsOf: CarsCatalog.instance.archiveURL),
        let decodedData = try? jsonDecoder.decode(CarsCatalog.self, from: retrievedData) {
            CarsCatalog.instance = decodedData
        }
    }
    
    // MARK: - METHODS OF OBJECT
    
    func addCar (car: Car) {
        // Case when we try to add already existing car
        for el in catalog {
            if el.producer == car.producer && el.model == car.model && el.bodyType == car.bodyType {
                el.amount += car.amount
                return
            }
        }
        // Ordinary case
        catalog.append(car)

        CarsCatalog.saveData()
    }
    
    func getCar(by id: UUID) -> Car? {
        let car = catalog.filter{$0.id == id}
        if !car.isEmpty {
            return car[0]
        }
        return nil
    }
    
    func removeCar (by id: UUID) {
        var index = 0
        for car in catalog {
            if car.id == id {
                break
            } else {
                index += 1
            }
        }
        catalog.remove(at: index)
        
        CarsCatalog.saveData()
    }
    
    func removeCar (at index: Int) {
        catalog.remove(at: index)
    }
    
    func moveItem (from: Int, to: Int) {
        let itemToMove = catalog[from]
        removeCar(at: from)
        catalog.insert(itemToMove, at: to)
    }
}
