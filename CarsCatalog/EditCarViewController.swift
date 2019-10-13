//
//  EditCarViewController.swift
//  CarsCatalog
//
//  Created by Илья Ершов on 10/10/2019.
//  Copyright © 2019 Ilia Ershov. All rights reserved.
//

import UIKit

class EditCarViewController: UIViewController {

    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyTypeLabel: UILabel!
    
    @IBOutlet weak var bodyTypeImage: UIImageView!
    
    @IBOutlet weak var editButton: UIButton!
    
    var tableViewController: TableViewController?
    var index: Int?
    
    override func viewDidLoad() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        if let index = tableViewController?.tableView.indexPathForSelectedRow?.row {
            self.index = index
        }
        // Filling car's properties fields
        producerLabel?.text = CarsCatalog.instance.catalog[self.index!].producer
        modelLabel?.text = CarsCatalog.instance.catalog[self.index!].model
        amountLabel?.text = String( CarsCatalog.instance.catalog[self.index!].amount)
        colorLabel?.text = CarsCatalog.instance.catalog[self.index!].color.rawValue
        
        let date = CarsCatalog.instance.catalog[self.index!].releaseYear
        dateLabel?.text = dateFormatter.string(from: date)
        
        bodyTypeLabel?.text = CarsCatalog.instance.catalog[self.index!].bodyType.rawValue
        let bodyType = CarsCatalog.instance.catalog[self.index!].bodyType
        
        switch bodyType.rawValue {
            case "Sedan":
                bodyTypeImage.image = UIImage(named: "sedan.png")!
            case "Cabriolet":
                bodyTypeImage.image = UIImage(named: "cabriolet.png")!
            default:
                bodyTypeImage.image = UIImage(named: "hatchback.png")!
        }
        
        editButton.layer.cornerRadius = 10
        editButton.clipsToBounds = true
        
        super.viewDidLoad()
    }
    
    @IBAction func pushEditButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Edit car's properties", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Amount"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Color"
        }
        
        let createAction = UIAlertAction(title: "Done", style: .default)
        {
            (alert) in
        
            if let _ = Int(alertController.textFields![0].text!) {
                if (Int(alertController.textFields![0].text!)! < 0) {
                    let wrongTypeAlert = UIAlertController(title: "Amount can't be negative", message: nil, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (alert) in }
                    wrongTypeAlert.addAction(OKAction)
                    
                    self.present(wrongTypeAlert, animated: true, completion: nil)
                }
            }
            
            if (alertController.textFields![1].text! != "") && (Car.Color(rawValue: alertController.textFields![1].text!) == nil) {
                let wrongTypeAlert = UIAlertController(title: """
                Please write a color from the list:
                Red
                Green
                Blue
                White
                Black
                """, message: nil, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (alert) in }
                wrongTypeAlert.addAction(OKAction)
                
                self.present(wrongTypeAlert, animated: true, completion: nil)
            }
            
            if let amount = UInt(alertController.textFields![0].text!) {
                CarsCatalog.setAmount(amount: amount, at: self.index!)
            }
            if let color = Car.Color(rawValue: alertController.textFields![1].text!) {
                CarsCatalog.setColor(color: color, at: self.index!)
            }
            
            self.viewDidLoad()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in }
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
