import Foundation

/// Represents an item in the shopping to-do list
struct ShoppingListItem: Codable, Identifiable, Equatable {
    /// Unique identifier for the shopping list item
    let id: UUID
    
    /// Name of the item to shop for
    let name: String
    
    /// Optional category for the item
    let category: String?
    
    /// Whether the item has been completed (added to cart/purchased)
    var isCompleted: Bool
    
    /// Date when the item was added to the list
    let dateAdded: Date
    
    /// Initialize a new shopping list item
    /// - Parameters:
    ///   - id: Unique identifier (defaults to a new UUID)
    ///   - name: Name of the item
    ///   - category: Optional category for the item
    ///   - isCompleted: Whether the item is completed (defaults to false)
    ///   - dateAdded: Date when added (defaults to current date)
    init(id: UUID = UUID(), name: String, category: String? = nil, isCompleted: Bool = false, dateAdded: Date = Date()) {
        self.id = id
        self.name = name
        self.category = category
        self.isCompleted = isCompleted
        self.dateAdded = dateAdded
    }
}
