//
//  PhotoViewModel.swift
//  FlickGallery
//
//  Created by Sandhya on 31/05/2024.
//

import SwiftUI

class PhotoViewModel: ObservableObject {
    
    var networkManager = NetworkManager()
    @Published var listOfPhotos: [Photo] = []
    @Published var photoIDs: [String] = []
    @Published var photoURLs: [URL] = []
    @Published var photosInfoList: [PhotoInfo] = []
    @Published var totalPages: Int = 0
    @Published var currentPage = 1
    @Published var lastID: String?

    @Published var searchString: String
    
    {
        didSet {
            Task {
                await getPhotos(searchText: searchString, page: self.currentPage)
            }
        }
    }
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.searchString = "yorkshire"
        
        Task {
            await fetchInitialData()
        }
    }
    
    func loadMorePhotos() async {
        guard currentPage < totalPages else { return }
        await getPhotos(searchText: self.searchString, page: self.currentPage)
    }
        // MARK: - Data Fetching
        
        func fetchInitialData() async {
            
            await self.getPhotos(searchText: self.searchString, page: self.currentPage)
            await self.fetchPhotoInfoUrls()
            //            await self.getPhotosInfo()
            
            
            //                await withTaskGroup(of: Void.self) { group in
            //                    group.addTask {
            //                        await self.getPhotos(searchText: self.searchString)
            //                    }
            //                    group.addTask {
            //                        await self.fetchPhotoInfoUrls()
            //                    }
            //                    group.addTask {
            //                        await self.getPhotosInfo()
            //                    }
            //                }
            
            
        }
        
        var filteredPhotos: [Photo] {
            
            if searchString.isEmpty {
                // If the search string is empty, return photos list
                return listOfPhotos
            } else {
                
                return listOfPhotos.filter { photo in
                    let tagMatches = photo.tags.localizedCaseInsensitiveContains(searchString)
                    let ownerMatches = photosInfoList.contains { info in
                        let owner = info.owner
                        return owner.username?.localizedCaseInsensitiveContains(searchString) ?? false ||
                        info.tags?.tag.contains { tag in
                            [tag.author, tag.authorname, tag.content].contains { $0?.localizedCaseInsensitiveContains(searchString) ?? false }
                        } ?? false
                    }
                    return tagMatches || ownerMatches
                }
            }
        }
        
        
        
        
        /*
         var filteredPhotos: [Photo] {
         if searchString.isEmpty {
         // If the search string is empty, return photos containing "yorkshire" in tags
         return listOfPhotos.filter { $0.tags.localizedCaseInsensitiveContains("yorkshire") }
         } else {
         let lowercasedSearchString = searchString.lowercased()
         return listOfPhotos.filter { photo in
         let tagMatches = photo.tags.localizedCaseInsensitiveContains(lowercasedSearchString)
         let ownerMatches = photosInfoList.contains { info in
         let owner = info.owner
         return owner.username?.localizedCaseInsensitiveContains(lowercasedSearchString) ?? false ||
         info.tags?.tag.contains { tag in
         [tag.author, tag.authorname, tag.content].contains { $0?.localizedCaseInsensitiveContains(lowercasedSearchString) ?? false }
         } ?? false
         }
         return tagMatches || ownerMatches
         }
         }
         }
         */
        
        
        
        // MARK: - Pagination
            @MainActor
        func getPhotos(searchText: String, page: Int) async {
            print("Loading photos..............")
            do {
                let data = try await fetchData(text: searchText, page: page)
                let flickrResponse = try JSONDecoder().decode(FlickResponse.self, from: data)
                let ids = flickrResponse.photos.photo.map { $0.id }
               
               
                if page == 1 {
                    self.listOfPhotos = flickrResponse.photos.photo
                } else {
                   
                    self.listOfPhotos.append(contentsOf: flickrResponse.photos.photo)
                   
                }
                self.photoIDs.append(contentsOf: ids)
                self.totalPages = flickrResponse.photos.pages ?? 1
                self.currentPage += 1
                print("currentpage getphotos() :  \(self.currentPage)")
                print("total page getphotos():  \(self.totalPages)")
                print("photos list : \(self.listOfPhotos)")
                //                print("photos id : \(self.photoIDs)")
                
                await getPhotosInfo()
                
            } catch {
                print("Failed to fetch photos: \(error)")
            }
            
            print("Finished Loading photos..............")
        }
        
        func fetchData(text: String, page: Int) async throws -> Data {
            
            let urlString = URLComponents().buildURLForSearch(searchText: text, page: page)
            
            guard let url = URL(string: urlString.absoluteString) else {
                throw NetworkError.invalidURL
            }
            
            do {
                let data = try await networkManager.get(url: url)
                return data
            } catch {
                throw error
            }
        }
        
        
        // MARK: - Photo Info Fetching
        
        func fetchPhotoInfoUrls() async {
            for photoID in photoIDs {
                do {
                    let _ = try await fetchPhotoInfo(photoID: photoID)
                    let photoURL = URLComponents().buildURLForPhotoInfo(photoId: photoID)
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.photoURLs.append(photoURL)
                    }
                    //               print("photo url ......\(self.photoURLs)")
                } catch {
                    print("Error fetching photo info for ID \(photoID): \(error)")
                }
            }
        }
        
        func fetchPhotoInfo(photoID: String) async throws -> Data {
            
            let urlString = URLComponents().buildURLForPhotoInfo(photoId: photoID)
            
            //        print("urlString: \(urlString)")
            guard let url = URL(string: urlString.absoluteString) else {
                throw NetworkError.invalidURL
            }
            
            do {
                let data = try await networkManager.get(url: url)
                
                return data
            } catch {
                throw error
            }
        }
        
        func getPhotosInfo() async {
            print("Loading..............")
            print(photoIDs)
            for photoID in photoIDs {
                do {
                    let data = try await fetchPhotoInfo(photoID: photoID)
                    let flickrUserResponse = try JSONDecoder().decode(UserInfoResponse.self, from: data)
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.photosInfoList.append(flickrUserResponse.photo)
                    }
                    //                print("photoslistInfo: \(self.photosInfoList)")
                    
                } catch {
                    print("Failed to fetch photos: \(error)")
                }
            }
            print("Finished Loading..............")
        }
        
        /* this is the buddy icon for the usericon*/
        func fetchUserIconUrl(iconfarm: Int, iconserver: String, userId: String) -> URL? {
            if iconfarm > 0 {
                return URL(string: "https://farm\(iconfarm).staticflickr.com/\(iconserver)/buddyicons/\(userId).jpg")
            } else {
                return URL(string: "https://www.flickr.com/images/buddyicon.gif")
            }
            
        }
        
        func userIconURL(for photoInfo: PhotoInfo) -> URL? {
            let defaultNsid = "default_nsid"
            return fetchUserIconUrl(iconfarm: photoInfo.owner.iconfarm, iconserver: photoInfo.owner.iconserver, userId: photoInfo.owner.nsid ?? defaultNsid)
        }
        
        func resetAndSearch() async {
            currentPage = 1
            await MainActor.run {
                listOfPhotos.removeAll()
            }
            await getPhotos(searchText: searchString, page: currentPage)
        }
    
        
        
    }

 /*This is the original view model*/
 
/*
class PhotoViewModel: ObservableObject {
    
    var networkManager = NetworkManager()
    @Published var listOfPhotos: [Photo] = []
    @Published var photoIDs: [String] = []
    @Published var photoURLs: [URL] = []
    @Published var photosInfoList: [PhotoInfo] = []
    @Published var currentPage: Int = 1
    var totalPages = 0
    var perPage = 12
    @Published var searchString: String {
        didSet {
            Task {
                await getPhotos(searchText: searchString)
            }
        }
    }
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.searchString = "yorkshire"
        
        Task {
            await fetchInitialData()
        }
    }
    
    
   var filteredPhotos: [Photo] {
        if searchString.isEmpty {
                    return listOfPhotos.filter { $0.tags.localizedCaseInsensitiveContains("yorkshire") }
                } else {
                    return listOfPhotos.filter { $0.tags.localizedCaseInsensitiveContains(searchString) }
                }
        
    }
    
    func fetchInitialData() async {
        await getPhotos(searchText: self.searchString)
        await fetchandStorePhotoInfoUrl()
        await getPhotosInfo()
        
    }
    
    func getPhotos(searchText: String) async {
        do {
            let data = try await fetchData(text: searchText)
            let flickrResponse = try JSONDecoder().decode(FlickResponse.self, from: data)
            let ids = flickrResponse.photos.photo.map { $0.id }
            
            DispatchQueue.main.async {
                self.listOfPhotos = flickrResponse.photos.photo
                self.photoIDs = ids
                
            }
            
        } catch {
            print("Failed to fetch photos: \(error)")
        }
    }
    
    func fetchData(text: String) async throws -> Data {
        
        guard let url = URL(string: buildURLForSearch(searchText: text).absoluteString) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let data = try await networkManager.get(url: url)
            //            print("Fetched Data: \(data)")
            return data
        } catch {
            throw error
        }
    }
    
    func buildURLForSearch(searchText: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.flickr.com"
        components.path = "/services/rest"
        
        components.queryItems = [
            URLQueryItem(name: "method", value: APIEndpoint.method),
            URLQueryItem(name: "api_key", value: APIEndpoint.api_key),
            URLQueryItem(name: "format", value: APIEndpoint.format),
            URLQueryItem(name: "nojsoncallback", value: APIEndpoint.nojsoncallback),
            URLQueryItem(name: "safe_search", value: APIEndpoint.safe_search),
            URLQueryItem(name: "text", value: searchText),
            URLQueryItem(name: "extras", value: APIEndpoint.extras)
        ]
        guard let url = components.url else {
            preconditionFailure("Invalid URL string")
        }
        print(url)
        return url
    }
    
    func fetchPhotoInfo(photoID: String) async throws -> Data {
        guard let url = URL(string: buildURLForPhotoInfo(photoId: photoID).absoluteString) else {
            throw NetworkError.invalidURL
        }
        
        //        print("Infor URLLLLLL\(url)")
        
        do {
            let data = try await networkManager.get(url: url)
            print("Fetched PhotoID Data: \(data)")
            return data
        } catch {
            throw error
        }
    }
    
    func fetchandStorePhotoInfoUrl() async {
        
        print("Starting fetchAndStorePhotoInfoUrl with photoIDs: \(photoIDs)")
        
        for photoID in photoIDs {
            do {
                let _ = try await fetchPhotoInfo(photoID: photoID)
                let photoURL = buildURLForPhotoInfo(photoId: photoID)
                
                DispatchQueue.main.async {
                    self.photoURLs.append(photoURL)
                    //                           print("Appended URL: \(photoURL)")
                    //                           print("Current photoURLs: \(self.photoURLs)")
                }
                
            } catch {
                print("Error fetching photo info for ID \(photoID): \(error)")
            }
        }
        
        //               print("Final photoURLs: \(photoURLs)")
        
    }
    
    func buildURLForPhotoInfo(photoId: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.flickr.com"
        components.path = "/services/rest"
        
        components.queryItems = [
            URLQueryItem(name: "method", value: APIEndpoint.methodInfo),
            URLQueryItem(name: "api_key", value: APIEndpoint.api_key),
            URLQueryItem(name: "photo_id", value: photoId),
            URLQueryItem(name: "format", value: APIEndpoint.format),
            URLQueryItem(name: "nojsoncallback", value: APIEndpoint.nojsoncallback)
        ]
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL string")
        }
        
        //        print(url)
        return url
    }
    
    /*
     https://www.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=f0f4126da4d8f57b59654995d2a8adf4&photo_id=53758968082&format=json&nojsoncallback=1
     */
    //https://www.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=f0f4126da4d8f57b59654995d2a8adf4&photo_id=53762538043&format=json&nojsoncallback=1
    
    
    func fetchUserInfo(for photoId: String) async throws -> Data {
        //        let urlString = "https://www.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=f0f4126da4d8f57b59654995d2a8adf4&photo_id=\(photoId)&format=json&nojsoncallback=1"
        //
        
        //                print("photoinfo url \(urlString)")
        guard let url = URL(string: buildURLForPhotoInfo(photoId: photoId).absoluteString) else {
            throw NetworkError.invalidURL
        }
        do {
            let data = try await networkManager.get(url: url)
            print("Fetched Data: \(data)")
            return data
        } catch {
            throw error
        }
    }
    
    func getPhotosInfo() async {
        
        for photoID in photoIDs {
            do {
                let data = try await fetchPhotoInfo(photoID: photoID)
                let flickrUserResponse = try JSONDecoder().decode(UserInfoResponse.self, from: data)
                
                DispatchQueue.main.async {
                    
                    self.photosInfoList.append(flickrUserResponse.photo)
                    print("Appended Photo Info: \(flickrUserResponse.photo)")
                    print("Current photosInfoList: \(self.photosInfoList)")
                    
                }
                
            } catch {
                print("Failed to fetch photos: \(error)")
            }
            
        }
        
    }
    
    
    /* this is the buddy icon for the usericon*/
    func fetchUserIconUrl(iconfarm: Int, iconserver: String, userId: String) -> URL? {
        if iconfarm > 0 {
            return URL(string: "https://farm\(iconfarm).staticflickr.com/\(iconserver)/buddyicons/\(userId).jpg")
        } else {
            return URL(string: "https://www.flickr.com/images/buddyicon.gif")
        }
    }
    
    func userIconURL(for photoInfo: PhotoInfo) -> URL? {
        let defaultNsid = "default_nsid"
        return fetchUserIconUrl(iconfarm: photoInfo.owner.iconfarm, iconserver: photoInfo.owner.iconserver, userId: photoInfo.owner.nsid ?? defaultNsid)
       }
    
}

//http://farm{icon-farm}.staticflickr.com/{icon-server}/buddyicons/{nsid}.jpg

*/
