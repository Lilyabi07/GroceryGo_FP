//
//  GroceryDetailView.swift
//  GroceryGo
//
//  Created on 11/4/25.
//

import SwiftUI
import SwiftData

struct GroceryDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var cartItems: [CartItem]
    
    let grocery: Grocery
    @State private var quantity: Int = 1
    
    private var isInCart: Bool {
        cartItems.contains { $0.groceryId == grocery.id }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Image
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 250)
                        
                        if let imageName = grocery.imageName, !imageName.isEmpty {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 230)
                                .cornerRadius(16)
                        } else {
                            Image(systemName: grocery.imageSystemName)
                                .font(.system(size: 100))
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        // Name
                        Text(grocery.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        // Category
                        Text(grocery.category)
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                        
                        // Price
                        Text("$\(grocery.price, specifier: "%.2f") per \(grocery.unit)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                        
                        Divider()
                            .padding(.vertical, 8)
                        
                        // Description
                        Text("Description")
                            .font(.headline)
                        
                        Text(grocery.descriptionText.isEmpty ? "Fresh and high quality product." : grocery.descriptionText)
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Divider()
                            .padding(.vertical, 8)
                        
                        // Quantity Selector
                        if !isInCart {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Quantity")
                                    .font(.headline)
                                
                                HStack(spacing: 20) {
                                    Button(action: {
                                        if quantity > 1 {
                                            quantity -= 1
                                        }
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .font(.system(size: 30))
                                            .foregroundColor(quantity > 1 ? .blue : .gray)
                                    }
                                    .disabled(quantity <= 1)
                                    
                                    Text("\(quantity)")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .frame(minWidth: 50)
                                    
                                    Button(action: {
                                        quantity += 1
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 30))
                                            .foregroundColor(.blue)
                                    }
                                }
                                
                                Text("Total: $\(Double(quantity) * grocery.price, specifier: "%.2f")")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.green)
                                    .padding(.top, 8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 100)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                if !isInCart {
                    Button(action: {
                        addToCart()
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "cart.badge.plus")
                            Text("Add \(quantity) to Cart")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                    .background(Color(.systemBackground))
                } else {
                    VStack {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Already in Cart")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .foregroundColor(.green)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                    .background(Color(.systemBackground))
                }
            }
        }
    }
    
    private func addToCart() {
        let cartItem = CartItem(
            groceryId: grocery.id,
            groceryName: grocery.name,
            price: grocery.price,
            quantity: quantity,
            unit: grocery.unit
        )
        modelContext.insert(cartItem)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Grocery.self, CartItem.self, configurations: config)
    
    let sampleGrocery = Grocery(
        name: "Red Apples",
        category: "Fruits",
        price: 3.99,
        imageSystemName: "apple.logo",
        descriptionText: "Fresh, crisp red apples from local farms.",
        unit: "lb"
    )
    
    return GroceryDetailView(grocery: sampleGrocery)
        .modelContainer(container)
}
