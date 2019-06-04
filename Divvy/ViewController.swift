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
    var milesAway: Double!
    var selectedAnnotation = MKPointAnnotation()
    var bikeStations : [BikeStation] = []
    var milesApart: [Double] = []

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentLocation.requestWhenInUseAuthorization()
        currentLocation.startUpdatingLocation()
        mapView.delegate = self
        currentLocation.delegate = self
        query()
        
    }
    
    @IBAction func segmentedController(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
           return
        case 1:
            performSegue(withIdentifier: "listSegue", sender: nil)
        default:
            return
        }
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
            let bikeStation = BikeStation(name: name, availableBikes: availableBikes, lat: lat, long: long)
            bikeStations.append(bikeStation)
            calculateMiles(location: currentLocation.location!)
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
    
    func calculateMiles(location: CLLocation){
        for bikeStation in bikeStations {
            let coordinate = CLLocation(latitude: bikeStation.lat, longitude: bikeStation.long)
            let distance = coordinate.distance(from: location)
            milesApart.append(distance * 0.000621371)
        }
    }
    
    func getDirections(location: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        let placemark = MKPlacemark(coordinate: location)
        let mapItem = MKMapItem(placemark: placemark)
        request.destination = mapItem
        request.transportType = .automobile
        let directions = MKDirections(request: request)
        
        directions.calculate { (response, error) in
            guard let response = response else {return}
            for route in response.routes {
                self.milesAway = route.distance * 0.000621371
                self.selectedAnnotation.subtitle = String.init(format: "\(self.selectedAnnotation.subtitle!) \n%.2f miles away", self.milesAway!)
        
                print(route.distance)
                self.mapView.addOverlay(route.polyline)
                
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        renderer.alpha = 0.5
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
       
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        selectedAnnotation = view.annotation as! MKPointAnnotation
        getDirections(location: selectedAnnotation.coordinate)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! ListViewController
        dvc.bikeStations = bikeStations
        dvc.milesApart = milesApart
    }
    
}

