//
//  PhotoUserInfoModel.swift
//  FlickGallery
//
//  Created by Sandhya on 02/06/2024.
//

/*The response model of flickr.photos.getInfo */
import Foundation

// MARK: - UserInfoResponse
struct UserInfoResponse: Codable {
    let photo: PhotoInfo
    let stat: String
}

// MARK: - PhotoInfo
struct PhotoInfo: Codable  {
   
    let id, secret, server: String?
    let farm: Int
    let dateuploaded: String
    let isfavorite: Int
    let license: String
    let safetyLevel: String?
    let rotation: Int
    let originalsecret, originalformat: String?
    let owner: Owner
    let title, description: Comments
    let visibility: Geoperms
    let dates: Dates
    let views: String
    let editability, publiceditability: Editability
    let usage: Usage
    let comments: Comments
    let notes: Notes?
    let people: People?
    let tags: Tags?
    let location: Location?
    let geoperms: Geoperms?
    let urls: Urls
    let media: String
    
    enum CodingKeys: String, CodingKey {
        case id, secret, server, farm, dateuploaded, isfavorite, license
        case safetyLevel
        case rotation, originalsecret, originalformat, owner, title, description, visibility, dates, views, editability, publiceditability, usage, comments, notes, people, tags, location, geoperms, urls, media
    }
}

// MARK: - Comments
struct Comments: Codable {
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case content = "_content"
    }
}

// MARK: - Dates
struct Dates: Codable {
    let posted, taken: String
    let takengranularity: Int
    let takenunknown, lastupdate: String
}

// MARK: - Editability
struct Editability: Codable {
    let cancomment, canaddmeta: Int
}

// MARK: - Geoperms
struct Geoperms: Codable {
    let ispublic: Int
    let iscontact: Int?
    let isfriend, isfamily: Int
}

// MARK: - Location
struct Location: Codable {
    let latitude, longitude, accuracy, context: String?
    let locality, county, region, country: Comments?
    let neighbourhood: Comments?
}

// MARK: - Notes
struct Notes: Codable {
    let note: [JSONAny]
}

// MARK: - Owner
struct Owner: Codable {
    let nsid, username, realname, location: String?
    let iconserver: String
    let iconfarm: Int
    let pathAlias: JSONNull?
    
    
    enum CodingKeys: String, CodingKey {
        case nsid, username, realname, location, iconserver, iconfarm
        case pathAlias
        
    }
}

// MARK: - People
struct People: Codable {
    let haspeople: Int
}

// MARK: - Tags
struct Tags: Codable {
    let tag: [Tag]
}

//// MARK: - Tag
struct Tag: Codable {
    let id, author, authorname, raw: String?
    let content: String?
    let machineTag: Int?

    enum CodingKeys: String, CodingKey {
        case id, author, authorname, raw
        case content = "_content"
        case machineTag
    }
}

// MARK: - Urls
struct Urls: Codable {
    let url: [URLElement]
}

// MARK: - URLElement
struct URLElement: Codable {
    let type: String
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case type
        case content = "_content"
    }
}

// MARK: - Usage
struct Usage: Codable {
    let candownload, canblog, canprint, canshare: Int
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public func hash(into hasher: inout Hasher) {
        // JSONNull instances are always equal, so we don't need to add anything to the hasher
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String
    
    required init?(intValue: Int) {
        return nil
    }
    
    required init?(stringValue: String) {
        key = stringValue
    }
    
    var intValue: Int? {
        return nil
    }
    
    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {
    
    let value: Any
    
    
    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }
    
    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }
    
    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }
    
    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }
    
    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }
    
    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }
    
    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }
    
    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
        
}


/*
 

 import Foundation

 // MARK: - Welcome
 struct Welcome: Codable {
     let photo: Photo
     let stat: String
 }

 // MARK: - Photo
 struct Photo: Codable {
     let id, secret, server: String
     let farm: Int
     let dateuploaded: String
     let isfavorite: Int
     let license, safetyLevel: String
     let rotation: Int
     let owner: Owner
     let title, description: Comments
     let visibility: Visibility
     let dates: Dates
     let views: String
     let editability, publiceditability: Editability
     let usage: Usage
     let comments: Comments
     let notes: Notes
     let people: People
     let tags: Tags
     let urls: Urls
     let media: String

     enum CodingKeys: String, CodingKey {
         case id, secret, server, farm, dateuploaded, isfavorite, license
         case safetyLevel
         case rotation, owner, title, description, visibility, dates, views, editability, publiceditability, usage, comments, notes, people, tags, urls, media
     }
 }

 // MARK: - Comments
 struct Comments: Codable {
     let content: String

     enum CodingKeys: String, CodingKey {
         case content
     }
 }

 // MARK: - Dates
 struct Dates: Codable {
     let posted, taken: String
     let takengranularity: Int
     let takenunknown, lastupdate: String
 }

 // MARK: - Editability
 struct Editability: Codable {
     let cancomment, canaddmeta: Int
 }

 // MARK: - Notes
 struct Notes: Codable {
     let note: [JSONAny]
 }

 // MARK: - Owner
 struct Owner: Codable {
     let nsid: Nsid
     let username: Rname
     let realname, location, iconserver: String
     let iconfarm: Int
     let pathAlias: String
     let gift: Gift

     enum CodingKeys: String, CodingKey {
         case nsid, username, realname, location, iconserver, iconfarm
         case pathAlias
         case gift
     }
 }

 // MARK: - Gift
 struct Gift: Codable {
     let giftEligible: Bool
     let eligibleDurations: [String]
     let newFlow: Bool

     enum CodingKeys: String, CodingKey {
         case giftEligible
         case eligibleDurations
         case newFlow
     }
 }

 enum Nsid: String, Codable {
     case the137320984N04 = "137320984@N04"
 }

 enum Rname: String, Codable {
     case tontoe1963 = "Tontoe1963"
 }

 // MARK: - People
 struct People: Codable {
     let haspeople: Int
 }

 // MARK: - Tags
 struct Tags: Codable {
     let tag: [Tag]
 }

 // MARK: - Tag
 struct Tag: Codable {
     let id: String
     let author: Nsid
     let authorname: Rname
     let raw, content: String
     let machineTag: Int

     enum CodingKeys: String, CodingKey {
         case id, author, authorname, raw
         case content
         case machineTag
     }
 }

 // MARK: - Urls
 struct Urls: Codable {
     let url: [URLElement]
 }

 // MARK: - URLElement
 struct URLElement: Codable {
     let type: String
     let content: String

     enum CodingKeys: String, CodingKey {
         case type
         case content
     }
 }

 // MARK: - Usage
 struct Usage: Codable {
     let candownload, canblog, canprint, canshare: Int
 }

 // MARK: - Visibility
 struct Visibility: Codable {
     let ispublic, isfriend, isfamily: Int
 }

 // MARK: - Encode/decode helpers

 class JSONNull: Codable, Hashable {

     public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
             return true
     }

     public var hashValue: Int {
             return 0
     }

     public init() {}

     public required init(from decoder: Decoder) throws {
             let container = try decoder.singleValueContainer()
             if !container.decodeNil() {
                     throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
             }
     }

     public func encode(to encoder: Encoder) throws {
             var container = encoder.singleValueContainer()
             try container.encodeNil()
     }
 }

 class JSONCodingKey: CodingKey {
     let key: String

     required init?(intValue: Int) {
             return nil
     }

     required init?(stringValue: String) {
             key = stringValue
     }

     var intValue: Int? {
             return nil
     }

     var stringValue: String {
             return key
     }
 }

 class JSONAny: Codable {

     let value: Any

     static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
             let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
             return DecodingError.typeMismatch(JSONAny.self, context)
     }

     static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
             let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
             return EncodingError.invalidValue(value, context)
     }

     static func decode(from container: SingleValueDecodingContainer) throws -> Any {
             if let value = try? container.decode(Bool.self) {
                     return value
             }
             if let value = try? container.decode(Int64.self) {
                     return value
             }
             if let value = try? container.decode(Double.self) {
                     return value
             }
             if let value = try? container.decode(String.self) {
                     return value
             }
             if container.decodeNil() {
                     return JSONNull()
             }
             throw decodingError(forCodingPath: container.codingPath)
     }

     static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
             if let value = try? container.decode(Bool.self) {
                     return value
             }
             if let value = try? container.decode(Int64.self) {
                     return value
             }
             if let value = try? container.decode(Double.self) {
                     return value
             }
             if let value = try? container.decode(String.self) {
                     return value
             }
             if let value = try? container.decodeNil() {
                     if value {
                             return JSONNull()
                     }
             }
             if var container = try? container.nestedUnkeyedContainer() {
                     return try decodeArray(from: &container)
             }
             if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
                     return try decodeDictionary(from: &container)
             }
             throw decodingError(forCodingPath: container.codingPath)
     }

     static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
             if let value = try? container.decode(Bool.self, forKey: key) {
                     return value
             }
             if let value = try? container.decode(Int64.self, forKey: key) {
                     return value
             }
             if let value = try? container.decode(Double.self, forKey: key) {
                     return value
             }
             if let value = try? container.decode(String.self, forKey: key) {
                     return value
             }
             if let value = try? container.decodeNil(forKey: key) {
                     if value {
                             return JSONNull()
                     }
             }
             if var container = try? container.nestedUnkeyedContainer(forKey: key) {
                     return try decodeArray(from: &container)
             }
             if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
                     return try decodeDictionary(from: &container)
             }
             throw decodingError(forCodingPath: container.codingPath)
     }

     static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
             var arr: [Any] = []
             while !container.isAtEnd {
                     let value = try decode(from: &container)
                     arr.append(value)
             }
             return arr
     }

     static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
             var dict = [String: Any]()
             for key in container.allKeys {
                     let value = try decode(from: &container, forKey: key)
                     dict[key.stringValue] = value
             }
             return dict
     }

     static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
             for value in array {
                     if let value = value as? Bool {
                             try container.encode(value)
                     } else if let value = value as? Int64 {
                             try container.encode(value)
                     } else if let value = value as? Double {
                             try container.encode(value)
                     } else if let value = value as? String {
                             try container.encode(value)
                     } else if value is JSONNull {
                             try container.encodeNil()
                     } else if let value = value as? [Any] {
                             var container = container.nestedUnkeyedContainer()
                             try encode(to: &container, array: value)
                     } else if let value = value as? [String: Any] {
                             var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                             try encode(to: &container, dictionary: value)
                     } else {
                             throw encodingError(forValue: value, codingPath: container.codingPath)
                     }
             }
     }

     static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
             for (key, value) in dictionary {
                     let key = JSONCodingKey(stringValue: key)!
                     if let value = value as? Bool {
                             try container.encode(value, forKey: key)
                     } else if let value = value as? Int64 {
                             try container.encode(value, forKey: key)
                     } else if let value = value as? Double {
                             try container.encode(value, forKey: key)
                     } else if let value = value as? String {
                             try container.encode(value, forKey: key)
                     } else if value is JSONNull {
                             try container.encodeNil(forKey: key)
                     } else if let value = value as? [Any] {
                             var container = container.nestedUnkeyedContainer(forKey: key)
                             try encode(to: &container, array: value)
                     } else if let value = value as? [String: Any] {
                             var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                             try encode(to: &container, dictionary: value)
                     } else {
                             throw encodingError(forValue: value, codingPath: container.codingPath)
                     }
             }
     }

     static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
             if let value = value as? Bool {
                     try container.encode(value)
             } else if let value = value as? Int64 {
                     try container.encode(value)
             } else if let value = value as? Double {
                     try container.encode(value)
             } else if let value = value as? String {
                     try container.encode(value)
             } else if value is JSONNull {
                     try container.encodeNil()
             } else {
                     throw encodingError(forValue: value, codingPath: container.codingPath)
             }
     }

     public required init(from decoder: Decoder) throws {
             if var arrayContainer = try? decoder.unkeyedContainer() {
                     self.value = try JSONAny.decodeArray(from: &arrayContainer)
             } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
                     self.value = try JSONAny.decodeDictionary(from: &container)
             } else {
                     let container = try decoder.singleValueContainer()
                     self.value = try JSONAny.decode(from: container)
             }
     }

     public func encode(to encoder: Encoder) throws {
             if let arr = self.value as? [Any] {
                     var container = encoder.unkeyedContainer()
                     try JSONAny.encode(to: &container, array: arr)
             } else if let dict = self.value as? [String: Any] {
                     var container = encoder.container(keyedBy: JSONCodingKey.self)
                     try JSONAny.encode(to: &container, dictionary: dict)
             } else {
                     var container = encoder.singleValueContainer()
                     try JSONAny.encode(to: &container, value: self.value)
             }
     }
 }

 */
