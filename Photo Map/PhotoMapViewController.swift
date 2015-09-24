//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Dave Vo on 9/24/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController {
    var vc = UIImagePickerController()
    
    var editedImage: UIImage!
    var originalImage: UIImage!
    
    var lat: NSNumber?
    var long: NSNumber?
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var cameraButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        
        mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.1, 0.1)), animated: false)
        //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
        
        mapView.delegate = self
        
        cameraButton.layer.backgroundColor = UIColor.whiteColor().CGColor
        cameraButton.layer.cornerRadius = 50
        cameraButton.layer.masksToBounds = true
        
        vc.delegate = self
        vc.allowsEditing = true
//        if UIImagePickerController.isSourceTypeAvailable(sourceType: UIImagePickerControllerSourceType)
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print("view will appear")
        if lat != nil && long != nil {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat!.doubleValue, longitude: long!.doubleValue)
            annotation.title = "Picture!"
            mapView.addAnnotation(annotation)
            print("lat: \(lat)")
            print("long: \(long)")
            mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(lat!.doubleValue, long!.doubleValue), MKCoordinateSpanMake(0.1, 0.1)), animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onCameraButton(sender: UIButton) {
        self.presentViewController(vc, animated: true, completion: nil)

    }
}

extension PhotoMapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
                    originalImage = editingInfo![UIImagePickerControllerOriginalImage] as! UIImage
//        editedImage = editingInfo![UIImagePickerControllerEditedImage] as! UIImage
        
        dismissViewControllerAnimated(true, completion: nil)
        
        
        let nvc = storyboard?.instantiateViewControllerWithIdentifier("locationNVC") as! UINavigationController
        let vc = nvc.viewControllers[0] as! LocationsViewController
        vc.delegate = self
        presentViewController(nvc, animated: true, completion: nil)
        
        
    }
}

extension PhotoMapViewController: LocationsViewControllerDelegate {
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        print("location picked: \(latitude) \(longitude)")
        
        lat = latitude
        long = longitude
        
        

    }
}

extension PhotoMapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
        }
        
        let imageView = annotationView!.leftCalloutAccessoryView as! UIImageView
        imageView.image = UIImage(named: "camera")
        
        return annotationView
    }
}
