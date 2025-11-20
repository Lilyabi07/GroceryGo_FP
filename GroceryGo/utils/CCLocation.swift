//
//  CCLocation.swift
//  GroceryGo
//
//  Created by b.b.a on 2025-11-20.
//

import CoreLocation

// Provide Equatable conformance so Optional<CLLocationCoordinate2D> can be used with SwiftUI's onChange(of:).
// Use a small tolerance to avoid firing onChange for tiny floating point noise.
extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        let eps = 1e-6
        return abs(lhs.latitude - rhs.latitude) <= eps &&
               abs(lhs.longitude - rhs.longitude) <= eps
    }
}
