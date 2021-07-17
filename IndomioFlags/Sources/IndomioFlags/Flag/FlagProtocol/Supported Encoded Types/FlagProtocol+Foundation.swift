//
//  IndomioFlags
//  Easily manage Feature Flags in Swift
//
//  Created by the Mobile Team @ ImmobiliareLabs
//  Email: mobile@immobiliare.it
//  Web: http://labs.immobiliare.it
//
//  Copyright ©2021 Daniele Margutti. All rights reserved.
//  Licensed under MIT License.
//

import Foundation

// MARK: - Codable

extension Decodable where Self: FlagProtocol, Self: Encodable {
    
    public init?(encoded value: EncodedFlagValue) {
        guard case .data(let data) = value else { return nil }

        do {
            let decoder = JSONDecoder()
            self = try decoder.decode(Self.self, from: data)
        } catch {
            return nil
        }
    }
    
}

extension Encodable where Self: FlagProtocol, Self: Decodable {
    
    public func encoded() -> EncodedFlagValue {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .sortedKeys
            return .data(try encoder.encode(self))
        } catch {
            return .data(Data())
        }
    }
    
}

// MARK: - Array

extension Array: FlagProtocol where Element: FlagProtocol {
    public typealias EncodedValue = [Element.EncodedValue]

    public init?(encoded value: EncodedFlagValue) {
        guard case .array(let array) = value else {
            return nil
        }
        
        self = array.compactMap {
            Element(encoded: $0)
        }
    }

    public func encoded() -> EncodedFlagValue {
        .array(self.map({
            $0.encoded()
        }))
    }
    
}

// MARK: - Dictionary

extension Dictionary: FlagProtocol where Key == String, Value: FlagProtocol {
    public typealias EncodedValue = [String: Value.EncodedValue]

    public init?(encoded value: EncodedFlagValue) {
        guard case .dictionary(let dictionary) = value else {
            return nil
        }
        
        self = dictionary.compactMapValues {
            Value(encoded: $0)
        }
    }

    public func encoded() -> EncodedFlagValue {
        .dictionary(self.mapValues({
            $0.encoded()
        }))
    }
}


// MARK: - Date

extension Date: FlagProtocol {
    public typealias EncodedValue = Date
    
    private static let isoFormatter = ISO8601DateFormatter()

    public init?(encoded value: EncodedFlagValue) {
        guard case .string(let rawDate) = value,
              let date = Date.isoFormatter.date(from: rawDate) else {
            return nil
        }

        self = date
    }

    public func encoded() -> EncodedFlagValue {
        .string(Date.isoFormatter.string(from: self))
    }
    
}

// MARK: - URL

extension URL: FlagProtocol {
    public typealias EncodedValue = Date

    public init?(encoded value: EncodedFlagValue) {
        guard case .string(let value) = value else {
            return nil
        }
        
        self.init(string: value)
    }

    public func encoded() -> EncodedFlagValue {
        .string(self.absoluteString)
    }
    
}
