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
    var milesApart: [Double] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bikeStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") as! UITableViewCell
        let bikeStation = bikeStations[indexPath.row]
        let miles = milesApart[indexPath.row]
        cell.textLabel!.text = bikeStation.name
        cell.detailTextLabel?.text = String.init(format: "Bikes Available: \(bikeStation.availableBikes)\n Miles Away: %.2f", miles)
        return cell
    }
    
//    self.selectedAnnotation.subtitle = String.init(format: "\(self.selectedAnnotation.subtitle!) \n%.2f miles away", self.milesAway!)
}
