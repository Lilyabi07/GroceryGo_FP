# Grocery Images

This folder is intended to store custom images for grocery items.

## How to Add Images

1. **In Xcode**: Add images directly to the Asset Catalog
   - Open `Assets.xcassets` in Xcode
   - Create a new Image Set for each grocery item (e.g., "apple", "milk", "carrot")
   - Drag and drop the image files into the appropriate slots

2. **File Naming Convention**: Use lowercase names that match the item (e.g., "apple", "milk", "carrot")

3. **Supported Formats**: PNG, JPG, or other standard image formats

## Using Images in Code

When creating a Grocery item, pass the image name in the `imageName` parameter:

```swift
Grocery(
    name: "Red Apples",
    category: "Fruits",
    price: 3.99,
    imageSystemName: "apple.logo", // Fallback SF Symbol
    imageName: "apple", // Custom image from Assets
    descriptionText: "Fresh, crisp red apples",
    unit: "lb"
)
```

## Fallback Behavior

If `imageName` is:
- `nil` or empty: The app will display the SF Symbol specified in `imageSystemName`
- Set but image not found: The app will fall back to the SF Symbol

This ensures the app works even when custom images are not yet added.

## Recommended Image Sizes

- **Card View**: 160x160 pixels minimum
- **Detail View**: 400x400 pixels or larger for best quality
- **Aspect Ratio**: Square (1:1) or close to square recommended

## Examples

Example image names for common grocery items:
- apple.png
- milk.png
- carrot.png
- banana.png
- cheese.png
- bread.png
- chicken.png
- orange-juice.png

Note: Images will be added in future updates.
