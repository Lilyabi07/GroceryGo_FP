import XCTest
import Foundation
@testable import GroceryGo

final class GroceryStoreTests: XCTestCase {
    
    func testGroceryStoreInitialization() {
        // Given
        let id = UUID()
        let name = "Whole Foods Market"
        let address = "123 Main St"
        let city = "San Francisco"
        let state = "CA"
        let zipCode = "94102"
        let latitude = 37.7749
        let longitude = -122.4194
        let phoneNumber = "(415) 555-0123"
        let hours = "8 AM - 10 PM"
        
        // When
        let store = GroceryStore(
            id: id,
            name: name,
            address: address,
            city: city,
            state: state,
            zipCode: zipCode,
            latitude: latitude,
            longitude: longitude,
            phoneNumber: phoneNumber,
            hours: hours
        )
        
        // Then
        XCTAssertEqual(store.id, id)
        XCTAssertEqual(store.name, name)
        XCTAssertEqual(store.address, address)
        XCTAssertEqual(store.city, city)
        XCTAssertEqual(store.state, state)
        XCTAssertEqual(store.zipCode, zipCode)
        XCTAssertEqual(store.latitude, latitude, accuracy: 0.0001)
        XCTAssertEqual(store.longitude, longitude, accuracy: 0.0001)
        XCTAssertEqual(store.phoneNumber, phoneNumber)
        XCTAssertEqual(store.hours, hours)
    }
    
    func testGroceryStoreDefaultUUID() {
        // When
        let store1 = GroceryStore(
            name: "Store 1",
            address: "123 Main St",
            city: "City",
            state: "CA",
            zipCode: "12345",
            latitude: 37.0,
            longitude: -122.0
        )
        let store2 = GroceryStore(
            name: "Store 2",
            address: "456 Oak Ave",
            city: "City",
            state: "CA",
            zipCode: "12345",
            latitude: 37.0,
            longitude: -122.0
        )
        
        // Then
        XCTAssertNotEqual(store1.id, store2.id)
    }
    
    func testGroceryStoreEquality() {
        // Given
        let id = UUID()
        let store1 = GroceryStore(
            id: id,
            name: "Trader Joe's",
            address: "789 Market St",
            city: "San Francisco",
            state: "CA",
            zipCode: "94103",
            latitude: 37.7849,
            longitude: -122.4094
        )
        let store2 = GroceryStore(
            id: id,
            name: "Trader Joe's",
            address: "789 Market St",
            city: "San Francisco",
            state: "CA",
            zipCode: "94103",
            latitude: 37.7849,
            longitude: -122.4094
        )
        
        // Then
        XCTAssertEqual(store1, store2)
    }
    
    func testGroceryStoreCodable() throws {
        // Given
        let store = GroceryStore(
            name: "Safeway",
            address: "1 Safeway Plaza",
            city: "Oakland",
            state: "CA",
            zipCode: "94607",
            latitude: 37.8044,
            longitude: -122.2712,
            phoneNumber: "(510) 555-0199",
            hours: "6 AM - 12 AM"
        )
        
        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(store)
        
        let decoder = JSONDecoder()
        let decodedStore = try decoder.decode(GroceryStore.self, from: data)
        
        // Then
        XCTAssertEqual(store.id, decodedStore.id)
        XCTAssertEqual(store.name, decodedStore.name)
        XCTAssertEqual(store.address, decodedStore.address)
        XCTAssertEqual(store.city, decodedStore.city)
        XCTAssertEqual(store.state, decodedStore.state)
        XCTAssertEqual(store.zipCode, decodedStore.zipCode)
        XCTAssertEqual(store.latitude, decodedStore.latitude, accuracy: 0.0001)
        XCTAssertEqual(store.longitude, decodedStore.longitude, accuracy: 0.0001)
        XCTAssertEqual(store.phoneNumber, decodedStore.phoneNumber)
        XCTAssertEqual(store.hours, decodedStore.hours)
    }
    
    func testGroceryStoreCoordinates() {
        // Given
        let latitude = 37.7749
        let longitude = -122.4194
        let store = GroceryStore(
            name: "Target",
            address: "100 Market St",
            city: "San Francisco",
            state: "CA",
            zipCode: "94102",
            latitude: latitude,
            longitude: longitude
        )
        
        // Then
        XCTAssertEqual(store.latitude, latitude, accuracy: 0.0001)
        XCTAssertEqual(store.longitude, longitude, accuracy: 0.0001)
    }
    
    func testGroceryStoreOptionalFields() {
        // When
        let store = GroceryStore(
            name: "Local Grocery",
            address: "500 Pine St",
            city: "Berkeley",
            state: "CA",
            zipCode: "94704",
            latitude: 37.8715,
            longitude: -122.2730
        )
        
        // Then
        XCTAssertNil(store.phoneNumber)
        XCTAssertNil(store.hours)
    }
}
