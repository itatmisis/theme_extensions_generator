# Deep Copy Functionality

## Overview

The deep copy functionality is an enhancement to the existing `@ThemeProperty.styled()` annotation. It allows for seamless customization of nested theme hierarchies through a single decoration object with automatic deep merging.

## Why This Enhancement Was Added

**Previous Behavior:** The `@ThemeProperty.styled()` annotation already existed for nested themes, but required manual deep merging:
- Decoration classes contained full theme types (e.g., `ChildTheme?`)
- Manual deep merging was required in widget code
- Multiple decoration parameters for complex nested structures

**Enhanced Behavior:** With `enableDeepCopy: true`, the annotation now provides:
- Decoration classes use decoration types (e.g., `ChildThemeDecoration?`)
- Automatic deep merging handled by the generator
- Single decoration parameter can customize entire theme hierarchy

## Basic Example

### Theme Definition

```dart
import 'package:flutter/material.dart';
import 'package:theme_extensions_annotation/theme_extension_annotation.dart';

part 'app_theme.g.dart';

// Nested button theme
@ThemeExtended.themeOnly()
class AppButtonTheme with _$AppButtonTheme {
  const factory AppButtonTheme({
    @ThemeProperty()
    required Color backgroundColor,
    @ThemeProperty()
    required Color textColor,
    @ThemeProperty()
    required double borderRadius,
  }) = _AppButtonTheme;
}

// Main application theme with nested button themes
@ThemeExtended()
class AppTheme with _$AppTheme {
  const factory AppTheme({
    @ThemeProperty()
    required Color primaryColor,
    @ThemeProperty.styled()  // Enables deep copy functionality
    required AppButtonTheme primaryButton,
    @ThemeProperty.styled()
    required AppButtonTheme secondaryButton,
  }) = _AppTheme;
}
```

### Generated Code Structure

The generator automatically creates:

```dart
// Decoration for nested theme - all fields optional
class AppButtonThemeDecoration {
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  
  const AppButtonThemeDecoration({
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
  });
}

// Main theme decoration - uses decoration types for nested objects
class AppThemeDecoration {
  final Color? primaryColor;
  final AppButtonThemeDecoration? primaryButton;    // Uses decoration type!
  final AppButtonThemeDecoration? secondaryButton; // Not full theme type
  
  const AppThemeDecoration({
    this.primaryColor,
    this.primaryButton,
    this.secondaryButton,
  });
}
```

### Widget Usage

#### Before (Complex Approach)

```dart
class CustomButton extends StatelessWidget {
  final AppButtonThemeDecoration? primaryDecoration;
  final AppButtonThemeDecoration? secondaryDecoration;
  
  const CustomButton({
    super.key,
    this.primaryDecoration,
    this.secondaryDecoration,
  });

  @override
  Widget build(BuildContext context) {
    // Complex manual merging
    var theme = Theme.of(context).appThemeExtension;
    theme = theme.copyWithDecoration(AppThemeDecoration(
      primaryButton: theme.primaryButton.copyWithDecoration(primaryDecoration),
      secondaryButton: theme.secondaryButton.copyWithDecoration(secondaryDecoration),
    ));
    
    // ... widget implementation
  }
}
```

#### After (Simple Approach)

```dart
class CustomButton extends StatelessWidget {
  final AppThemeDecoration? decoration; // Single parameter!
  
  const CustomButton({
    super.key,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    // Simple one-liner with automatic deep merge
    var theme = Theme.of(context).appThemeExtension
        .copyWithDecoration(decoration);
    
    // ... widget implementation
  }
}
```

## Usage Examples

### 1. Customize Only Primary Button Color

```dart
CustomButton(
  decoration: AppThemeDecoration(
    primaryButton: AppButtonThemeDecoration(
      backgroundColor: Colors.green,
      // All other fields remain unchanged
    ),
  ),
)
```

### 2. Customize Multiple Nested Properties

```dart
CustomButton(
  decoration: AppThemeDecoration(
    primaryColor: Colors.blue,
    primaryButton: AppButtonThemeDecoration(
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    ),
    secondaryButton: AppButtonThemeDecoration(
      borderRadius: 12.0,
    ),
  ),
)
```

### 3. Partial Customization

```dart
CustomButton(
  decoration: AppThemeDecoration(
    // Only customize secondary button
    secondaryButton: AppButtonThemeDecoration(
      backgroundColor: Colors.grey,
    ),
    // Primary button and other properties remain unchanged
  ),
)
```

## How It Works

1. **Decoration Type Generation**: For fields marked with `@ThemeProperty.styled(enableDeepCopy: true)`, the generator creates corresponding decoration types instead of using full theme types
2. **Deep Merge Logic**: The `copyWithDecoration` method automatically performs recursive merging for styled fields
3. **Null Handling**: Null decoration objects are handled gracefully - unchanged objects maintain reference equality for performance

## Key Benefits

- **Simplified API**: Single decoration parameter instead of multiple nested parameters
- **Type Safety**: Compile-time validation of decoration structure
- **Performance**: Unchanged nested objects maintain reference equality
- **Maintainability**: Less boilerplate code in widgets
- **Flexibility**: Customize any field at any nesting level with one object

## Backward Compatibility

This feature is fully backward compatible. Existing themes with `@ThemeProperty.styled()` continue to work exactly as before:

### Before (Still Works)
```dart
@ThemeProperty.styled()  // Default behavior unchanged
required ChildTheme childTheme,

// Generates:
class ParentDecoration {
  final ChildTheme? childTheme;  // Full theme type
}

// Simple override:
childTheme: decoration?.childTheme ?? this.childTheme,
```

### Enhanced (Opt-in)
```dart
@ThemeProperty.styled(enableDeepCopy: true)  // New enhanced behavior
required ChildTheme childTheme,

// Generates:
class ParentDecoration {
  final ChildThemeDecoration? childTheme;  // Decoration type
}

// Deep merge:
childTheme: decoration?.childTheme != null 
    ? this.childTheme.copyWithDecoration(decoration!.childTheme) 
    : this.childTheme,
```
