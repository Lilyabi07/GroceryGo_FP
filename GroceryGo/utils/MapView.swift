//
//  MapView.swift
//  GroceryGo
//
//  Created by b.b.a on 2025-11-20.
//

import Foundation
import MapKit

// Make MKMapItem Identifiable by providing a deterministic id.
// Use values that are likely stable: url, phone, name+coordinates, then coordinates.
extension MKMapItem: Identifiable {
    public var id: String {
        if let urlString = self.url?.absoluteString, !urlString.isEmpty {
            return "url:\(urlString)"
        }
        if let phone = self.phoneNumber, !phone.isEmpty {
            return "phone:\(phone)"
        }
        if let name = self.name, !name.isEmpty {
            return "name:\(name)-\(placemark.coordinate.latitude),\(placemark.coordinate.longitude)"
        }
        // Fallback to coordinates (may collide in rare edge cases)
        return "coord:\(placemark.coordinate.latitude),\(placemark.coordinate.longitude)"
    }
}
