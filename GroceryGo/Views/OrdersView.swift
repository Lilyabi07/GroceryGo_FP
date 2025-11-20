//
//  OrdersView.swift
//  GroceryGo
//
//  Created on 11/4/25.
//

import SwiftUI
import SwiftData

struct OrdersView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Order.orderDate, order: .reverse) private var orders: [Order]
    
    @State private var selectedOrder: Order?
    @State private var showingDetail = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if orders.isEmpty {
                    // Empty Orders View
                    VStack(spacing: 20) {
                        Image(systemName: "shippingbox")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                        
                        Text("No orders yet")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        Text("Your order history will appear here")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    List {
                        ForEach(orders) { order in
                            OrderRowView(order: order)
                                .onTapGesture {
                                    selectedOrder = order
                                    showingDetail = true
                                }
                        }
                        .onDelete(perform: deleteOrders)
                    }
                }
            }
            .navigationTitle("Orders")
            .toolbar {
                if !orders.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
            }
            .sheet(isPresented: $showingDetail) {
                if let order = selectedOrder {
                    OrderDetailView(order: order)
                }
            }
        }
    }
    
    private func deleteOrders(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(orders[index])
        }
    }
}

struct OrderRowView: View {
    let order: Order
    
    private var statusColor: Color {
        switch order.status {
        case "Pending":
            return .orange
        case "Delivered":
            return .green
        case "Cancelled":
            return .red
        default:
            return .blue
        }
    }
    
    private var statusIcon: String {
        switch order.status {
        case "Pending":
            return "clock"
        case "Delivered":
            return "checkmark.circle"
        case "Cancelled":
            return "xmark.circle"
        default:
            return "shippingbox"
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Status Icon
            Image(systemName: statusIcon)
                .font(.title2)
                .foregroundColor(statusColor)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 6) {
                // Order ID
                Text("Order #\(order.id.uuidString.prefix(8))")
                    .font(.headline)
                
                // Date
                Text(order.orderDate, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Items count
                Text("\(order.items.count) item\(order.items.count == 1 ? "" : "s")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 6) {
                // Total Amount
                Text("$\(order.totalAmount, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.green)
                
                // Status Badge
                Text(order.status)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.2))
                    .foregroundColor(statusColor)
                    .cornerRadius(8)
            }
        }
        .padding(.vertical, 4)
    }
}

struct OrderDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var order: Order
    
    var body: some View {
        NavigationStack {
            List {
                Section("Order Information") {
                    HStack {
                        Text("Order ID")
                        Spacer()
                        Text("#\(order.id.uuidString.prefix(8))")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Date")
                        Spacer()
                        Text(order.orderDate, style: .date)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Time")
                        Spacer()
                        Text(order.orderDate, style: .time)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Status")
                        Spacer()
                        Menu {
                            Button("Pending") { order.status = "Pending" }
                            Button("Processing") { order.status = "Processing" }
                            Button("Shipped") { order.status = "Shipped" }
                            Button("Delivered") { order.status = "Delivered" }
                            Button("Cancelled") { order.status = "Cancelled" }
                        } label: {
                            Text(order.status)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(statusColor.opacity(0.2))
                                .foregroundColor(statusColor)
                                .cornerRadius(8)
                        }
                    }
                }
                
                Section("Delivery Address") {
                    Text(order.deliveryAddress.isEmpty ? "No address provided" : order.deliveryAddress)
                }
                
                Section("Items") {
                    ForEach(order.items, id: \.groceryName) { item in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.groceryName)
                                    .font(.headline)
                                Text("\(item.quantity) × $\(item.price, specifier: "%.2f")/\(item.unit)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Text("$\(item.totalPrice, specifier: "%.2f")")
                                .font(.headline)
                                .foregroundColor(.green)
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Section("Order Summary") {
                    HStack {
                        Text("Subtotal")
                        Spacer()
                        Text("$\(order.totalAmount - AppConstants.deliveryFee, specifier: "%.2f")")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Delivery Fee")
                        Spacer()
                        Text("$\(AppConstants.deliveryFee, specifier: "%.2f")")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Total")
                            .fontWeight(.bold)
                        Spacer()
                        Text("$\(order.totalAmount, specifier: "%.2f")")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                }
            }
            .navigationTitle("Order Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var statusColor: Color {
        switch order.status {
        case "Pending":
            return .orange
        case "Delivered":
            return .green
        case "Cancelled":
            return .red
        default:
            return .blue
        }
    }
}

#Preview {
    OrdersView()
        .modelContainer(for: Order.self, inMemory: true)
}
