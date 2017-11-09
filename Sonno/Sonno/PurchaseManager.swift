//
//  PurchaseManager.swift
//  Sonno
//
//  Created by Lucas Maris on 12/29/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseManager: NSObject {
    
    static let sharedInstance = PurchaseManager()
    var products = [SKProduct]()
    
    //Computed premium
    var isPremium: Bool {
        return RageProducts.store.isProductPurchased(RageProducts.Premium)
    }
    
    override init() {
        super.init()
        print("Init the Purchase Manager")
        getProducts()
    }
    
    func getProducts() {
        RageProducts.store.requestProductsWithCompletionHandler { success, products in
            if success {
                self.products = products
            }
        }
    }

}
