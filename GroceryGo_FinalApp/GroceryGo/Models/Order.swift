//
//  Order.swift
//  GroceryGo
//
//  Created on 11/4/25.
//

import Foundation
import SwiftData

@Model
final class Order {
    var id: UUID
    var orderDate: Date
    var totalAmount: Double
    var status: String
    var deliveryAddress: String
    var items: [OrderItem]
    
    init(id: UUID = UUID(), orderDate: Date = Date(), totalAmount: Double, status: String = "Pending", deliveryAddress: String = "", items: [OrderItem] = []) {
        self.id = id
        self.orderDate = orderDate
        self.totalAmount = totalAmount
        self.status = status
        self.deliveryAddress = deliveryAddress
        self.items = items
    }
}

struct OrderItem: Codable {
    var groceryName: String
    var quantity: Int
    var price: Double
    var unit: String
    
    var totalPrice: Double {
        return price * Double(quantity)
    }
}
