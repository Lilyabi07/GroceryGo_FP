import XCTest
import Foundation
@testable import GroceryGo

final class ShoppingListItemTests: XCTestCase {
    
    func testShoppingListItemInitialization() {
        // Given
        let id = UUID()
        let name = "Apples"
        let category = "Fruits"
        let isCompleted = false
        let dateAdded = Date()
        
        // When
        let item = ShoppingListItem(id: id, name: name, category: category, isCompleted: isCompleted, dateAdded: dateAdded)
        
        // Then
        XCTAssertEqual(item.id, id)
        XCTAssertEqual(item.name, name)
        XCTAssertEqual(item.category, category)
        XCTAssertEqual(item.isCompleted, isCompleted)
        XCTAssertEqual(item.dateAdded, dateAdded)
    }
    
    func testShoppingListItemDefaultValues() {
        // When
        let item = ShoppingListItem(name: "Milk")
        
        // Then
        XCTAssertFalse(item.isCompleted)
        XCTAssertNil(item.category)
        XCTAssertNotNil(item.id)
        XCTAssertNotNil(item.dateAdded)
    }
    
    func testShoppingListItemDefaultUUID() {
        // When
        let item1 = ShoppingListItem(name: "Bread")
        let item2 = ShoppingListItem(name: "Butter")
        
        // Then
        XCTAssertNotEqual(item1.id, item2.id)
    }
    
    func testShoppingListItemEquality() {
        // Given
        let id = UUID()
        let date = Date()
        let item1 = ShoppingListItem(id: id, name: "Eggs", category: "Dairy", isCompleted: false, dateAdded: date)
        let item2 = ShoppingListItem(id: id, name: "Eggs", category: "Dairy", isCompleted: false, dateAdded: date)
        
        // Then
        XCTAssertEqual(item1, item2)
    }
    
    func testShoppingListItemCodable() throws {
        // Given
        let item = ShoppingListItem(name: "Cheese", category: "Dairy", isCompleted: false)
        
        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(item)
        
        let decoder = JSONDecoder()
        let decodedItem = try decoder.decode(ShoppingListItem.self, from: data)
        
        // Then
        XCTAssertEqual(item.id, decodedItem.id)
        XCTAssertEqual(item.name, decodedItem.name)
        XCTAssertEqual(item.category, decodedItem.category)
        XCTAssertEqual(item.isCompleted, decodedItem.isCompleted)
    }
    
    func testShoppingListItemCompletionToggle() {
        // Given
        var item = ShoppingListItem(name: "Tomatoes", isCompleted: false)
        
        // When
        item.isCompleted = true
        
        // Then
        XCTAssertTrue(item.isCompleted)
        
        // When toggled back
        item.isCompleted = false
        
        // Then
        XCTAssertFalse(item.isCompleted)
    }
    
    func testShoppingListItemWithoutCategory() {
        // When
        let item = ShoppingListItem(name: "Random Item", category: nil)
        
        // Then
        XCTAssertNil(item.category)
    }
}
