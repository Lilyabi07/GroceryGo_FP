//
//  CartItem.swift
//  GroceryGo
//
//  Created on 11/4/25.
//

import Foundation
import SwiftData

@Model
final class CartItem {
    var id: UUID
    var groceryId: UUID
    var groceryName: String
    var price: Double
    var quantity: Int
    var unit: String
    var addedDate: Date
    
    init(id: UUID = UUID(), groceryId: UUID, groceryName: String, price: Double, quantity: Int = 1, unit: String = "each", addedDate: Date = Date()) {
        self.id = id
        self.groceryId = groceryId
        self.groceryName = groceryName
        self.price = price
        self.quantity = quantity
        self.unit = unit
        self.addedDate = addedDate
    }
    
    var totalPrice: Double {
        return price * Double(quantity)
    }
}
