//
//  ViewController.swift
//  Divvy
//
//  Created by Justine Linscott on 6/4/19.
//  Copyright © 2019 Justine Linscott. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var currentLocation = CLLocationManager()

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentLocation.requestWhenInUseAuthorization()
        currentLocation.startUpdatingLocation()
        mapView.delegate = self
        currentLocation.delegate = self
        query()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let center = location?.coordinate
        let region = MKCoordinateRegion(center: center!, span: span)
        mapView.setRegion(region, animated: true)
    }

    func parse(json: JSON) {
        for result in json["stationBeanList"].arrayValue {
            let name = result["stationName"].stringValue
            let availableBikes = result["availableBikes"].intValue
            let lat = result["latitude"].doubleValue
            let long = result["longitude"].doubleValue
            let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = name
            annotation.subtitle = "Number of Bikes: \(availableBikes)"
            mapView.addAnnotation(annotation)
        }
    }
    
    func loadError() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: "There was a problem loading Divvy bike info", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(action)
            self.present(alertController, animated: true)
        }
    }
    
    func query() {
        let query = "https://feeds.divvybikes.com/stations/stations.json"
        DispatchQueue.global(qos: .userInitiated).async {
            [unowned self] in
            if let url = URL(string: query){
                if let data = try? Data(contentsOf: url){
                    let json = try! JSON(data: data)
                    self.parse(json: json)
                    return
                }
                self.loadError()
            }
            
        }
    }
    
}

