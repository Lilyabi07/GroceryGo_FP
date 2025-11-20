//
//  Grocery.swift
//  GroceryGo
//
//  Created on 11/4/25.
//

import Foundation
import SwiftData

@Model
final class Grocery {
    var id: UUID
    var name: String
    var category: String
    var price: Double
    var imageSystemName: String
    var imageName: String?
    var descriptionText: String
    var unit: String
    
    init(id: UUID = UUID(), name: String, category: String, price: Double, imageSystemName: String = "cart", imageName: String? = nil, descriptionText: String = "", unit: String = "each") {
        self.id = id
        self.name = name
        self.category = category
        self.price = price
        self.imageSystemName = imageSystemName
        self.imageName = imageName
        self.descriptionText = descriptionText
        self.unit = unit
    }
}
