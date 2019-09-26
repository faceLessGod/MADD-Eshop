//
//  CartItemCell.swift
//  MADD Assignment
//
//  Created by Aruna Lakmal2 on 9/26/19.
//  Copyright © 2019 Aruna Lakmal2. All rights reserved.
//

import UIKit

class CartItemCell: UICollectionViewCell {
    @IBOutlet weak var cartItemImageView: UIImageView!
    @IBOutlet weak var cartItemLabel: UILabel!
    
    override func prepareForReuse() {
        cartItemImageView.image = nil
        cartItemLabel.text = nil
    }
    
    override func awakeFromNib() {
         super.awakeFromNib()
        
        self.layer.borderColor = UIColor.textViewBorderColor().cgColor
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
    }
    
    func setDataToCell(imageData: NSData?, itemLabel: String?) {
        
        var cartItemImage: UIImage!
        if let imageData = imageData {
            cartItemImage = UIImage(data: imageData as Data)
        } else {
            cartItemImage = UIImage(named: "default-image")
        }
        cartItemImageView.image = cartItemImage
        cartItemLabel.text = itemLabel ?? "Item Name not defined"
    }
}
