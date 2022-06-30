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
    var size = 32
    // path from start to finish
    var path: [Int]?
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
    
    
    var updatedGraph: [[Int]] = [ //0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
                                   [0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], //0
                                   [1, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], //1
                                   [0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], //2
                                   [0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], //3
                                   [0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], //4
                                   [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], //5
                                   [0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], //6
                                   [0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], //7
                                   [0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], //8
                                   [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], //9
                                   [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], //10
                                   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], //11
                                   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], //12
                                   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], //13
                                   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], //14
                                   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], //15
                                   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], //16
                                   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], //17
                                   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], //18
                                   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], //19
                                   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0], //20
                                   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], //21
                                   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0], //22
                                   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0], //23
                                   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0], //24
                                   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0], //25
                                   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0], //26
                                   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0], //27
                                   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0], //28
                                   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0], //29
                                   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1], //30
                                   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0], //31
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
    // ** LOOK INTO COMBINING locations[] and locationVertex[]
    // locationVertex is a dictionary which helps translate location name to vertex number.
    // Used for dijkstra algorithm to find shortest path.
    var locationVertex : [String: Int] = [
                            "Admissions": 0,
                            "Burk Hall": 31,
                            "Business": 1,
                            "Creative Arts": 19,
                            "Cesar Chavez Student Center": 13,
                            "Fine Arts": 21,
                            "Humanities": 0, // change this
                            "J. Paul Leonard Library": 5
                         ]
    
    // create a picker roller view so user can select a starting point from list
    // picker roller
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
        let vc = setupVC()
        // create picker view by calling createPickerView()
        let pickerView = setupPickerView(vc: vc)
        
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
        let vc = setupVC()
        
        let pickerView = setupPickerView(vc: vc)
        
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
    
    // Setup UIViewController for startingPointPickerRoller() and destinationPickerRoll.
    // vc will hold our picker roller
    // Helps reduce code
    func setupVC ()->UIViewController {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        return vc
    }
    
    // Setup our UIPickerView for startingPointPickerRoller() and destinationPickerRoll
    // Create picker view
    func setupPickerView(vc: UIViewController)->UIPickerView{
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        return pickerView
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
            
            
            let start = Date()
            path = dijkstra(graph: updatedGraph, src: startVertex, dest: destinationVertex, size: size)
            let end = Date()
            let consumedTime = end.timeIntervalSince(start)
            print("----------")
            print(consumedTime) // time to compute dijkstra() without saved data: 0.0015159845352172852
            print("----------")
            // ** temporarily sends dummy data when we click Find Class button **
            // Dictionary data that I want to send to the second view.
            let sender = path!
            // To go to the second view.
            self.performSegue(withIdentifier: "findClass", sender: sender)
        } else {
            print("missing value")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let mapVC = segue.destination as? MapViewController else { return }
        mapVC.vertexPath = path
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

