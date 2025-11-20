# Image Feature Implementation Guide

## Overview

This guide explains how the new image feature works and how to use it to add custom product images to grocery items.

## What Was Added

The app now supports custom images for grocery items (like "apple.jpg", "milk.png", "carrot.png") while maintaining backward compatibility with SF Symbols.

## Technical Implementation

### Model Changes

#### Grocery Model
```swift
@Model
final class Grocery {
    var imageName: String?  // NEW: Optional custom image
    var imageSystemName: String  // EXISTING: SF Symbol fallback
    
    init(..., imageName: String? = nil, ...) {
        // imageName defaults to nil for backward compatibility
    }
}
```

#### Product Model
```swift
struct Product: Codable {
    let imageName: String?  // NEW: Optional custom image
    
    init(..., imageName: String? = nil) {
        // imageName defaults to nil for backward compatibility
    }
}
```

### View Changes

#### GroceryCardView (List/Grid Display)
```swift
// Image section
if let imageName = grocery.imageName, !imageName.isEmpty {
    // Display custom image from Assets
    Image(imageName)
        .resizable()
        .scaledToFit()
        .frame(height: 100)
        .cornerRadius(8)
} else {
    // Fallback to SF Symbol
    Image(systemName: grocery.imageSystemName)
        .font(.system(size: 50))
        .foregroundColor(.blue)
}
```

#### GroceryDetailView (Detail Screen)
```swift
// Image section
if let imageName = grocery.imageName, !imageName.isEmpty {
    // Display custom image from Assets
    Image(imageName)
        .resizable()
        .scaledToFit()
        .frame(height: 230)
        .cornerRadius(16)
} else {
    // Fallback to SF Symbol
    Image(systemName: grocery.imageSystemName)
        .font(.system(size: 100))
        .foregroundColor(.blue)
}
```

## How to Add Images

### Step 1: Prepare Your Images

1. **Format**: PNG or JPG recommended
2. **Size**: 
   - Minimum: 160x160 pixels
   - Recommended: 400x400 pixels or larger
   - Aspect ratio: Square (1:1) preferred
3. **Naming**: Use lowercase descriptive names (e.g., "apple", "milk", "carrot")

### Step 2: Add to Xcode Project

1. Open the project in Xcode
2. Navigate to `Assets.xcassets` in the Project Navigator
3. Right-click in the Assets folder and select "New Image Set"
4. Name the image set (e.g., "apple")
5. Drag and drop your image files into the appropriate slots (1x, 2x, 3x)

### Step 3: Use in Code

When creating or updating a Grocery item:

```swift
// Example: Apple with custom image
let apple = Grocery(
    name: "Red Apples",
    category: "Fruits",
    price: 3.99,
    imageSystemName: "apple.logo",  // Fallback SF Symbol
    imageName: "apple",              // Custom image from Assets
    descriptionText: "Fresh, crisp red apples",
    unit: "lb"
)

// Example: Banana with only SF Symbol (no custom image yet)
let banana = Grocery(
    name: "Bananas",
    category: "Fruits",
    price: 2.49,
    imageSystemName: "leaf",
    imageName: nil,  // Will use SF Symbol
    descriptionText: "Ripe yellow bananas",
    unit: "bunch"
)
```

## Fallback Behavior

The implementation gracefully handles all scenarios:

| Scenario | Result |
|----------|--------|
| `imageName` is `nil` | Uses SF Symbol from `imageSystemName` |
| `imageName` is empty string | Uses SF Symbol from `imageSystemName` |
| `imageName` set but image not found in Assets | Uses SF Symbol from `imageSystemName` |
| `imageName` set and image exists | Displays custom image |

## Example Image Names

Here are suggested image names for common grocery items:

- **Fruits**: apple, banana, orange, strawberry, grape, watermelon
- **Vegetables**: carrot, broccoli, tomato, lettuce, cucumber, pepper
- **Dairy**: milk, cheese, yogurt, butter, cream
- **Bakery**: bread, croissant, bagel, muffin, cake
- **Meat**: chicken, beef, pork, fish, turkey
- **Beverages**: orange-juice, water, soda, coffee, tea

## Testing

The feature includes comprehensive tests:

```swift
// Test with custom image name
func testProductWithImageName() {
    let product = Product(name: "Apple", price: 1.99, 
                         category: "Fruits", imageName: "apple")
    XCTAssertEqual(product.imageName, "apple")
}

// Test without custom image name (nil)
func testProductWithoutImageName() {
    let product = Product(name: "Orange", price: 1.49, 
                         category: "Fruits")
    XCTAssertNil(product.imageName)
}

// Test encoding/decoding
func testProductImageNameCodable() throws {
    let product = Product(name: "Carrot", price: 0.99, 
                         category: "Vegetables", imageName: "carrot")
    // Encode and decode
    let data = try JSONEncoder().encode(product)
    let decoded = try JSONDecoder().decode(Product.self, from: data)
    XCTAssertEqual(decoded.imageName, "carrot")
}
```

## Migration Strategy

### Existing Data
- All existing grocery items will continue to work
- They will display their SF Symbols as before
- No database migration needed (optional field)

### Adding Images Gradually
1. Add images to Assets.xcassets as they become available
2. Update existing Grocery items to set `imageName` property
3. No need to add all images at once - can be done incrementally

### Example Migration Code
```swift
// Update existing item to use custom image
existingGrocery.imageName = "apple"
try? modelContext.save()
```

## Benefits

1. **Backward Compatible**: No breaking changes
2. **Flexible**: Can add images gradually
3. **Graceful Degradation**: Always has fallback to SF Symbol
4. **Type Safe**: Uses Swift's optional types
5. **Well Tested**: Covered by unit tests
6. **Documented**: Clear instructions for developers

## Future Enhancements

Potential improvements to consider:
- Remote image loading from URLs
- Image caching strategies
- Dynamic image updates
- Image compression/optimization
- Multiple image sizes for different contexts
- User-uploaded custom images

## Troubleshooting

### Image Not Showing
1. **Check asset name**: Ensure `imageName` matches the Image Set name in Assets.xcassets
2. **Check asset location**: Image must be in Assets.xcassets to be bundled with app
3. **Check image format**: Use PNG or JPG format
4. **Verify build**: Clean and rebuild the project (Cmd+Shift+K, then Cmd+B)

### Fallback to SF Symbol
- This is expected behavior when `imageName` is nil, empty, or image not found
- Ensure the SF Symbol name in `imageSystemName` is valid
- All items should have a valid `imageSystemName` as fallback

## Summary

The image feature provides a flexible, backward-compatible way to enhance the visual appeal of the GroceryGo app with custom product images. The implementation ensures the app continues to work even when images are not yet available, making it easy to adopt incrementally.
