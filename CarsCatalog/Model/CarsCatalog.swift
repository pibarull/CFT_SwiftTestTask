//
//  CarsCatalog.swift
//  CarsCatalog
//
//  Created by Илья Ершов on 08/10/2019.
//  Copyright © 2019 Ilia Ershov. All rights reserved.
//

import Foundation

class CarsCatalog: Codable {
    // MARK: - SINGLETONE
    static var instance = CarsCatalog()
 
    let archiveURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!.appendingPathComponent("carsCatalog1").appendingPathExtension("json")
    
    
    var catalog: [Car] = []
    
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
    
    func addCar (car: Car) {
        for el in catalog { // Case when we try to add already existing car
            if el.producer == car.producer && el.model == car.model && el.bodyType == car.bodyType {
                el.amount += car.amount
                return
            }
        }
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
    
    class func loadData() { //-> CarsCatalog?{
        
        let jsonDecoder = JSONDecoder()
        if let retrievedData = try? Data(contentsOf: CarsCatalog.instance.archiveURL),
        let decodedData = try? jsonDecoder.decode(CarsCatalog.self, from: retrievedData) {
            CarsCatalog.instance = decodedData
            //return decodedData
        }
//        else{
//            return nil
//        }
        
        
    }
}
