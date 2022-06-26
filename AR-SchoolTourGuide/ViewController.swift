//
//  ViewController.swift
//  AR-SchoolTourGuide
//
//  Created by Carlos Loeza on 6/22/22.
//

import UIKit
import GameplayKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // screen width and height for picker roller
    let screenWidth = UIScreen.main.bounds.width-10
    let screenHeight = UIScreen.main.bounds.height / 5
    // selectedRow
    var selectedRow = 0
    // number of locations
    var size = 11
    // graph
    var graph: [[Int]] = [ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1 ], // 0
                        [ 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1 ], // 1
                        [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ], // 2
                        [ 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1 ], // 3
                        [ 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0 ], // 4
                        [ 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0 ], // 5
                        [ 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0 ], // 6
                        [ 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0 ], // 7
                        [ 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0 ], // 8
                        [ 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1 ], // 9
                        [ 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0 ], // 10

                        ]
    
    
    // create a picker roller view so user can select a starting point from list
    @IBOutlet weak var startingPointPickerView: UIButton!
    @IBOutlet weak var destinationPickerView: UIButton!
    // user can use their current location
    @IBOutlet weak var userLocation: UIButton!
    // list of starting and destination points
    var locations: KeyValuePairs = [
        "Business": String(),
        "Cesar Chavez Student Center": String(),
        "Creative Arts": String(),
        "Humanities": String(),
        "J. Paul Leonard Library": String()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dijkstra(graph: graph, src: 0, size: size)
    }
    


    @IBAction func pickerRoll(_ sender: Any) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "Select Starting Point", message: "", preferredStyle: .actionSheet)
        alert.setValue(vc, forKey: "contentViewController")
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(UIAlertAction) in }))
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: {(UIAlertAction) in
            self.selectedRow = pickerView.selectedRow(inComponent: 0)
            let selected = Array(self.locations)[self.selectedRow]
            let starting = selected.key
            self.startingPointPickerView.setTitle(starting, for: .normal)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func destinationPickerRoll(_ sender: Any) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "Select Destination", message: "", preferredStyle: .actionSheet)
        alert.setValue(vc, forKey: "contentViewController")
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(UIAlertAction) in }))
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: {(UIAlertAction) in
            self.selectedRow = pickerView.selectedRow(inComponent: 0)
            let selected = Array(self.locations)[self.selectedRow]
            let destination = selected.key
            self.destinationPickerView.setTitle(destination, for: .normal)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    

    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        locations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        label.text = Array(locations)[row].key
        label.sizeToFit()
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }


}

