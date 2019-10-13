//
//  ViewController.swift
//  CarsCatalog
//
//  Created by Илья Ершов on 08/10/2019.
//  Copyright © 2019 Ilia Ershov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let bodyDataSource: [String] = [Car.BodyType.Cabriolet.rawValue,
                                        Car.BodyType.Hatchback.rawValue,
                                        Car.BodyType.Sedan.rawValue]
    
    private let colorDataSource: [String] = [Car.Color.Red.rawValue,
                                             Car.Color.Green.rawValue,
                                             Car.Color.Blue.rawValue,
                                             Car.Color.Black.rawValue,
                                             Car.Color.White.rawValue]
    
    private var bodyType = Car.BodyType.Cabriolet
    private var color = Car.Color.Red
    
    @IBOutlet weak var producerField: UITextField!
    @IBOutlet weak var modelField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    
    @IBOutlet weak var colorPicker: UIPickerView!
    @IBOutlet weak var bodyTypePicker: UIPickerView!
    
    @IBOutlet weak var dateField: UITextField!
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(ViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        dateField.inputView = datePicker
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        self.bodyTypePicker.delegate = self
        bodyTypePicker.dataSource = self
        
        self.colorPicker.delegate = self
        colorPicker.dataSource = self
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.view.endEditing(true)
        }
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateField.text = dateFormatter.string(from: datePicker.date)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.view.endEditing(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func pushAddButton(_ sender: Any) {
        if producerField.text != "" && modelField.text != "" && dateField.text != "" {
            
            //New Car's Fields
            let releaseYear: Date? = datePicker?.date
            let producer: String = producerField.text!
            let model: String = modelField.text!
            let amount: String = amountField.text!
            let bodyType: Car.BodyType = self.bodyType
            let color: Car.Color = self.color
            
            let car = Car.init(releaseYear: releaseYear!, producer: producer, model: model, bodyType: bodyType, color: color, amount: UInt(amount)!)
            
            CarsCatalog.instance.addCar(car: car)
            
            self.performSegue(withIdentifier: "backToTheCatalog", sender: self)
        } else {
            let alertController = UIAlertController(title: nil, message: "You haven't filled all the required filds", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (alert) in }
            alertController.addAction(OKAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
}

extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == bodyTypePicker {
            return bodyDataSource.count
        } else {
            return colorDataSource.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == bodyTypePicker {
            bodyType = Car.BodyType(rawValue: bodyDataSource[row])!
        }
        if pickerView == colorPicker {
            color = Car.Color(rawValue: colorDataSource[row])!
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == bodyTypePicker {
            return bodyDataSource[row]
        } else {
            return colorDataSource[row]
        }
    }
}
