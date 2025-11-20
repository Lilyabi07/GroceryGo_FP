//
//  StoreFinderView.swift
//  GroceryGo
//
//  Created on 11/4/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct StoreFinderView: View {
    @StateObject private var locationManager = StoreLocationManager()
    @State private var searchText = ""
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default to SF
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var selectedStore: MKMapItem?
    @State private var showingStoreDetail = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Map View
                Map(coordinateRegion: $region, 
                    showsUserLocation: true,
                    annotationItems: locationManager.searchResults) { mapItem in
                    MapAnnotation(coordinate: mapItem.placemark.coordinate) {
                        Button(action: {
                            selectedStore = mapItem
                            showingStoreDetail = true
                        }) {
                            VStack(spacing: 0) {
                                Image(systemName: "cart.fill")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                                
                                Image(systemName: "arrowtriangle.down.fill")
                                    .foregroundColor(.blue)
                                    .font(.caption)
                                    .offset(y: -5)
                            }
                        }
                    }
                }
                .edgesIgnoringSafeArea(.top)
                
                // Search Bar Overlay
                VStack {
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            TextField("Search for stores...", text: $searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                                .submitLabel(.search)
                                .onSubmit {
                                    performSearch()
                                }
                            
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(12)
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        
                        // Search button
                        if !searchText.isEmpty {
                            Button(action: performSearch) {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                    Text("Search")
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Results List at Bottom
                    if !locationManager.searchResults.isEmpty {
                        VStack(spacing: 0) {
                            HStack {
                                Text("\(locationManager.searchResults.count) stores found")
                                    .font(.headline)
                                    .padding(.horizontal)
                                    .padding(.top, 12)
                                Spacer()
                            }
                            
                            ScrollView {
                                LazyVStack(spacing: 8) {
                                    ForEach(locationManager.searchResults, id: \.self) { mapItem in
                                        StoreResultRow(mapItem: mapItem) {
                                            selectedStore = mapItem
                                            showingStoreDetail = true
                                            // Center map on selected store
                                            withAnimation {
                                                region.center = mapItem.placemark.coordinate
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 12)
                            }
                            .frame(maxHeight: 250)
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(20, corners: [.topLeft, .topRight])
                        .shadow(radius: 5)
                    }
                }
                
                // Error Message
                if let errorMessage = locationManager.errorMessage {
                    VStack {
                        Text(errorMessage)
                            .padding()
                            .background(Color.red.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                        Spacer()
                    }
                }
                
                // Location Permission Prompt
                if locationManager.authorizationStatus == .notDetermined {
                    VStack {
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: "location.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.blue)
                            
                            Text("Enable Location Services")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Allow GroceryGo to access your location to find nearby grocery stores")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                            
                            Button(action: {
                                locationManager.requestLocationPermission()
                            }) {
                                Text("Allow Location Access")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .padding()
                        Spacer()
                    }
                    .background(Color.black.opacity(0.3))
                }
            }
            .navigationTitle("Find Stores")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingStoreDetail) {
                if let store = selectedStore {
                    StoreDetailSheet(mapItem: store, userLocation: locationManager.userLocation)
                }
            }
            .onAppear {
                if locationManager.authorizationStatus == .authorizedWhenInUse ||
                   locationManager.authorizationStatus == .authorizedAlways {
                    locationManager.startUpdatingLocation()
                }
            }
            .onChange(of: locationManager.userLocation) { _, newLocation in
                if let location = newLocation {
                    region.center = location
                    // Automatically search for stores when location is available
                    if locationManager.searchResults.isEmpty {
                        locationManager.searchForGroceryStores(near: location)
                    }
                }
            }
        }
    }
    
    private func performSearch() {
        let coordinate = locationManager.userLocation ?? region.center
        locationManager.searchForGroceryStores(near: coordinate, searchText: searchText)
    }
}

// MARK: - Store Result Row
struct StoreResultRow: View {
    let mapItem: MKMapItem
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "cart.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.blue)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(mapItem.name ?? "Unknown Store")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if let address = formatAddress(mapItem.placemark) {
                        Text(address)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    
                    if let phoneNumber = mapItem.phoneNumber {
                        Text(phoneNumber)
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
        }
    }
    
    private func formatAddress(_ placemark: MKPlacemark) -> String? {
        var components: [String] = []
        
        if let street = placemark.thoroughfare {
            components.append(street)
        }
        if let city = placemark.locality {
            components.append(city)
        }
        if let state = placemark.administrativeArea {
            components.append(state)
        }
        
        return components.isEmpty ? nil : components.joined(separator: ", ")
    }
}

// MARK: - Store Detail Sheet
struct StoreDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let mapItem: MKMapItem
    let userLocation: CLLocationCoordinate2D?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Store Name
                    HStack {
                        Image(systemName: "cart.fill")
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.blue)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text(mapItem.name ?? "Unknown Store")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                    }
                    
                    Divider()
                    
                    // Address
                    if let address = formatFullAddress(mapItem.placemark) {
                        InfoRow(icon: "location.fill", title: "Address", value: address)
                    }
                    
                    // Phone
                    if let phoneNumber = mapItem.phoneNumber {
                        InfoRow(icon: "phone.fill", title: "Phone", value: phoneNumber)
                            .onTapGesture {
                                callStore()
                            }
                    }
                    
                    // Distance
                    if let distance = calculateDistance() {
                        InfoRow(icon: "arrow.triangle.swap", title: "Distance", value: distance)
                    }
                    
                    Divider()
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        Button(action: openInMaps) {
                            HStack {
                                Image(systemName: "map.fill")
                                Text("Open in Maps")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        
                        if mapItem.phoneNumber != nil {
                            Button(action: callStore) {
                                HStack {
                                    Image(systemName: "phone.fill")
                                    Text("Call Store")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Store Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func formatFullAddress(_ placemark: MKPlacemark) -> String? {
        var components: [String] = []
        
        if let street = placemark.thoroughfare {
            if let number = placemark.subThoroughfare {
                components.append("\(number) \(street)")
            } else {
                components.append(street)
            }
        }
        if let city = placemark.locality {
            components.append(city)
        }
        if let state = placemark.administrativeArea {
            if let zip = placemark.postalCode {
                components.append("\(state) \(zip)")
            } else {
                components.append(state)
            }
        }
        
        return components.isEmpty ? nil : components.joined(separator: ", ")
    }
    
    private func calculateDistance() -> String? {
        guard let userLocation = userLocation else { return nil }
        
        let storeLocation = CLLocation(
            latitude: mapItem.placemark.coordinate.latitude,
            longitude: mapItem.placemark.coordinate.longitude
        )
        let userCLLocation = CLLocation(
            latitude: userLocation.latitude,
            longitude: userLocation.longitude
        )
        
        let distanceInMeters = userCLLocation.distance(from: storeLocation)
        let distanceInMiles = distanceInMeters / 1609.34
        
        if distanceInMiles < 0.1 {
            return String(format: "%.0f ft", distanceInMeters * 3.28084)
        } else {
            return String(format: "%.1f mi", distanceInMiles)
        }
    }
    
    private func cleanPhoneNumber(_ phoneNumber: String) -> String {
        phoneNumber.filter { $0.isNumber }
    }
    
    private func openInMaps() {
        mapItem.openInMaps(launchOptions: nil)
    }
    
    private func callStore() {
        guard let phoneNumber = mapItem.phoneNumber else { return }
        let cleaned = cleanPhoneNumber(phoneNumber)
        if let url = URL(string: "tel://\(cleaned)") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Info Row
struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.body)
            }
            
            Spacer()
        }
    }
}

// MARK: - Rounded Corner Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    StoreFinderView()
}
