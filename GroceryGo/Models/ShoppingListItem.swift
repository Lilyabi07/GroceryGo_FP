//
//  ShoppingListItem.swift
//  GroceryGo
//
//  Created on 11/4/25.
//

import Foundation
import SwiftData

@Model
final class ShoppingListItem {
    var id: UUID
    var name: String
    var category: String?
    var isCompleted: Bool
    var dateAdded: Date
    
    init(id: UUID = UUID(), name: String, category: String? = nil, isCompleted: Bool = false, dateAdded: Date = Date()) {
        self.id = id
        self.name = name
        self.category = category
        self.isCompleted = isCompleted
        self.dateAdded = dateAdded
    }
}
