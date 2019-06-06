//
//  SelectedViewController.swift
//  Divvy
//
//  Created by Carly Cameron on 6/4/19.
//  Copyright © 2019 Justine Linscott. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SelectedViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var selected : BikeStation?
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(selected?.name)
        locationManager.delegate = self
        createAnnotation(bikeStation: selected!)
    }
    
    func createAnnotation(bikeStation: BikeStation) {
        let annotation = MKPointAnnotation()
        let location = CLLocationCoordinate2D(latitude: bikeStation.lat, longitude: bikeStation.long)
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
