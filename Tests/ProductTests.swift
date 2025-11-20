import XCTest
import Foundation
@testable import GroceryGo

final class ProductTests: XCTestCase {
    
    func testProductInitialization() {
        // Given
        let id = UUID()
        let name = "Apple"
        let price = 1.99
        let category = "Fruits"
        
        // When
        let product = Product(id: id, name: name, price: price, category: category)
        
        // Then
        XCTAssertEqual(product.id, id)
        XCTAssertEqual(product.name, name)
        XCTAssertEqual(product.price, price)
        XCTAssertEqual(product.category, category)
    }
    
    func testProductDefaultUUID() {
        // When
        let product1 = Product(name: "Banana", price: 0.99, category: "Fruits")
        let product2 = Product(name: "Orange", price: 1.49, category: "Fruits")
        
        // Then
        XCTAssertNotEqual(product1.id, product2.id)
    }
    
    func testProductEquality() {
        // Given
        let id = UUID()
        let product1 = Product(id: id, name: "Apple", price: 1.99, category: "Fruits")
        let product2 = Product(id: id, name: "Apple", price: 1.99, category: "Fruits")
        
        // Then
        XCTAssertEqual(product1, product2)
    }
    
    func testProductCodable() throws {
        // Given
        let product = Product(name: "Milk", price: 3.49, category: "Dairy")
        
        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(product)
        
        let decoder = JSONDecoder()
        let decodedProduct = try decoder.decode(Product.self, from: data)
        
        // Then
        XCTAssertEqual(product.id, decodedProduct.id)
        XCTAssertEqual(product.name, decodedProduct.name)
        XCTAssertEqual(product.price, decodedProduct.price)
        XCTAssertEqual(product.category, decodedProduct.category)
    }
    
    func testProductWithImageName() {
        // Given
        let imageName = "apple"
        
        // When
        let product = Product(name: "Apple", price: 1.99, category: "Fruits", imageName: imageName)
        
        // Then
        XCTAssertEqual(product.imageName, imageName)
    }
    
    func testProductWithoutImageName() {
        // When
        let product = Product(name: "Orange", price: 1.49, category: "Fruits")
        
        // Then
        XCTAssertNil(product.imageName)
    }
    
    func testProductImageNameCodable() throws {
        // Given
        let product = Product(name: "Carrot", price: 0.99, category: "Vegetables", imageName: "carrot")
        
        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(product)
        
        let decoder = JSONDecoder()
        let decodedProduct = try decoder.decode(Product.self, from: data)
        
        // Then
        XCTAssertEqual(product.imageName, decodedProduct.imageName)
        XCTAssertEqual(decodedProduct.imageName, "carrot")
    }
}
