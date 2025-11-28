# GroceryGo - Grocery List and Order App

Final Project Fall 2025, iOS programming with Xcode and Swift

## Overview

GroceryGo is an iOS application that allows users to browse groceries, add them to their cart, and place delivery requests. Built with SwiftUI and SwiftData, it provides an easy-to-use grocery shopping experience.

## Features

✅ **Browse Groceries** - Browse through a categorized list of grocery items
- Filter by category (Fruits, Vegetables, Dairy, Bakery, Meat, Snacks, Beverages)
- Search functionality to quickly find items
- Beautiful card-based UI with SF Symbols and support for custom product images

✅ **Add to Cart** - Add items to your shopping cart
- Quick add from browse screen
- Detailed view with quantity selection
- Visual feedback when items are added

✅ **Edit Quantities** - Manage your cart items
- Increase or decrease quantities
- Real-time price updates
- Swipe to delete items

✅ **View Orders** - Track your order history
- View all past orders
- Order details with item breakdown
- Update order status

✅ **Sheet/Modal Views** - Smooth navigation experience
- Item detail sheets
- Checkout flow
- Order confirmation

✅ **SwiftData Persistence** - All data is persisted locally
- Grocery items
- Cart items
- Order history


## Project Structure

```
GroceryGo/
├── GroceryGo/
│   ├── GroceryGoApp.swift          # App entry point with SwiftData container
│   ├── Models/                      # Data models
│   │   ├── Grocery.swift           # Grocery item model
│   │   ├── CartItem.swift          # Cart item model
│   │   └── Order.swift             # Order model
│   ├── Views/                       # SwiftUI views
│   │   ├── ContentView.swift       # Main tab view
│   │   ├── GroceryListView.swift   # Browse groceries screen
│   │   ├── GroceryDetailView.swift # Item detail modal
│   │   ├── CartView.swift          # Shopping cart screen
│   │   └── OrdersView.swift        # Order history screen
│   ├── ViewModels/                  # View models (if needed)
│   └── Assets.xcassets/            # App icons and images
└── GroceryGo.xcodeproj/            # Xcode project file
```



## Usage

### Browse Groceries
1. Navigate to the **Browse** tab
2. Use category filters to narrow down items
3. Use the search bar to find specific items
4. Tap on any item card to view details
5. Use "Add to Cart" button to add items

### Manage Cart
1. Navigate to the **Cart** tab
2. Use +/- buttons to adjust quantities
3. Swipe left on items to delete them
4. Tap "Proceed to Checkout" when ready

### Place Order
1. Enter your delivery address
2. Review order summary
3. Tap "Place Order"
4. Order will appear in Orders tab

### View Orders
1. Navigate to the **Orders** tab
2. Tap on any order to view details
3. Update order status if needed

## Data Models

### Grocery
- `id`: Unique identifier
- `name`: Item name
- `category`: Category (Fruits, Vegetables, etc.)
- `price`: Price per unit
- `imageSystemName`: SF Symbol name (fallback icon)
- `imageName`: Optional custom image name from Assets (e.g., "apple", "milk", "carrot")
- `descriptionText`: Item description
- `unit`: Unit of measurement (lb, each, gallon, etc.)

### CartItem
- `id`: Unique identifier
- `groceryId`: Reference to grocery item
- `groceryName`: Name of the item
- `price`: Price per unit
- `quantity`: Number of items
- `unit`: Unit of measurement
- `addedDate`: When item was added to cart

### Order
- `id`: Unique identifier
- `orderDate`: When order was placed
- `totalAmount`: Total order amount
- `status`: Order status (Pending, Processing, Shipped, Delivered, Cancelled)
- `deliveryAddress`: Delivery address
- `items`: Array of order items



# Screenshot Content (on scroll)
- Home Screen
- Add to cart
- View Shopping List
- Edit Shopping List
- Add Item to Shopping list (+ Shopping list category)
- View cart
- Update cart (+Updated Cart)
- Place Order (+ Emptied Cart)
-  Add Order Information
- View Order
-  Find Stores on map
-  App run ( 2min video)


#Application Screenshots

## Home Screen

<img width="1206" height="2622" alt="Image" src="https://github.com/user-attachments/assets/1cb344b6-ddcb-4b8b-8fc4-daa988996d9e" />

## Add To Cart

<img width="1206" height="2622" alt="Image" src="https://github.com/user-attachments/assets/59223795-f4cb-4666-a7fa-a0c440fbd770" />

## View Shopping List

<img width="1206" height="2622" alt="Image" src="https://github.com/user-attachments/assets/99259949-f382-4ca4-9867-45b991cf739a" />

## Edit Shopping list

<img width="1206" height="2622" alt="Image" src="https://github.com/user-attachments/assets/edd54bc9-e4c9-40d7-b7fd-2ecee7bc5d01" />

## Add Item to Shopping list

<img width="1206" height="2622" alt="Image" src="https://github.com/user-attachments/assets/061b49bc-e8d3-49d2-96df-885665eedb9b" />

### (+ Shopping list category)


<img width="1206" height="2622" alt="Image" src="https://github.com/user-attachments/assets/1c2983dc-2cb8-4274-8125-5bbf37723641" />

## View Cart

<img width="1206" height="2622" alt="Image" src="https://github.com/user-attachments/assets/a6bf16be-e71e-4492-b075-de276332bcc1" />

## Update Cart

<img width="1206" height="2622" alt="Image" src="https://github.com/user-attachments/assets/741c41ee-78f0-4eca-9a3a-a43279df57fe" />

### (+Updated Cart)

<img width="1206" height="2622" alt="Image" src="https://github.com/user-attachments/assets/ce4bc883-ee62-4bc1-b60a-3ce3bf8ad783" />

## Place Order

<img width="1206" height="2622" alt="Image" src="https://github.com/user-attachments/assets/c29678a8-da6b-40ca-ad2f-5d5e2d6e1a62" />

### (+ Emptied Cart)

<img width="1206" height="2622" alt="Image" src="https://github.com/user-attachments/assets/7fc5d4b2-fd9c-4030-a3ec-4f2215c9b54e" />

## Add Order Information

<img width="1206" height="2622" alt="Image" src="https://github.com/user-attachments/assets/a0959163-9895-41b1-8931-2a8b79c750b3" />

## View Order

<img width="1206" height="2622" alt="Image" src="https://github.com/user-attachments/assets/bb7aef4e-a5e7-45cd-948b-30e0642ec311" />

## Find Stores on map

<img width="1206" height="2622" alt="Image" src="https://github.com/user-attachments/assets/e5c6a8a7-1f1b-4d93-b99f-1b6ec508fe83" />

## App run
https://github.com/user-attachments/assets/887cb18a-fd36-4ebb-95b5-f82d3cfc5584
