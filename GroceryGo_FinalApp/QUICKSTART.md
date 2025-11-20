# GroceryGo Quick Start Guide

## For Developers

### Prerequisites
- macOS Ventura (13.0) or later
- Xcode 15.0 or later
- iOS 17.0 SDK

### Setup (First Time)

1. **Clone the repository**
   ```bash
   git clone https://github.com/Lilyabi07/GroceryGo.git
   cd GroceryGo
   ```

2. **Open in Xcode**
   ```bash
   open GroceryGo.xcodeproj
   ```
   
   Or double-click `GroceryGo.xcodeproj` in Finder

3. **Select your target**
   - Choose an iOS Simulator (iPhone 15 Pro recommended) or physical device
   - Click the device selector in the toolbar

4. **Build and Run**
   - Press `⌘ + R` (Cmd + R)
   - Or click the Play button (▶️) in the toolbar

### First Launch Experience

On first launch, you'll see:
- **Browse Tab**: Empty state with "Add Sample Groceries" button
- **Cart Tab**: Empty cart message
- **Orders Tab**: Empty orders message

**Recommended First Steps:**
1. Tap "Add Sample Groceries" to populate with 17 items
2. Browse through different categories
3. Add items to cart
4. Go to Cart tab and edit quantities
5. Complete checkout with a test address
6. View your order in the Orders tab

## For Testers

### Test Scenarios

#### Scenario 1: Browse and Add to Cart
1. Launch app
2. Tap "Add Sample Groceries" button
3. Select different categories (Fruits, Vegetables, etc.)
4. Use search bar to find specific items
5. Tap on an item to see details
6. Adjust quantity and tap "Add to Cart"
7. Verify item appears in Cart tab

#### Scenario 2: Cart Management
1. Go to Cart tab
2. Use +/- buttons to adjust quantities
3. Verify prices update in real-time
4. Swipe left to delete an item
5. Verify cart total updates correctly

#### Scenario 3: Complete Purchase
1. Have items in cart
2. Tap "Proceed to Checkout"
3. Enter a delivery address
4. Review order summary
5. Tap "Place Order"
6. Verify order appears in Orders tab
7. Verify cart is now empty

#### Scenario 4: Order History
1. Go to Orders tab
2. Tap on an order to see details
3. Tap on status to change it
4. Verify status color updates
5. Verify all order details are correct

### Test Data

**Sample Groceries Added:**
- **Fruits**: Red Apples ($3.99/lb), Bananas ($2.49/bunch), Strawberries ($4.99/pint)
- **Vegetables**: Carrots ($1.99/lb), Broccoli ($2.99/head), Tomatoes ($3.49/lb)
- **Dairy**: Milk ($4.29/gallon), Cheese ($5.99/lb), Yogurt ($1.99/6oz)
- **Bakery**: White Bread ($2.99/loaf), Croissants ($4.99/pack)
- **Meat**: Chicken Breast ($7.99/lb), Ground Beef ($6.99/lb)
- **Snacks**: Chips ($3.99/bag), Cookies ($4.49/pack)
- **Beverages**: Orange Juice ($5.49/64oz), Bottled Water ($4.99/24-pack)

**Delivery Fee:** $5.99 (fixed)

## Development Tips

### Code Organization
- **Models** are in `GroceryGo/Models/`
- **Views** are in `GroceryGo/Views/`
- **Main app** is `GroceryGoApp.swift`

### SwiftData
- All models use `@Model` macro
- Use `@Query` in views to fetch data
- Use `modelContext` to insert/delete

### Adding New Features

**To add a new grocery:**
```swift
let newGrocery = Grocery(
    name: "Item Name",
    category: "Category",
    price: 5.99,
    imageSystemName: "cart",
    descriptionText: "Description",
    unit: "each"
)
modelContext.insert(newGrocery)
```

**To modify a view:**
1. Locate the view file in `GroceryGo/Views/`
2. Make your changes
3. Use `#Preview` to see changes live

### Debugging

**Enable SwiftData Logging:**
Add to your scheme's run arguments:
```
-com.apple.CoreData.SQLDebug 1
```

**Common Issues:**
- If data doesn't persist: Check model definition
- If preview doesn't work: Ensure preview container uses `inMemory: true`
- If build fails: Clean build folder (⌘ + Shift + K)

### Customization

**Change Colors:**
Edit in `Assets.xcassets/AccentColor.colorset/`

**Change App Icon:**
Add images to `Assets.xcassets/AppIcon.appiconset/`

**Modify Categories:**
Edit the `categories` array in `GroceryListView.swift`

## Xcode Shortcuts

- **Build**: `⌘ + B`
- **Run**: `⌘ + R`
- **Stop**: `⌘ + .`
- **Clean Build**: `⌘ + Shift + K`
- **Show Preview**: `⌘ + Option + Return`
- **Format Code**: `Control + I`

## Troubleshooting

### Simulator Issues
**Problem:** Simulator is slow
**Solution:** Use iPhone 15 Pro simulator (optimized) or physical device

**Problem:** Preview not working
**Solution:** Press `⌘ + Option + P` to refresh preview

### Build Issues
**Problem:** "No such module 'SwiftData'"
**Solution:** Set deployment target to iOS 17.0+

**Problem:** Xcode can't find files
**Solution:** 
1. Clean build folder
2. Restart Xcode
3. Verify file references in project navigator

### Data Issues
**Problem:** Data not persisting
**Solution:** Check that models have `@Model` macro and are added to ModelContainer schema

**Problem:** Duplicate entries
**Solution:** Check that you're not inserting the same item twice

## Resources

### Official Documentation
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [SwiftData Documentation](https://developer.apple.com/documentation/swiftdata)
- [SF Symbols App](https://developer.apple.com/sf-symbols/)

### Learning Resources
- Apple's SwiftUI Tutorials
- WWDC Videos on SwiftData
- Swift.org Documentation

## Support

For issues or questions:
1. Check this guide
2. Check ARCHITECTURE.md for design details
3. Review code comments in source files
4. Open an issue on GitHub

## Next Steps

After getting the app running:
1. Explore the code structure
2. Try modifying a view
3. Add a new grocery category
4. Customize the UI colors
5. Add new features!

Happy coding! 🎉
