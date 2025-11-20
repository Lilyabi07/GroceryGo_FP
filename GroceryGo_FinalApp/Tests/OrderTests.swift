import XCTest
import Foundation
@testable import GroceryGo

final class OrderTests: XCTestCase {
    
    func testOrderInitialization() {
        // Given
        let id = UUID()
        let product1 = Product(name: "Apple", price: 1.99, category: "Fruits")
        let product2 = Product(name: "Banana", price: 0.99, category: "Fruits")
        let items = [product1, product2]
        let totalPrice = 2.98
        let status = "Pending"
        
        // When
        let order = Order(id: id, items: items, totalPrice: totalPrice, status: status)
        
        // Then
        XCTAssertEqual(order.id, id)
        XCTAssertEqual(order.items, items)
        XCTAssertEqual(order.totalPrice, totalPrice)
        XCTAssertEqual(order.status, status)
    }
    
    func testOrderAutomaticTotalPriceCalculation() {
        // Given
        let product1 = Product(name: "Apple", price: 1.99, category: "Fruits")
        let product2 = Product(name: "Banana", price: 0.99, category: "Fruits")
        let items = [product1, product2]
        
        // When
        let order = Order(items: items, status: "Pending")
        
        // Then
        XCTAssertEqual(order.totalPrice, 2.98, accuracy: 0.01)
    }
    
    func testOrderDefaultUUID() {
        // Given
        let product = Product(name: "Apple", price: 1.99, category: "Fruits")
        
        // When
        let order1 = Order(items: [product], status: "Pending")
        let order2 = Order(items: [product], status: "Completed")
        
        // Then
        XCTAssertNotEqual(order1.id, order2.id)
    }
    
    func testOrderEquality() {
        // Given
        let id = UUID()
        let product = Product(name: "Apple", price: 1.99, category: "Fruits")
        let order1 = Order(id: id, items: [product], totalPrice: 1.99, status: "Pending")
        let order2 = Order(id: id, items: [product], totalPrice: 1.99, status: "Pending")
        
        // Then
        XCTAssertEqual(order1, order2)
    }
    
    func testOrderCodable() throws {
        // Given
        let product = Product(name: "Apple", price: 1.99, category: "Fruits")
        let order = Order(items: [product], status: "Pending")
        
        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(order)
        
        let decoder = JSONDecoder()
        let decodedOrder = try decoder.decode(Order.self, from: data)
        
        // Then
        XCTAssertEqual(order.id, decodedOrder.id)
        XCTAssertEqual(order.items, decodedOrder.items)
        XCTAssertEqual(order.totalPrice, decodedOrder.totalPrice)
        XCTAssertEqual(order.status, decodedOrder.status)
    }
    
    func testEmptyOrder() {
        // When
        let order = Order(items: [], status: "Empty")
        
        // Then
        XCTAssertEqual(order.items.count, 0)
        XCTAssertEqual(order.totalPrice, 0.0)
    }
}
