# GroceryGo Architecture

## App Architecture Overview

GroceryGo follows the MVVM (Model-View-ViewModel) pattern with SwiftData for persistence.

```
┌─────────────────────────────────────────────────────────┐
│                    GroceryGoApp.swift                   │
│                 (App Entry Point)                       │
│              ┌──────────────────┐                       │
│              │ ModelContainer   │                       │
│              │ - Grocery        │                       │
│              │ - CartItem       │                       │
│              │ - Order          │                       │
│              └──────────────────┘                       │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│                   ContentView.swift                     │
│                   (TabView Root)                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────────┐         │
│  │  Browse  │  │   Cart   │  │   Orders     │         │
│  │   Tab    │  │   Tab    │  │    Tab       │         │
│  └──────────┘  └──────────┘  └──────────────┘         │
└─────────────────────────────────────────────────────────┘
       │                │               │
       ▼                ▼               ▼
┌─────────────┐  ┌──────────┐  ┌──────────────┐
│  Grocery    │  │  Cart    │  │   Orders     │
│  List View  │  │  View    │  │   View       │
└─────────────┘  └──────────┘  └──────────────┘
       │                │               │
       ▼                ▼               ▼
┌─────────────┐  ┌──────────┐  ┌──────────────┐
│  Grocery    │  │ Checkout │  │  Order       │
│ Detail View │  │  View    │  │ Detail View  │
│  (Sheet)    │  │ (Sheet)  │  │  (Sheet)     │
└─────────────┘  └──────────┘  └──────────────┘
```

## Data Flow

### Browse to Cart Flow
```
User Browses Grocery List
         ↓
Taps "Add to Cart" on Grocery Card
         ↓
CartItem Created with Grocery Data
         ↓
SwiftData Persists CartItem
         ↓
Cart Tab Updates (via @Query)
```

### Checkout Flow
```
User Edits Cart Quantities
         ↓
Taps "Proceed to Checkout"
         ↓
Enters Delivery Address
         ↓
Confirms Order
         ↓
Order Created with OrderItems
         ↓
Cart Items Deleted
         ↓
Order Saved to SwiftData
         ↓
Orders Tab Updates
```

## Views Detail

### 1. GroceryListView
**Purpose:** Browse and search groceries

**Features:**
- Category filtering (horizontal scroll)
- Search functionality
- Grid layout with cards
- "Add Sample Groceries" button
- Opens GroceryDetailView on tap

**SwiftData Queries:**
- `@Query private var groceries: [Grocery]`
- `@Query private var cartItems: [CartItem]`

### 2. GroceryDetailView (Sheet)
**Purpose:** Show detailed grocery information

**Features:**
- Large image display
- Category badge
- Description
- Quantity selector
- Total price calculation
- Add to cart with quantity
- Shows if already in cart

### 3. CartView
**Purpose:** Manage shopping cart

**Features:**
- List of cart items
- Increase/decrease quantities
- Swipe to delete
- Price summary (subtotal, delivery, total)
- Checkout button
- Opens CheckoutView sheet

**SwiftData Queries:**
- `@Query(sort: \CartItem.addedDate, order: .reverse) private var cartItems: [CartItem]`

### 4. CheckoutView (Sheet)
**Purpose:** Complete the order

**Features:**
- Delivery address input
- Order summary
- Total amount
- Place order button
- Creates Order and clears cart

### 5. OrdersView
**Purpose:** View order history

**Features:**
- List of orders (newest first)
- Status badges with colors
- Order details preview
- Opens OrderDetailView on tap
- Swipe to delete orders

**SwiftData Queries:**
- `@Query(sort: \Order.orderDate, order: .reverse) private var orders: [Order]`

### 6. OrderDetailView (Sheet)
**Purpose:** Show detailed order information

**Features:**
- Order ID, date, time
- Status update menu
- Delivery address
- List of items
- Price breakdown
- Total amount

## SwiftData Models

### Grocery (@Model)
```swift
- id: UUID
- name: String
- category: String
- price: Double
- imageSystemName: String  // SF Symbol for fallback
- imageName: String?       // Optional custom image from Assets
- descriptionText: String
- unit: String
```

### CartItem (@Model)
```swift
- id: UUID
- groceryId: UUID
- groceryName: String
- price: Double
- quantity: Int
- unit: String
- addedDate: Date

Computed:
- totalPrice: Double
```

### Order (@Model)
```swift
- id: UUID
- orderDate: Date
- totalAmount: Double
- status: String
- deliveryAddress: String
- items: [OrderItem]

OrderItem (Codable):
- groceryName: String
- quantity: Int
- price: Double
- unit: String
```

## State Management

### @Environment(\.modelContext)
Used to insert, update, and delete SwiftData models

### @Query
Automatic SwiftData query that updates views when data changes

### @State
Local view state for UI interactions (quantity selectors, sheet presentation)

### @Bindable
Used in child views to bind to model properties for editing

## Navigation Patterns

### Primary Navigation
- **TabView** with 3 tabs (Browse, Cart, Orders)

### Modal Presentations
- **Sheet** for detail views and checkout
- Dismissable with "Close", "Cancel", or "Done" buttons

### List Interactions
- **Tap** to view details
- **Swipe** to delete
- **EditButton** for delete mode

## UI Components

### Reusable Components
- `GroceryCardView` - Displays grocery in grid
- `CartItemRow` - Displays cart item with controls
- `OrderRowView` - Displays order in list

### Design Elements
- SF Symbols for all icons
- System colors (blue, green, gray)
- Rounded corners (8-20pt)
- Shadows for depth
- Color-coded status badges

## Data Persistence

All data is persisted using SwiftData:
- **Automatic**: Changes are saved automatically
- **Local**: Data stored on device
- **Queryable**: Use @Query for reactive updates
- **Relational**: Can reference between models

## Sample Data

The app includes a function to add 17 sample groceries across all categories:
- Fruits (3 items)
- Vegetables (3 items)
- Dairy (3 items)
- Bakery (2 items)
- Meat (2 items)
- Snacks (2 items)
- Beverages (2 items)

This can be triggered from the GroceryListView when the list is empty.

## Future Enhancements

Potential features to add:
- User authentication
- Cloud sync with iCloud
- ✅ Product images (not just SF Symbols) - Infrastructure added, images can be added to Assets
- Favorites/Wishlist
- Price history and deals
- Barcode scanning
- Recipe suggestions
- Multiple delivery addresses
- Payment integration
- Push notifications for order status
- Order tracking map
