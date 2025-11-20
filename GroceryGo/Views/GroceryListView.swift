//
//  GroceryListView.swift
//  GroceryGo
//
//  Created on 11/4/25.
//

import SwiftUI
import SwiftData

struct GroceryListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var groceries: [Grocery]
    @Query private var cartItems: [CartItem]
    
    @State private var selectedGrocery: Grocery?
    @State private var showingDetail = false
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    
    let categories = ["All", "Fruits", "Vegetables", "Dairy", "Bakery", "Meat", "Snacks", "Beverages"]
    
    var filteredGroceries: [Grocery] {
        var filtered = groceries
        
        if selectedCategory != "All" {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return filtered
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                Text(category)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedCategory == category ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundColor(selectedCategory == category ? .white : .primary)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding()
                }
                
                // Grocery List
                if filteredGroceries.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "cart.badge.questionmark")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No groceries found")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        Button("Add Sample Groceries") {
                            addSampleGroceries()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
                            ForEach(filteredGroceries) { grocery in
                                GroceryCardView(grocery: grocery) {
                                    selectedGrocery = grocery
                                    showingDetail = true
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Browse Groceries")
            .searchable(text: $searchText, prompt: "Search groceries")
            .sheet(isPresented: $showingDetail) {
                if let grocery = selectedGrocery {
                    GroceryDetailView(grocery: grocery)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if cartItems.count > 0 {
                        Text("\(cartItems.count) items")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private func addSampleGroceries() {
        let sampleGroceries = [
            Grocery(name: "Red Apples", category: "Fruits", price: 3.99, imageSystemName: "apple.logo", descriptionText: "Fresh, crisp red apples", unit: "lb"),
            Grocery(name: "Bananas", category: "Fruits", price: 2.49, imageSystemName: "leaf", descriptionText: "Ripe yellow bananas", unit: "bunch"),
            Grocery(name: "Strawberries", category: "Fruits", price: 4.99, imageSystemName: "strawberry", descriptionText: "Sweet fresh strawberries", unit: "pint"),
            Grocery(name: "Carrots", category: "Vegetables", price: 1.99, imageSystemName: "carrot", descriptionText: "Fresh organic carrots", unit: "lb"),
            Grocery(name: "Broccoli", category: "Vegetables", price: 2.99, imageSystemName: "leaf.circle", descriptionText: "Fresh green broccoli", unit: "head"),
            Grocery(name: "Tomatoes", category: "Vegetables", price: 3.49, imageSystemName: "circle.fill", descriptionText: "Vine-ripened tomatoes", unit: "lb"),
            Grocery(name: "Milk", category: "Dairy", price: 4.29, imageSystemName: "drop", descriptionText: "Fresh whole milk", unit: "gallon"),
            Grocery(name: "Cheese", category: "Dairy", price: 5.99, imageSystemName: "square.stack.3d.up", descriptionText: "Cheddar cheese block", unit: "lb"),
            Grocery(name: "Yogurt", category: "Dairy", price: 1.99, imageSystemName: "cup.and.saucer", descriptionText: "Greek yogurt", unit: "6oz"),
            Grocery(name: "White Bread", category: "Bakery", price: 2.99, imageSystemName: "square.stack", descriptionText: "Fresh white bread", unit: "loaf"),
            Grocery(name: "Croissants", category: "Bakery", price: 4.99, imageSystemName: "moon", descriptionText: "Butter croissants pack", unit: "pack"),
            Grocery(name: "Chicken Breast", category: "Meat", price: 7.99, imageSystemName: "flame", descriptionText: "Boneless chicken breast", unit: "lb"),
            Grocery(name: "Ground Beef", category: "Meat", price: 6.99, imageSystemName: "flame.fill", descriptionText: "Lean ground beef", unit: "lb"),
            Grocery(name: "Chips", category: "Snacks", price: 3.99, imageSystemName: "rectangle.stack", descriptionText: "Potato chips variety", unit: "bag"),
            Grocery(name: "Cookies", category: "Snacks", price: 4.49, imageSystemName: "circle.hexagongrid", descriptionText: "Chocolate chip cookies", unit: "pack"),
            Grocery(name: "Orange Juice", category: "Beverages", price: 5.49, imageSystemName: "drop.triangle", descriptionText: "Fresh squeezed orange juice", unit: "64oz"),
            Grocery(name: "Bottled Water", category: "Beverages", price: 4.99, imageSystemName: "waterbottle", descriptionText: "Spring water pack", unit: "24-pack"),
        ]
        
        for grocery in sampleGroceries {
            modelContext.insert(grocery)
        }
    }
}

struct GroceryCardView: View {
    let grocery: Grocery
    let onTap: () -> Void
    @Environment(\.modelContext) private var modelContext
    @Query private var cartItems: [CartItem]
    
    @State private var showAddedConfirmation = false
    
    private var isInCart: Bool {
        cartItems.contains { $0.groceryId == grocery.id }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 120)
                
                if let imageName = grocery.imageName, !imageName.isEmpty {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .cornerRadius(8)
                } else {
                    Image(systemName: grocery.imageSystemName)
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                }
            }
            
            // Name
            Text(grocery.name)
                .font(.headline)
                .lineLimit(2)
            
            // Price
            Text("$\(grocery.price, specifier: "%.2f")/\(grocery.unit)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Add to Cart Button
            Button(action: {
                if !isInCart {
                    addToCart()
                }
            }) {
                HStack {
                    Image(systemName: isInCart ? "checkmark.circle.fill" : "cart.badge.plus")
                    Text(isInCart ? "In Cart" : "Add")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(isInCart ? Color.green.opacity(0.2) : Color.blue)
                .foregroundColor(isInCart ? .green : .white)
                .cornerRadius(8)
            }
            .disabled(isInCart)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .onTapGesture {
            onTap()
        }
        .overlay(
            Group {
                if showAddedConfirmation {
                    VStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.green)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(12)
                }
            }
        )
    }
    
    private func addToCart() {
        let cartItem = CartItem(
            groceryId: grocery.id,
            groceryName: grocery.name,
            price: grocery.price,
            quantity: 1,
            unit: grocery.unit
        )
        modelContext.insert(cartItem)
        
        showAddedConfirmation = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showAddedConfirmation = false
        }
    }
}

#Preview {
    GroceryListView()
        .modelContainer(for: [Grocery.self, CartItem.self], inMemory: true)
}
