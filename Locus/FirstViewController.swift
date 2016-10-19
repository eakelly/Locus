//
//  FirstViewController.swift
//  Locus
//
//  Created by Elizabeth Kelly on 10/11/16.
//  Copyright © 2016 Elizabeth Kelly. All rights reserved.
//

import UIKit
import MapKit

//declares custom protocol
protocol HandleMapSearch {
    func dropPinZoomIn(placeMark:MKPlacemark)
}

class FirstViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()

    var resultSearchController:UISearchController? = nil
    
    var selectedPin:MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for location"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        
        locationSearchTable.handleMapSearchDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1766154, longitudeDelta: 0.153035))
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
    }//end func
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors: " + error.localizedDescription)
    }//end func

    func writeEntry() {
        //if let selectedPin = selectedPin {
            //let mapItem = MKMapItem(placemark: selectedPin)
            //let entry = self.storyboard!.instantiateViewController(withIdentifier: "entryPost")

            let entry = storyboard!.instantiateViewController(withIdentifier: "entryPost")
            entry.title = "Create an Entry"

            self.show(entry, sender: entry)
        //}
    }//end func
}//end class

extension FirstViewController: HandleMapSearch {
    func dropPinZoomIn(placeMark: MKPlacemark) {
        //cache the pin
        selectedPin = placeMark
        //clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placeMark.coordinate
        annotation.title = placeMark.name
        if let city = placeMark.locality, //_ was city
            let state = placeMark.administrativeArea { //_ was state
            annotation.subtitle = city + ", " + state
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.1766154, 0.153035)
        let region = MKCoordinateRegionMake(placeMark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}//end extension

extension FirstViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        if annotation is MKUserLocation {
            pinView?.pinTintColor = UIColor.blue
            //return nil so map view draws blue dot for user location
            //return nil
        }
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "pencil"), for: .normal)
        button.addTarget(self, action: #selector(FirstViewController.writeEntry), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}//end extension
