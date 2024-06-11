import Foundation

// MARK: PersonDetails
struct PersonDetails: Codable, Equatable {
    var person: Person?
    
    static func == (lhs: PersonDetails, rhs: PersonDetails) -> Bool {
        return lhs.person == rhs.person
    }
}

// MARK: Person
struct Person: Codable, Equatable  {
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String = ""
    var nsId: String = ""
    var iconServer: String = ""
    var iconFarm: Int = 0
    var username: Description = Description(content: "")
    // var photosUrl: Description = Description(content: "")
    //var profileUrl: Description = Description(content: "")
    var photos: Photos = Photos(firstDateTaken: Description(content: ""))
    
    
    var userIconUrl: URL? {
        let urlString: String
        if iconFarm > 0 {
            urlString = "https://farm\(iconFarm).staticflickr.com/\(iconServer)/buddyicons/\(String(describing: nsId)).jpg"
        } else {
            urlString = "https://www.flickr.com/images/buddyicon.gif"
        }
        return URL(string: urlString)!
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case nsId = "nsid"
        case iconServer = "iconserver"
        case iconFarm = "iconfarm"
        case username
        // case photosUrl = "photosurl"
        //case profileUrl = "profileurl"
        case photos
    }
}

// MARK: Description
struct Description: Codable {
    var content: String = ""
    
    enum CodingKeys: String, CodingKey {
        case content = "_content"
    }
}

// MARK: Photos
struct Photos: Codable {
    var firstDateTaken: Description = Description(content: "")
    
    enum CodingKeys: String, CodingKey {
        case firstDateTaken = "firstdatetaken"
    }
}

