//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate {

    @IBOutlet weak var MapKitView: MKMapView!
    
    let vcI = UIImagePickerController()
    var g = "daveeeee"
    var photo: UIImage?
    var anno: [MKAnnotation] = []
    var annoPin:[AnnotationViewController] = []
    var imag: UIImage?
    var count = 0
    var annoteClass: AnnotationViewController?
    
    @IBAction func cameraButtonClicked(_ sender: AnyObject) {
        
        vcI.delegate = self
        vcI.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vcI.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vcI.sourceType = .photoLibrary
        }
        self.present(vcI, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as!UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        photo = editedImage
        
        
        performSegue(withIdentifier: "tagSegue", sender: self)
        
        dismiss(animated: true, completion: nil)
        
        print("image choosen")
        
        
        
    }
    func same (){
        
        print(g)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        same()
      
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333,-122.416667), MKCoordinateSpanMake(0.1, 0.1))
        
        MapKitView.setRegion(sfRegion, animated: false)
        
        addannotations()
        // Do any additional setup after loading the view.
        MapKitView.delegate = self
       
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
 
        
    }
    

    
    func addannotations () {
        if anno.count > 0 {
            print("count anno\(anno.count)")
            
            for i in anno{
                MapKitView.addAnnotation(i)
            }
        }

    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        
        print("mapView through \(count) times")
        let reuseID = "myAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
        }
        
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        var mapannote = annoPin[count]
        imageView.image = mapannote.image
        count += 1
        return annotationView
    }

    // class object to store array of pictures and
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
     let locate  = segue.destination as! LocationsViewController
        locate.annot = anno
        locate.ima = photo
        locate.annoPi = annoPin
    }
    

}

