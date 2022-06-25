//
//  ViewController.swift
//  AR-SchoolTourGuide
//
//  Created by Carlos Loeza on 6/22/22.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        <#code#>
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        <#code#>
    }
    
    // create a picker roller view so user can select a starting point from list
    @IBOutlet weak var startingPointPickerView: UIButton!
    // user can use their current location
    @IBOutlet weak var userLocation: UIButton!
    // list of starting and destination points
    var locations = [
        "J. Paul Leonard Library": String(),
        "Cesar Chavez Student Center": String(),
        "Creative Arts": String(),
        "Humanities": String(),
        "Business": String()
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    


}

