import Foundation

/// Represents a physical grocery store location
public struct GroceryStore: Codable, Identifiable, Equatable {
    /// Unique identifier for the store
    public let id: UUID
    
    /// Name of the grocery store
    public let name: String
    
    /// Street address of the store
    public let address: String
    
    /// City where the store is located
    public let city: String
    
    /// State abbreviation
    public let state: String
    
    /// ZIP code
    public let zipCode: String
    
    /// Latitude coordinate
    public let latitude: Double
    
    /// Longitude coordinate
    public let longitude: Double
    
    /// Phone number (optional)
    public let phoneNumber: String?
    
    /// Store hours (optional)
    public let hours: String?
    
    /// Initialize a new grocery store
    /// - Parameters:
    ///   - id: Unique identifier (defaults to a new UUID)
    ///   - name: Name of the grocery store
    ///   - address: Street address
    ///   - city: City name
    ///   - state: State abbreviation
    ///   - zipCode: ZIP code
    ///   - latitude: Latitude coordinate
    ///   - longitude: Longitude coordinate
    ///   - phoneNumber: Phone number (optional)
    ///   - hours: Store hours (optional)
    public init(
        id: UUID = UUID(),
        name: String,
        address: String,
        city: String,
        state: String,
        zipCode: String,
        latitude: Double,
        longitude: Double,
        phoneNumber: String? = nil,
        hours: String? = nil
    ) {
        self.id = id
        self.name = name
        self.address = address
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.latitude = latitude
        self.longitude = longitude
        self.phoneNumber = phoneNumber
        self.hours = hours
    }
}
