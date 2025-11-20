//
//  CartView.swift
//  GroceryGo
//
//  Created on 11/4/25.
//

import SwiftUI
import SwiftData

struct CartView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CartItem.addedDate, order: .reverse) private var cartItems: [CartItem]
    
    @State private var showingCheckout = false
    @State private var deliveryAddress = ""
    
    private var totalAmount: Double {
        cartItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if cartItems.isEmpty {
                    // Empty Cart View
                    VStack(spacing: 20) {
                        Image(systemName: "cart")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                        
                        Text("Your cart is empty")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        Text("Add items from the Browse tab")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    // Cart Items List
                    List {
                        ForEach(cartItems) { item in
                            CartItemRow(cartItem: item)
                        }
                        .onDelete(perform: deleteItems)
                        
                        // Summary Section
                        Section {
                            HStack {
                                Text("Subtotal")
                                    .font(.headline)
                                Spacer()
                                Text("$\(totalAmount, specifier: "%.2f")")
                                    .font(.headline)
                            }
                            
                            HStack {
                                Text("Delivery Fee")
                                    .font(.subheadline)
                                Spacer()
                                Text("$\(AppConstants.deliveryFee, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack {
                                Text("Total")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Spacer()
                                Text("$\(totalAmount + AppConstants.deliveryFee, specifier: "%.2f")")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    
                    // Checkout Button
                    Button(action: {
                        showingCheckout = true
                    }) {
                        HStack {
                            Image(systemName: "shippingbox")
                            Text("Proceed to Checkout")
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
                }
            }
            .navigationTitle("Cart")
            .toolbar {
                if !cartItems.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
            }
            .sheet(isPresented: $showingCheckout) {
                CheckoutView(cartItems: cartItems, totalAmount: totalAmount + AppConstants.deliveryFee, deliveryAddress: $deliveryAddress)
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(cartItems[index])
        }
    }
}

struct CartItemRow: View {
    @Bindable var cartItem: CartItem
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        HStack(spacing: 12) {
            // Item Info
            VStack(alignment: .leading, spacing: 4) {
                Text(cartItem.groceryName)
                    .font(.headline)
                
                Text("$\(cartItem.price, specifier: "%.2f")/\(cartItem.unit)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Quantity Controls
            HStack(spacing: 12) {
                Button(action: {
                    if cartItem.quantity > 1 {
                        cartItem.quantity -= 1
                    }
                }) {
                    Image(systemName: "minus.circle")
                        .font(.title3)
                        .foregroundColor(cartItem.quantity > 1 ? .blue : .gray)
                }
                .disabled(cartItem.quantity <= 1)
                
                Text("\(cartItem.quantity)")
                    .font(.headline)
                    .frame(minWidth: 30)
                
                Button(action: {
                    cartItem.quantity += 1
                }) {
                    Image(systemName: "plus.circle")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
            }
            
            // Total Price
            Text("$\(cartItem.totalPrice, specifier: "%.2f")")
                .font(.headline)
                .foregroundColor(.green)
                .frame(minWidth: 60, alignment: .trailing)
        }
        .padding(.vertical, 4)
    }
}

struct CheckoutView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let cartItems: [CartItem]
    let totalAmount: Double
    @Binding var deliveryAddress: String
    
    @State private var showingConfirmation = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Delivery Address") {
                    TextField("Enter your address", text: $deliveryAddress, axis: .vertical)
                        .lineLimit(3...5)
                }
                
                Section("Order Summary") {
                    ForEach(cartItems) { item in
                        HStack {
                            Text(item.groceryName)
                            Spacer()
                            Text("\(item.quantity) × $\(item.price, specifier: "%.2f")")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    HStack {
                        Text("Total")
                            .fontWeight(.bold)
                        Spacer()
                        Text("$\(totalAmount, specifier: "%.2f")")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                }
                
                Section {
                    Button(action: {
                        placeOrder()
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle")
                            Text("Place Order")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .disabled(deliveryAddress.isEmpty)
                }
            }
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Order Placed!", isPresented: $showingConfirmation) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your order has been placed successfully! You can track it in the Orders tab.")
            }
        }
    }
    
    private func placeOrder() {
        // Create order items
        let orderItems = cartItems.map { item in
            OrderItem(groceryName: item.groceryName, quantity: item.quantity, price: item.price, unit: item.unit)
        }
        
        // Create order
        let order = Order(
            totalAmount: totalAmount,
            status: "Pending",
            deliveryAddress: deliveryAddress,
            items: orderItems
        )
        
        modelContext.insert(order)
        
        // Clear cart
        for item in cartItems {
            modelContext.delete(item)
        }
        
        deliveryAddress = ""
        showingConfirmation = true
    }
}

#Preview {
    CartView()
        .modelContainer(for: [CartItem.self, Order.self], inMemory: true)
}
