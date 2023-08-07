//
//  InAppPurchaseProducts.swift
//  StrategiesApp
//
//  Created by Nitin Kumar on 09/09/18.
//  Copyright © 2018 AceLight. All rights reserved.
//

import UIKit
import Foundation

public struct InAppPurchaseProducts {
    
    public static let allCards = "KCSTAppAccessAll"//"com.KumaraCreations.StrategiesApp.allCards"
    private static let productIdentifiers: Set<ProductIdentifier> = [InAppPurchaseProducts.allCards]
    public static let store = IAPHelper(productIds: InAppPurchaseProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
