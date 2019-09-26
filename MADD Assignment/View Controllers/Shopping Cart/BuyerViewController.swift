//
//  BuyerViewController.swift
//  MADD Assignment
//
//  Created by Aruna Lakmal2 on 9/22/19.
//  Copyright © 2019 Aruna Lakmal2. All rights reserved.
//

import UIKit
import CoreData

class BuyerViewController: UIViewController {
    
    @IBOutlet weak var cartListCollectionView: UICollectionView!
    @IBOutlet weak var itemSearchField: UISearchBar!
    var cartItemList: [Item] = []
    var displayCartItemList: [Item] = []
    var selectedItem: Item?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dismissKeyboardOnBackgroundTap()
        self.loadCartItems()
    }
    
    func loadCartItems() {
        self.cartItemList = []
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        request.returnsObjectsAsFaults = false
        
        let items: NSArray = try! context.fetch(request) as NSArray
        if items.count > 0 {
            for item in items {
                let item = item as! Item
                cartItemList.append(item)
            }
        }
        
        displayCartItemList = cartItemList
    }
    
    @IBAction func onLogoutTapped(_ sender: Any) {
        if let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? ViewController {
            if let navController = navigationController {
                navController.pushViewController(loginVC, animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueIdentifier = segue.identifier {
            switch segueIdentifier {
            case SegueIdentifiers.viewItemIdentifier:
                if let destinationVC = segue.destination as? ItemDetailsViewController {
                    if let selectedItem = self.selectedItem {
                        destinationVC.selectedItem = selectedItem
                    }
                }
            default:
                return
            }
        }
    }
}

extension BuyerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.displayCartItemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCell: CartItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.cartCellIdentifier, for: indexPath) as! CartItemCell
        itemCell.setDataToCell(imageData: displayCartItemList[indexPath.item].image, itemLabel: displayCartItemList[indexPath.item].name)
        return itemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 30)/2
        return CGSize(width: width, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedItem = displayCartItemList[indexPath.item]
        performSegue(withIdentifier: SegueIdentifiers.viewItemIdentifier, sender: self)
    }
}

extension BuyerViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        let text = searchText.lowercased()
        
        if text == "" {
            displayCartItemList = cartItemList
        } else {
            displayCartItemList = cartItemList.filter {$0.name!.lowercased().contains(text)}
        }

        self.cartListCollectionView.reloadData()
    }
}
