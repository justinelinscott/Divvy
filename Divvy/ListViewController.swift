//
//  ListViewController.swift
//  Divvy
//
//  Created by Justine Linscott on 6/4/19.
//  Copyright © 2019 Justine Linscott. All rights reserved.
//

import UIKit


class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var bikeStations: [BikeStation] = []
    var selected : BikeStation!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.reloadData()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bikeStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sorted = bikeStations.sorted(by: { $0.miles! < $1.miles! })
//        images.sorted({ $0.fileID > $1.fileID })
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") as! UITableViewCell
        let bikeStation = sorted[indexPath.row]
        cell.textLabel!.text = bikeStation.name
        cell.detailTextLabel?.text = String.init(format: "Bikes Available: \(bikeStation.availableBikes)\n Miles Away: %.2f", bikeStation.miles!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sorted = bikeStations.sorted(by: { $0.miles! < $1.miles! })
        
        selected = sorted[indexPath.row]
        performSegue(withIdentifier: "selectedSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let svc = segue.destination as! SelectedViewController
        print(selected)
        svc.selected = selected
    }
    

}
