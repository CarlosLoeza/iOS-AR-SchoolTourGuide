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
    // 2D array containing the vertex and edges for each node
    // row represents what vertex you are at
    // column represents if you have with that vertex
    // Example: first row means vertex 0 has an edge with vertex 9 and 10
    var graph: [[Int]] = [ //0  1  2  3  4  5  6  7  8  9  10
                           [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1 ], // vertex 0
                           [ 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1 ], // vertex 1
                           [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ], // vertex 2
                           [ 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1 ], // vertex 3
                           [ 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0 ], // vertex 4
                           [ 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0 ], // vertex 5
                           [ 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0 ], // vertex 6
                           [ 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0 ], // vertex 7
                           [ 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0 ], // vertex 8
                           [ 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1 ], // vertex 9
                           [ 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0 ], // vertex 10
                        ]
    
    // list of starting and destination points
    var locations: KeyValuePairs = [
        "Admissions": String(),
        "Burk Hall": String(),
        "Business": String(),
        "Creative Arts": String(),
        "Cesar Chavez Student Center": String(),
        "Fine Arts": String(),
        "Humanities": String(),
        "J. Paul Leonard Library": String()
    ]
    // locationVertex is a dictionary which helps translate location name to vertex number.
    // Used for dijkstra algorithm to find shortest path.
    var locationVertex : [String: Int] = [
                            "Admissions": 2,
                            "Burk Hall": 5,
                            "Business": 1,
                            "Creative Arts": 7,
                            "Cesar Chavez Student Center": 4,
                            "Fine Arts": 6,
                            "Humanities": 3,
                            "J. Paul Leonard Library": 0
                         ]
    
    // create a picker roller view so user can select a starting point from list
    @IBOutlet weak var startingPointPickerView: UIButton!
    @IBOutlet weak var destinationPickerView: UIButton!
    // user can use their current location
    @IBOutlet weak var userLocation: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Picker roller which allows user to select a starting location
    // and update text
    @IBAction func startingPointPickerRoller(_ sender: Any) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        // create picker view by calling createPickerView()
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
    
    // Picker roller which allows user to select a destination location
    // and update text.
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
    
    // findClassButton will get the starting and destination point in order to compute shortest path
    @IBAction func findClassButton(_ sender: Any) {
        // start and destination points in string form
        let start = startingPointPickerView.titleLabel?.text
        let dest = destinationPickerView.titleLabel?.text
        // start and destination vertex
        let startVertex = locationVertex[start!]!
        let destinationVertex = locationVertex[dest!]!
        // make sure we have valid locations
        if (start != "Select Starting Point" && dest != "Select Destination"){
            dijkstra(graph: graph, src: startVertex, dest: destinationVertex, size: size)
            // ** temporarily sends dummy data when we click Find Class button and switch VC **
            //Dictionary data that I want to send to the second view.
            print("hello")
            let sender: [String: Any?] = ["name": "My name", "id": 10]
            // To go to the second view.
            self.performSegue(withIdentifier: "findClass", sender: sender)

        } else {
            print("missing value")
        }
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

