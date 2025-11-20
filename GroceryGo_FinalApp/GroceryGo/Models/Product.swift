import Foundation

/// Represents a product in the grocery store
struct Product: Codable, Identifiable, Equatable {
    /// Unique identifier for the product
    let id: UUID
    
    /// Name of the product
    let name: String
    
    /// Price of the product
    let price: Double
    
    /// Category of the product
    let category: String
    
    /// Optional custom image name from Assets.xcassets (e.g., "apple", "milk", "carrot")
    /// If nil or empty, apps should fall back to SF Symbols or default imagery
    let imageName: String?
    
    /// Initialize a new product
    /// - Parameters:
    ///   - id: Unique identifier (defaults to a new UUID)
    ///   - name: Name of the product
    ///   - price: Price of the product
    ///   - category: Category of the product
    ///   - imageName: Optional custom image name from Assets
    init(id: UUID = UUID(), name: String, price: Double, category: String, imageName: String? = nil) {
        self.id = id
        self.name = name
        self.price = price
        self.category = category
        self.imageName = imageName
    }
}
