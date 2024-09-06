//
//  Rini.swift
//
//
//  Created by kseou on 01/09/2024.
//

import RiniC

// rini_config type
@_exported import struct RiniC.rini_config


public enum RiniConfigSource {
    case createNew
    case loadFromFile(String)
}

public struct Rini {
    public var config: RiniC.rini_config
    
    @inlinable
    public static var riniVersion: String {
        return RINI_VERSION
    }
    
    public init(source: RiniConfigSource) {
        switch source {
        case .createNew:
            self.config = RiniC.rini_load_config(nil)
        case .loadFromFile(let fileName):
            self.config = fileName.withCString { fileNameCString in
                RiniC.rini_load_config(fileNameCString)
            }
        }
    }
}

public extension rini_config {
    
    // MARK: Configuration Management
    
    /// Unload configuration data from memory
    @inlinable
    mutating func unload() {
        RiniC.rini_unload_config(&self)
    }
    
    /// Save configuration to a file with a custom header
    @inlinable
    mutating func save(to fileName: String, header: String) {
        fileName.withCString { fileNameCString in
            header.withCString { headerCString in
                RiniC.rini_save_config(self, fileNameCString, headerCString)
            }
        }
    }
    
    // MARK: Value Retrieval
    
    /// Get config value int for provided key, returns 0 if not found
    @inlinable
    func getValue(for key: String) -> Int32 {
        return key.withCString { cString in
                return RiniC.rini_get_config_value(self, cString)
            }
    }
    
    /// Save config to file, with custom header
    @inlinable
    func getText(for key: String) -> String? {
        return key.withCString { keyCString in
            if let textPointer = RiniC.rini_get_config_value_text(self, keyCString) {
                return String(cString: textPointer)
            }
            return nil
        }
    }
    
    /// Get config value for provided key with default value fallback if not found or not valid
    @inlinable
    func getDescription(for key: String) -> String? {
        return key.withCString { keyCString in
            if let descPointer = RiniC.rini_get_config_value_description(self, keyCString) {
                return String(cString: descPointer)
            }
            // Explicitly return nil if descPointer is nil
            return nil
        }
    }
    
    /// Get config value for provided key with default value fallback if not found or not valid
    @inlinable
    func getValue(for key: String, fallback: Int32) -> Int32 {
        return key.withCString { keyCString in
            return RiniC.rini_get_config_value_fallback(self, keyCString, fallback)
        }
    }
    
    /// Get config value text for provided key with fallback if not found or not valid
    @inlinable
    func getValue(for key: String, fallback: String) -> String? {
        return key.withCString { keyCString in
            fallback.withCString { fallbackCString in
                // Call the C function and handle the result
                if let textPointer = RiniC.rini_get_config_value_text_fallback(self, keyCString, fallbackCString) {
                    // Return the result as a String if textPointer is not nil
                    return String(cString: textPointer)
                }
                // Return the fallback value if textPointer is nil
                return fallback
            }
        }
    }
    
    // MARK: Value Setting
    
    /// Set config value int/text and description for existing key or create a new entry
    @inlinable
    mutating func setValue(_ value: Int32, for key: String, description: String) {
        key.withCString { keyCString in
            description.withCString { descCString in
                RiniC.rini_set_config_value(&self, keyCString, value, descCString)
            }
        }
    }
    
    /// Set config value int/text and description for existing key or create a new entry
    @inlinable
    mutating func setText(_ text: String, for key: String, description: String) {
        key.withCString { keyCString in
            text.withCString { textCString in
                description.withCString { descCString in
                    RiniC.rini_set_config_value_text(&self, keyCString, textCString, descCString)
                }
            }
        }
    }
    
    /// Set config value description for existing key
    @inlinable
    mutating func setConfigValueDescription(_ description: String, for key: String) {
        key.withCString { keyCString in
            description.withCString { descCString in
                RiniC.rini_set_config_value_description(&self, keyCString, descCString)
            }
        }
    }
}
