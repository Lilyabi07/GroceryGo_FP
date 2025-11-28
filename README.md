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


