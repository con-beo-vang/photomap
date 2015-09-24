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
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var cameraButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.1, 0.1)), animated: false)
        //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
        
        
        cameraButton.layer.backgroundColor = UIColor.whiteColor().CGColor
        cameraButton.layer.cornerRadius = 50
        cameraButton.layer.masksToBounds = true
        
        vc.delegate = self
        vc.allowsEditing = true
//        if UIImagePickerController.isSourceTypeAvailable(sourceType: UIImagePickerControllerSourceType)
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
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
        
        
        let nvc = storyboard?.instantiateViewControllerWithIdentifier("locationNVC")
        presentViewController(nvc!, animated: true, completion: nil)
        
        
    }
    
    
}
