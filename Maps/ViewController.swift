//
//  ViewController.swift
//  Maps
//
//  Created by NanYar on 21.11.14.
//  Copyright (c) 2014 NanYar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate //, MKMapViewDelegate
{
    // @IBOutlet Properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nearestAddressLabel: UILabel!
    
    // Properties
    var locationManager: CLLocationManager!
    var nearestAddress: String = ""
    
    
    // Default Functions
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Core Location (setting up locationManager)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // Show activePlace
        if activePlace == -1 // "+" was selected
        {
            // Core Location (starting locationManager)
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        else // a place was selected
        {
            let lat: Double = NSString(string: places[activePlace]["lat"]!).doubleValue
            let lon: Double = NSString(string: places[activePlace]["lon"]!).doubleValue
            let latitude: CLLocationDegrees = lat
            let longitude: CLLocationDegrees = lon
            let latitudeDelta: CLLocationDegrees = 0.01
            let longitudeDelta: CLLocationDegrees = 0.01
            let span: MKCoordinateSpan = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
            let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            self.mapView.setRegion(region, animated: true)
            
            var annotation: MKPointAnnotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = places[activePlace]["name"]
            self.mapView.addAnnotation(annotation)
        }
        println("activePlace VC: \(activePlace)")
        
        
        // Creating a longPressRecognizer
        let longPressGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "action:")
        longPressGestureRecognizer.minimumPressDuration = 1.0
        self.mapView.addGestureRecognizer(longPressGestureRecognizer)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    // @IBActions
    @IBAction func findMeBarButtonItemPressed(sender: UIBarButtonItem)
    {
        // TODO: Creating a default location (due to LM start up waiting time)
        
        // Core Location (starting locationManager)
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    
    // Helper Functions
    
    // UILongPressGestureRecognizer
    func action(gestureRecognizer: UIGestureRecognizer)
    {
        if gestureRecognizer.state == UIGestureRecognizerState.Began // = um Doppeleintraege zu vermeiden!
        {
            // Creating an annotation at the touched position
            let touchPoint: CGPoint = gestureRecognizer.locationInView(mapView)
            let newCoordinate: CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            
            let touchPointLocation: CLLocation = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(touchPointLocation, completionHandler:
                { (placemarks, error) -> Void in
                    if error == nil
                    {
                        let myPlacemark: CLPlacemark = CLPlacemark(placemark: placemarks[0] as CLPlacemark)
                        
                        // nil - Werte ausblenden
                        var thoroughfare: String
                        var subThoroughfare: String
                        
                        if myPlacemark.thoroughfare != nil
                        {
                            thoroughfare = myPlacemark.thoroughfare
                        }
                        else
                        {
                            thoroughfare = ""
                        }
                        
                        if myPlacemark.subThoroughfare != nil
                        {
                            subThoroughfare = myPlacemark.subThoroughfare
                        }
                        else
                        {
                            subThoroughfare = ""
                        }
                        
                        var title = "\(thoroughfare) \(subThoroughfare)"
                        if title == " "
                        {
                            // TODO
                            let date: NSDate = NSDate()
                            title = "Added \(date)"
                        }
                        
                        let newAnnotation: MKPointAnnotation = MKPointAnnotation()
                        newAnnotation.coordinate = newCoordinate
                        newAnnotation.title = title
                        self.mapView.addAnnotation(newAnnotation)
                        
                        places.append(["name" : title, "lat" : "\(newCoordinate.latitude)", "lon" : "\(newCoordinate.longitude)"])
                    }
                    else
                    {
                        // TODO
                        println("Error: \(error)")
                    }
            } )
        }
    }
    
    
//    // Example: For an own NavigationBar
//    override func viewWillDisappear(animated: Bool)
//    {
//        self.navigationController?.navigationBarHidden = true
//    }
//
//    oder:
//
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
//    {
//        if segue.identifier == "back"
//        {
//            self.navigationController?.navigationBarHidden = false
//        }
//    }
    
    
    // CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        // Defining actual coordinates
        let userLocation: CLLocation = locations[0] as CLLocation
        let latitude: CLLocationDegrees = userLocation.coordinate.latitude
        let longitude: CLLocationDegrees = userLocation.coordinate.longitude
        
        // Adjusting zoom level
        let latitudeDelta: CLLocationDegrees = 0.005
        let longitudeDelta: CLLocationDegrees = 0.005
        
        // Creating a range
        let span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
        
        // Creating a location
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        // Creation a region
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        // Setting up the mapView
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
        
        // Creating an annotation
        let newAnnotation: MKPointAnnotation = MKPointAnnotation()
        newAnnotation.coordinate = location
        self.mapView.addAnnotation(newAnnotation)
        
        // Creating a geocoder
        self.nearestAddressLabel.hidden = false
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler:
        { (placemarks, error) -> Void in
            if error == nil
            {
                let myPlacemark: CLPlacemark = CLPlacemark(placemark: placemarks[0] as CLPlacemark)
                
                // nil - Werte ausblenden
                var thoroughfare: String
                var subThoroughfare: String
                
                if myPlacemark.thoroughfare != nil
                {
                    thoroughfare = myPlacemark.thoroughfare
                }
                else
                {
                    thoroughfare = ""
                }

                if myPlacemark.subThoroughfare != nil
                {
                    subThoroughfare = myPlacemark.subThoroughfare
                }
                else
                {
                    subThoroughfare = ""
                }
                
                self.nearestAddressLabel.text =
                    "\"\(myPlacemark.name)\"\n\n" +
                    "\(thoroughfare) \(subThoroughfare)\n" +
                    "\(myPlacemark.ISOcountryCode)-\(myPlacemark.postalCode) \(myPlacemark.locality)\n" +
                    "\(myPlacemark.administrativeArea)\n" +
                    "\(myPlacemark.country)"
            }
            else
            {
                self.nearestAddressLabel.text = "Error: \(error)"
            }
        } )
        
        
        //println("Länge: \(userLocation.coordinate.longitude) / Breite: \(userLocation.coordinate.latitude)")
    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!)
    {
        println(error) // TODO: UIAlert
    }

}



















