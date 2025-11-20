import Foundation

/// Represents an order containing products
struct Order: Codable, Identifiable, Equatable {
    /// Unique identifier for the order
    let id: UUID
    
    /// List of products in the order
    let items: [Product]
    
    /// Total price of the order
    let totalPrice: Double
    
    /// Status of the order
    let status: String
    
    /// Initialize a new order
    /// - Parameters:
    ///   - id: Unique identifier (defaults to a new UUID)
    ///   - items: List of products in the order
    ///   - totalPrice: Total price of the order
    ///   - status: Status of the order
    init(id: UUID = UUID(), items: [Product], totalPrice: Double, status: String) {
        self.id = id
        self.items = items
        self.totalPrice = totalPrice
        self.status = status
    }
    
    /// Initialize a new order with automatic total price calculation
    /// - Parameters:
    ///   - id: Unique identifier (defaults to a new UUID)
    ///   - items: List of products in the order
    ///   - status: Status of the order
    init(id: UUID = UUID(), items: [Product], status: String) {
        self.id = id
        self.items = items
        self.totalPrice = items.reduce(0.0) { $0 + $1.price }
        self.status = status
    }
}
