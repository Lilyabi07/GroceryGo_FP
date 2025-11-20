//
//  ContentView.swift
//  GroceryGo
//
//  Created on 11/4/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            GroceryListView()
                .tabItem {
                    Label("Browse", systemImage: "list.bullet")
                }
            
            ShoppingListView()
                .tabItem {
                    Label("Shopping List", systemImage: "list.clipboard")
                }
            
            CartView()
                .tabItem {
                    Label("Cart", systemImage: "cart")
                }
            
            StoreFinderView()
                .tabItem {
                    Label("Stores", systemImage: "map")
                }
            
            OrdersView()
                .tabItem {
                    Label("Orders", systemImage: "shippingbox")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Grocery.self, CartItem.self, Order.self, ShoppingListItem.self], inMemory: true)
}
