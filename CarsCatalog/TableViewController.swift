//
//  ViewController.swift
//  CarsCatalog
//
//  Created by Илья Ершов on 07/10/2019.
//  Copyright © 2019 Ilia Ershov. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    @IBAction func pushEditButton(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func pushInfoButton(_ sender: Any) {
        let alertController = UIAlertController(title: "What is this app?", message: "Here you can see the cars from the catalog and check their characteristics. \nPush on the row to see the details.", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (alert) in }
        alertController.addAction(OKAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func unwindToTableViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.init(cgColor: #colorLiteral(red: 1, green: 0.4354740114, blue: 0.3826320114, alpha: 0.9288580908))
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CarsCatalog.instance.catalog.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = CarsCatalog.instance.catalog[indexPath.row].producer
        cell.detailTextLabel?.text = CarsCatalog.instance.catalog[indexPath.row].model +
            ", amount: " + String(CarsCatalog.instance.catalog[indexPath.row].amount)
        
        // Setting an image
        let hatchback: UIImage = UIImage(named: "hatchback.png")!
        let sedan: UIImage = UIImage(named: "sedan.png")!
        let cabriolet: UIImage = UIImage(named: "cabriolet.png")!
        
        let myImages:[Car.BodyType : UIKit.UIImage] = [Car.BodyType.Hatchback : hatchback,
                                                Car.BodyType.Cabriolet : cabriolet,
                                                Car.BodyType.Sedan : sedan]
           
        let bodyType = CarsCatalog.instance.catalog[indexPath.row].bodyType
        var image = myImages.filter {$0.key == bodyType}
        
        cell.imageView?.image = image.popFirst()?.value

        // Set transparency if editing
        if tableView.isEditing {
            cell.textLabel?.alpha = 0.4
            cell.detailTextLabel?.alpha = 0.4
            cell.imageView?.alpha = 0.4
        } else {
            cell.textLabel?.alpha = 1
            cell.detailTextLabel?.alpha = 1
            cell.imageView?.alpha = 1
        }
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let carId = CarsCatalog.instance.catalog[indexPath.row].id
            CarsCatalog.instance.removeCar(by: carId)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        CarsCatalog.instance.moveItem(from: fromIndexPath.row, to: to.row)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is EditCarViewController {
            if (segue.identifier == "toProps") {
                let editController = segue.destination as! EditCarViewController
                
                editController.tableViewController = self
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .none
        } else {
            return .delete
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

