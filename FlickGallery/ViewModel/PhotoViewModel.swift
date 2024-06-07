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
    var colummnGrid: [GridItem] = [
        GridItem(.adaptive(minimum: 200))
    ]
    @Published var selectedID: String = "" 
    @Published var selectedUsername = ""
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
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.getPhotos(searchText: self.searchString, page: self.currentPage)
            }
            group.addTask {
                await self.fetchPhotoInfoUrls()
            }
            
        }
        
    }
    
    var filteredPhotosInfo: [PhotoInfo] {
        if searchString.isEmpty {
            return photosInfoList
        } else {
            return photosInfoList.filter { photoInfo in
                let lowercasedSearchString = searchString.lowercased()
                let ownerMatches = photoInfo.owner.nsid?.localizedCaseInsensitiveContains(lowercasedSearchString) ?? false ||
                    photoInfo.owner.username?.localizedCaseInsensitiveContains(lowercasedSearchString) ?? false
                let tagMatches = photoInfo.tags?.tag.contains { tag in
                    guard let content = tag.content else { return false }
                    return content.localizedCaseInsensitiveContains(lowercasedSearchString)
                } ?? false
                return ownerMatches || tagMatches
            }
        }
    }
    
   

/* filter by text or tag*/
    var filteredPhotos: [Photo] {
        
        let lowerCasedText = searchString.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if lowerCasedText.isEmpty || lowerCasedText.count <= 2 {
            return listOfPhotos
        } else {
            
            return listOfPhotos.filter {  $0.tags.localizedCaseInsensitiveContains(lowerCasedText) ||
                $0.owner.localizedCaseInsensitiveContains(lowerCasedText) 
                
        }
            
        }
    }
    
    var searchPhoto: [Photo] {
        guard !selectedID.isEmpty else {
            
            return listOfPhotos
        }
        
        return listOfPhotos.filter { $0.owner == selectedID }
    }


        var searchPhotosUser: [Photo] {
            guard !selectedUsername.isEmpty else {
                return listOfPhotos
            }
            
            return listOfPhotos.filter { $0.ownername == selectedUsername }
        }
    
   
    // MARK: - Pagination
//    @MainActor
    func getPhotos(searchText: String, page: Int) async {
        print("Loading photos..............")
        do {
            let data = try await fetchData(text: searchText, page: page)
            let flickrResponse = try JSONDecoder().decode(FlickResponse.self, from: data)
            let ids = flickrResponse.photos.photo.map { $0.id }
            
            DispatchQueue.main.async { [weak self] in
                
                if page == 1 {
                    self?.listOfPhotos = flickrResponse.photos.photo
                } else {
                    
                    self?.listOfPhotos.append(contentsOf: flickrResponse.photos.photo)
                    
                }
                self?.photoIDs.append(contentsOf: ids)
                self?.totalPages = flickrResponse.photos.pages ?? 1
                self?.currentPage += 1
            }
           
            print("currentpage getphotos() :  \(self.currentPage)")
            print("total page getphotos():  \(self.totalPages)")
            //                print("photos list : \(self.listOfPhotos)")
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
            } catch {
                print("Error fetching photo info for ID: \(error)")
            }
        }
    }
    
    func fetchPhotoInfo(photoID: String) async throws -> Data {
        
        let urlString = URLComponents().buildURLForPhotoInfo(photoId: photoID)
        
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
    
    //user icon url
    func userIconURL(for photoInfo: PhotoInfo) -> URL? {
        let defaultNsid = "https://www.flickr.com/images/buddyicon.gif"
        return fetchUserIconUrl(iconfarm: photoInfo.owner.iconfarm, iconserver: photoInfo.owner.iconserver, userId: photoInfo.owner.nsid ?? defaultNsid)
    }
    
//    func resetAndSearch() async {
//        currentPage = 1
//        await MainActor.run {
//            listOfPhotos.removeAll()
//        }
//        await getPhotos(searchText: searchString, page: currentPage)
//    }
//    
    
    
}





