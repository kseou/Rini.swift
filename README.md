# Rini.swift

**Rini.swift** is a Swift library that provides an interface to Rini originally created by [raysan5](https://github.com/raysan5/rini), a simple, lightweight C-based config init file reader and writer. This Swift wrapper enables easy usage of Rini in a more Swifty manner, offering functionalities for loading, saving, and manipulating configuration files.

## Installation
Add Rini.swift to the dependencies array:

```swift
.package(url: "https://github.com/kseou/Rini.swift.git", branch: "main")
```

The product in your target dependency will need to be:

```swift
.product(name: "Rini", package: "Rini.swift")
```

## Usage

### Creating or Loading Configurations

You can create a new configuration or load one from a file:

```swift
import Rini

// Create a new configuration
let newConfig = Rini(source: .createNew)

// Load configuration from a file
let existingConfig = Rini(source: .loadFromFile("config.ini"))
```

### Getting Config Values

```swift
// Get an integer value for a key
let intValue = existingConfig.config.getValue(for: "some_key")

// Get a text value for a key
let textValue = existingConfig.config.getText(for: "some_key")

// Get a value with fallback if the key doesn't exist
let intValueWithFallback = existingConfig.config.getValue(for: "missing_key", fallback: 42)
```

### Setting Config Values

```swift
// Set an integer value
newConfig.config.setValue(123, for: "new_key", description: "An integer value")

// Set a text value
newConfig.config.setText("Hello, World!", for: "greeting", description: "A greeting message")

// Save the config to a file with a custom header
newConfig.config.save(to: "new_config.ini", header: "# My Custom Config")
```

### Unloading Configurations

Unload the configuration from memory when you're done:

```swift
// Creating or loading .ini files have to be unloaded when no longer used or on application closure.
newConfig.config.unload()
existingConfig.config.unload()
```


This Swift library is built on top of the Rini C library, developed by [raysan5](https://github.com/raysan5/rini).

