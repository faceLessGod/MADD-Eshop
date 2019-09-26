//
//  SellerViewController.swift
//  MADD Assignment
//
//  Created by Aruna Lakmal2 on 9/22/19.
//  Copyright © 2019 Aruna Lakmal2. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class SellerViewController: UIViewController {
    
    //Labels
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var scrollerView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemLocation: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var itemDescription: UITextView!
    
    //Variables
    var itemImagePicker: UIImagePickerController!
    var itemImage: UIImage?
    let locationManager = CLLocationManager()
    var location: String?
    var latitude: Double?
    var longitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLocationServices()
    }
    
    func setupUI() {
        
        self.dismissKeyboardOnBackgroundTap()
        //Image tap gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapImage(tapGestureRecognizer:)))
        itemImageView.isUserInteractionEnabled = true
        itemImageView.addGestureRecognizer(tapGestureRecognizer)
        
        //Description textview border
        itemDescription.layer.borderColor = UIColor.textViewBorderColor().cgColor
        itemDescription.layer.borderWidth = 1.0
        itemDescription.layer.cornerRadius = 5.0
        itemDescription.placeholder = "Item Description"
    }
    
    @IBAction func onAddItem(_ sender: Any) {
        
        if self.validateFields() {
            var imageData: Data?
            if let itemImage = itemImageView.image {
                imageData = itemImage.jpegData(compressionQuality: 0.5)
            }
            
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Item", in: context)
            
            let items = Item(entity: entity!, insertInto: context)
            items.name = itemName.text
            items.price = Float(itemPrice.text!)!
            items.itemDesciption = itemDescription.text
            items.location = self.itemLocation.text
            items.image = imageData as NSData?
            items.latitude = latitude ?? -1
            items.longitude = longitude ?? -1
            
            try!  context.save()
            
            self.clearFields()
        } else {
            self.showAlert(title: fillAllTitle, message: fillAllMessage)
        }
    }
    
    @IBAction func onClearTapped(_ sender: Any) {
        self.clearFields()
    }
    
    @IBAction func onLogOutTapped(_ sender: Any) {
        if let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? ViewController {
            if let navController = navigationController {
                navController.pushViewController(loginVC, animated: true)
            }
        }
    }
}

//Image Picker
extension SellerViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @objc
    func onTapImage(tapGestureRecognizer: UITapGestureRecognizer) {
        
        itemImagePicker =  UIImagePickerController()
        itemImagePicker.delegate = self
        itemImagePicker.sourceType = .camera
        
        present(itemImagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        itemImagePicker.dismiss(animated: true, completion: nil)
        itemImageView.image = info[.originalImage] as? UIImage
        
        locationManager.startUpdatingLocation()
        
    }
}

//Location Manager
extension SellerViewController: CLLocationManagerDelegate {
    
    func setupLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            showAlert(title: locationAlertTitle, message: locationOffMessage)
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        
        switch CLLocationManager.authorizationStatus() {
        case .denied:
            showAlert(title: locationAlertTitle, message: locationDeniedMessage)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                self.showAlert(title: errorTitle, message: locationFailedMessage)
                return
            }
            
            guard let placemark = placemarks?.first else {
                self.showAlert(title: errorTitle, message: locationFailedMessage)
                return
            }
            
            let state = placemark.administrativeArea ?? ""
            let streetName = placemark.thoroughfare ?? ""
            let city = placemark.locality ?? ""
            
            self.location = "\(streetName), \(city), \(state)"
            
            DispatchQueue.main.async {
                self.itemLocation.text = self.location
            }
            
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(title: locationAlertTitle, message: locationFailedMessage)
    }
}

extension SellerViewController {
    func clearFields() {
        self.itemName.text = nil
        self.itemPrice.text = nil
        self.itemLocation.text = nil
        self.itemDescription.text = nil
        self.itemImageView.image = UIImage(named: "addImage")
    }
    
    func validateFields() -> Bool {
        
        var isValidated: Bool = false
        if let itemName = itemName.text, itemName != "", let itemPrice = itemPrice.text, itemPrice != "",
            let itemLocation = itemLocation.text, itemLocation != "", let itemDesc = itemDescription.text,
            itemDesc != "", let image = itemImageView.image, image != UIImage(named: "addImage")
        {
            isValidated = true
        }
        
        return isValidated
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


