//
//  FirstViewController.swift
//  Locus
//
//  Created by Elizabeth Kelly on 10/11/16.
//  Copyright © 2016 Elizabeth Kelly. All rights reserved.
//

import UIKit
import MapKit

class FirstViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        searchBar.delegate = self
        
        
        let nyc = MKCoordinateRegionMake(CLLocationCoordinate2DMake(40.7128, -74.0059), MKCoordinateSpanMake(0.1766154, 0.153035))
        
        mapView.setRegion(nyc, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
