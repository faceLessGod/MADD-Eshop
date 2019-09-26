//
//  ItemDetailsViewController.swift
//  MADD Assignment
//
//  Created by Aruna Lakmal2 on 9/26/19.
//  Copyright © 2019 Aruna Lakmal2. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UIViewController {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var itemLocation: UITextField!
    @IBOutlet weak var itemDescription: UITextView!
    
    
    var selectedItem: Item!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setDataToFields()
    }
    
    func setupUI () {
        
        //Description textview border
        itemDescription.layer.borderColor = UIColor.textViewBorderColor().cgColor
        itemDescription.layer.borderWidth = 1.0
        itemDescription.layer.cornerRadius = 5.0
        
        itemName.isEnabled = false
        itemPrice.isEnabled = false
        itemLocation.isEnabled = false
    }
    
    func setDataToFields() {
        if let item = selectedItem {
            itemImageView.image = UIImage(data: item.image! as Data) ?? UIImage(named: "default-image")
            itemName.text = item.name
            itemPrice.text = String(item.price)
            itemDescription.text = item.itemDesciption
            itemLocation.text = item.location
        }
    }

}
