# GroceryGo Data Models

This directory contains the core data models for the GroceryGo iOS application.

## Models

### Product

Represents a product available in the grocery store.

**Properties:**
- `id: UUID` - Unique identifier for the product
- `name: String` - Name of the product
- `price: Double` - Price of the product
- `category: String` - Category classification (e.g., "Fruits", "Dairy", "Bakery")

**Features:**
- Conforms to `Codable` for JSON serialization/deserialization
- Conforms to `Identifiable` for SwiftUI list integration
- Conforms to `Equatable` for comparison operations
- Automatic UUID generation via default parameter

**Example Usage:**
```swift
let apple = Product(name: "Apple", price: 1.99, category: "Fruits")
let milk = Product(id: UUID(), name: "Milk", price: 3.49, category: "Dairy")
```

### Order

Represents an order containing one or more products.

**Properties:**
- `id: UUID` - Unique identifier for the order
- `items: [Product]` - Array of products in the order
- `totalPrice: Double` - Total price of all items in the order
- `status: String` - Current status of the order (e.g., "Pending", "Completed", "Cancelled")

**Features:**
- Conforms to `Codable` for JSON serialization/deserialization
- Conforms to `Identifiable` for SwiftUI list integration
- Conforms to `Equatable` for comparison operations
- Automatic UUID generation via default parameter
- Two initializers:
  - Manual total price specification
  - Automatic total price calculation from items

**Example Usage:**
```swift
// Manual total price
let order1 = Order(
    items: [apple, banana],
    totalPrice: 2.98,
    status: "Pending"
)

// Automatic total price calculation
let order2 = Order(
    items: [apple, banana, milk],
    status: "Pending"
)
// totalPrice is automatically calculated as sum of item prices
```

## JSON Serialization

Both models support JSON encoding and decoding through `Codable` conformance:

```swift
// Encoding
let encoder = JSONEncoder()
let orderData = try encoder.encode(order)

// Decoding
let decoder = JSONDecoder()
let order = try decoder.decode(Order.self, from: orderData)
```

## Testing

Comprehensive unit tests are available in the `Tests` directory:
- `ProductTests.swift` - Tests for Product model
- `OrderTests.swift` - Tests for Order model

Run tests with:
```bash
swift test
```
