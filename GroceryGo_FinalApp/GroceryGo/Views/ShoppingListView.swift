//
//  ShoppingListView.swift
//  GroceryGo
//
//  Created on 11/4/25.
//

import SwiftUI
import SwiftData

struct ShoppingListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ShoppingListItem.dateAdded, order: .reverse) private var shoppingListItems: [ShoppingListItem]
    
    @State private var newItemName = ""
    @State private var selectedCategory: String? = nil
    @State private var showingAddSheet = false
    
    let categories = ["Fruits", "Vegetables", "Dairy", "Bakery", "Meat", "Snacks", "Beverages"]
    
    var activeItems: [ShoppingListItem] {
        shoppingListItems.filter { !$0.isCompleted }
    }
    
    var completedItems: [ShoppingListItem] {
        shoppingListItems.filter { $0.isCompleted }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if activeItems.isEmpty && completedItems.isEmpty {
                    // Empty state
                    VStack(spacing: 20) {
                        Image(systemName: "list.bullet.clipboard")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No items in your shopping list")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        Text("Add items you want to shop for")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    List {
                        // Active items section
                        if !activeItems.isEmpty {
                            Section(header: Text("To Shop")) {
                                ForEach(activeItems) { item in
                                    ShoppingListItemRow(item: item, onToggle: {
                                        toggleItemCompletion(item)
                                    })
                                }
                                .onDelete { indexSet in
                                    deleteItems(from: activeItems, at: indexSet)
                                }
                            }
                        }
                        
                        // Completed items section
                        if !completedItems.isEmpty {
                            Section(header: Text("Completed")) {
                                ForEach(completedItems) { item in
                                    ShoppingListItemRow(item: item, onToggle: {
                                        toggleItemCompletion(item)
                                    })
                                }
                                .onDelete { indexSet in
                                    deleteItems(from: completedItems, at: indexSet)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Shopping List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    if !shoppingListItems.isEmpty {
                        EditButton()
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddShoppingListItemSheet(
                    itemName: $newItemName,
                    selectedCategory: $selectedCategory,
                    categories: categories,
                    onSave: {
                        addItem()
                    },
                    onCancel: {
                        showingAddSheet = false
                        newItemName = ""
                        selectedCategory = nil
                    }
                )
            }
        }
    }
    
    private func addItem() {
        guard !newItemName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let item = ShoppingListItem(
            name: newItemName.trimmingCharacters(in: .whitespaces),
            category: selectedCategory
        )
        modelContext.insert(item)
        
        newItemName = ""
        selectedCategory = nil
        showingAddSheet = false
    }
    
    private func toggleItemCompletion(_ item: ShoppingListItem) {
        item.isCompleted.toggle()
    }
    
    private func deleteItems(from items: [ShoppingListItem], at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(items[index])
        }
    }
}

struct ShoppingListItemRow: View {
    let item: ShoppingListItem
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.isCompleted ? .green : .gray)
                    .font(.title3)
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.body)
                    .strikethrough(item.isCompleted)
                    .foregroundColor(item.isCompleted ? .secondary : .primary)
                
                if let category = item.category {
                    Text(category)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(4)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct AddShoppingListItemSheet: View {
    @Binding var itemName: String
    @Binding var selectedCategory: String?
    let categories: [String]
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Item Details")) {
                    TextField("Item name", text: $itemName)
                        .textInputAutocapitalization(.words)
                }
                
                Section(header: Text("Category (Optional)")) {
                    Picker("Category", selection: $selectedCategory) {
                        Text("None").tag(nil as String?)
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category as String?)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", action: onCancel)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        onSave()
                    }
                    .disabled(itemName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

#Preview {
    ShoppingListView()
        .modelContainer(for: [ShoppingListItem.self], inMemory: true)
}
