import Foundation

// MARK: PhotoDetails
struct PhotoDetails: Codable, Equatable {
    var photo: Photo?
    
    static func == (lhs: PhotoDetails, rhs: PhotoDetails) -> Bool {
        return lhs.photo == rhs.photo
    }
}

// MARK: - Photo
struct Photo: Codable, Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String = ""
    var title: Comments?
    var description: Comments?
    var dates: Dates?
    var tags: Tags?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case dates
        case tags
    }
}

// MARK: - Comments
struct Comments: Codable {
    var content: String = ""
    
    enum CodingKeys: String, CodingKey {
        case content = "_content"
    }
}

// MARK: - Dates
struct Dates: Codable {
    var posted: String = ""
}

// MARK: - Tags
struct Tags: Codable {
    var tag: [Tag] = []
    
    public static func tags(tags: [Tag] = [Tag.tag()]) -> Tags {
        Tags(tag: tags)
    }
}

// MARK: - Tag
struct Tag: Codable, Hashable {
    var id: String = ""
    var raw: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case raw
    }
    
    public static func tag(id: String = "1",
                           raw: String = "#name") -> Tag {
        Tag(id: id, raw: raw)
    }
}



