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
    var newImage: UIImage!
  
    var lat: NSNumber?
    var long: NSNumber?
  
  var images = [String: UIImage]()
  
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
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print("view will appear")
        if let lat = lat, long = long {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat.doubleValue, longitude: long.doubleValue)
//            annotation.title = "Picture!"
            annotation.title = "\(lat)"
            mapView.addAnnotation(annotation)
            print("lat: \(lat)")
            print("long: \(long)")
            mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(lat.doubleValue, long.doubleValue), MKCoordinateSpanMake(0.1, 0.1)), animated: false)
        }
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
      
        let key = "\(lat), \(long)"
        images[key] = originalImage!
    }
}

extension PhotoMapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
            annotationView?.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
        }
      let key = "\(lat), \(long)"
      let image = images[key]
      annotationView!.image = resizeImage(image!)
      let imageView = annotationView!.leftCalloutAccessoryView as! UIImageView
      imageView.image = image
      
      
        return annotationView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("photo detail")
        if let imageView = view.leftCalloutAccessoryView as? UIImageView {
          newImage = imageView.image
          performSegueWithIdentifier("showPhoto", sender: self)
        }
      
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController
        if vc is PhotoViewController {
            let photoVC = vc as? PhotoViewController
            photoVC?.selectedPhoto = newImage
            print("set image")
        }
    }
    
    func resizeImage(image: UIImage) -> UIImage {
        let resizeRenderImageView = UIImageView(frame: CGRectMake(0, 0, 45, 45))
        resizeRenderImageView.layer.borderColor = UIColor.whiteColor().CGColor
        resizeRenderImageView.layer.borderWidth = 3.0
        resizeRenderImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeRenderImageView.image = image
        
        UIGraphicsBeginImageContext(resizeRenderImageView.frame.size)
        resizeRenderImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return thumbnail
    }
   
}
