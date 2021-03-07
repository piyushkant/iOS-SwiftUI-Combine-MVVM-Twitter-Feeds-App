//
//  Keychain.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/07.
//

import Foundation
import Security

// You might want to update this to be something descriptive for your app.
private let service: String = "MyService"

enum Keychain {

    /// Does a certain item exist?
    static func exists(key: String) throws -> Bool {
        let status = SecItemCopyMatching([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrService: service,
            kSecReturnData: false,
            ] as NSDictionary, nil)
        if status == errSecSuccess {
            return true
        } else if status == errSecItemNotFound {
            return false
        } else {
            throw Errors.keychainError
        }
    }
    
    /// Adds an item to the keychain.
    private static func add(value: Data, key: String) throws {
        let status = SecItemAdd([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrService: service,
            // Allow background access:
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
            kSecValueData: value,
            ] as NSDictionary, nil)
        guard status == errSecSuccess else { throw Errors.keychainError }
    }
    
    /// Updates a keychain item.
    private static func update(value: Data, key: String) throws {
        let status = SecItemUpdate([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrService: service,
            ] as NSDictionary, [
            kSecValueData: value,
            ] as NSDictionary)
        guard status == errSecSuccess else { throw Errors.keychainError }
    }
    
    /// Stores a keychain item.
    static func set(value: Data, key: String) throws {
        if try exists(key: key) {
            try update(value: value, key: key)
        } else {
            try add(value: value, key: key)
        }
    }
    
    // If not present, returns nil. Only throws on error.
    static func get(key: String) throws -> Data? {
        var result: AnyObject?
        let status = SecItemCopyMatching([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrService: service,
            kSecReturnData: true,
            ] as NSDictionary, &result)
        if status == errSecSuccess {
            return result as? Data
        } else if status == errSecItemNotFound {
            return nil
        } else {
            throw Errors.keychainError
        }
    }
    
    /// Delete a single item.
    static func delete(key: String) throws {
        let status = SecItemDelete([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrService: service,
            ] as NSDictionary)
        guard status == errSecSuccess else { throw Errors.keychainError }
    }
    
    /// Delete all items for my app. Useful on eg logout.
    static func deleteAll() throws {
        let status = SecItemDelete([
            kSecClass: kSecClassGenericPassword,
            ] as NSDictionary)
        guard status == errSecSuccess else { throw Errors.keychainError }
    }
    
    enum Errors: LocalizedError {
        case keychainError
    }
}
