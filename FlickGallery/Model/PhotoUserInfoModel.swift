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
 {
     "photo": {
         "id": "53758968082",
         "secret": "a13b6e0a83",
         "server": "65535",
         "farm": 66,
         "dateuploaded": "1717170265",
         "isfavorite": 0,
         "license": "0",
         "safety_level": "0",
         "rotation": 90,
         "originalsecret": "f4655f9969",
         "originalformat": "jpg",
         "owner": {
             "nsid": "200662856@N07",
             "username": "mac-gizy",
             "realname": "Danny Smith",
             "location": "",
             "iconserver": "65535",
             "iconfarm": 66,
             "path_alias": null,
             "gift": {
                 "gift_eligible": true,
                 "eligible_durations": [
                     "year",
                     "month",
                     "week"
                 ],
                 "new_flow": true
             }
         },
         "title": {
             "_content": ""
         },
         "description": {
             "_content": ""
         },
         "visibility": {
             "ispublic": 1,
             "isfriend": 0,
             "isfamily": 0
         },
         "dates": {
             "posted": "1717170265",
             "taken": "2024-05-31 08:42:58",
             "takengranularity": 0,
             "takenunknown": "0",
             "lastupdate": "1717170266"
         },
         "views": "0",
         "editability": {
             "cancomment": 0,
             "canaddmeta": 0
         },
         "publiceditability": {
             "cancomment": 1,
             "canaddmeta": 0
         },
         "usage": {
             "candownload": 1,
             "canblog": 0,
             "canprint": 0,
             "canshare": 1
         },
         "comments": {
             "_content": "0"
         },
         "notes": {
             "note": []
         },
         "people": {
             "haspeople": 0
         },
         "tags": {
             "tag": []
         },
         "location": {
             "latitude": "37.651613",
             "longitude": "-122.413734",
             "accuracy": "16",
             "context": "0",
             "locality": {
                 "_content": "South San Francisco"
             },
             "county": {
                 "_content": "San Mateo"
             },
             "region": {
                 "_content": "California"
             },
             "country": {
                 "_content": "United States"
             },
             "neighbourhood": {
                 "_content": ""
             }
         },
         "geoperms": {
             "ispublic": 1,
             "iscontact": 0,
             "isfriend": 0,
             "isfamily": 0
         },
         "urls": {
             "url": [
                 {
                     "type": "photopage",
                     "_content": "https:\/\/www.flickr.com\/photos\/200662856@N07\/53758968082\/"
                 }
             ]
         },
         "media": "photo"
     },
     "stat": "ok"
 }
 
 */




/*
 {
     "photo": {
         "id": "53764788924",
         "secret": "0cae3fc458",
         "server": "65535",
         "farm": 66,
         "dateuploaded": "1717352087",
         "isfavorite": 0,
         "license": "0",
         "safety_level": "0",
         "rotation": 0,
         "originalsecret": "96e3313cc9",
         "originalformat": "jpg",
 ,
         "tags": {
             "tag": [
                 {
                     "id": "27790019-53764788924-2935",
                     "author": "27813073@N03",
                     "authorname": "kokoschka's doll",
                     "raw": "woods",
                     "_content": "woods",
                     "machine_tag": 0
                 },
                 {
                     "id": "27790019-53764788924-535",
                     "author": "27813073@N03",
                     "authorname": "kokoschka's doll",
                     "raw": "flower",
                     "_content": "flower",
                     "machine_tag": 0
                 },
                 {
                     "id": "27790019-53764788924-44274",
                     "author": "27813073@N03",
                     "authorname": "kokoschka's doll",
                     "raw": "bluebell",
                     "_content": "bluebell",
                     "machine_tag": 0
                 },
                 {
                     "id": "27790019-53764788924-81322",
                     "author": "27813073@N03",
                     "authorname": "kokoschka's doll",
                     "raw": "west yorkshire",
                     "_content": "westyorkshire",
                     "machine_tag": 0
                 }
             ]
         },
         "urls": {
             "url": [
                 {
                     "type": "photopage",
                     "_content": "https:\/\/www.flickr.com\/photos\/kokoschkas_doll\/53764788924\/"
                 }
             ]
         },
         "media": "photo"
     },
     "stat": "ok"
 }


 */
