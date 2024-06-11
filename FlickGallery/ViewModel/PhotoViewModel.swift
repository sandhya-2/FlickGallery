//
//  PhotoViewModel.swift
//  FlickGallery
//
//  Created by Sandhya on 31/05/2024.
//

import SwiftUI

@MainActor
class PhotoViewModel: ObservableObject {
    
    private var apiEndpoint = APIEndpoint()
    private var networkManager: NetworkManager
    @Published var photoElementList: [PhotoElement] = []
    @Published var photosList: [Person] = []
    @Published var personDetailsList: PersonDetails?
    @Published var photoDetailsList: PhotoDetails?
    @Published var authorDetailList: [PhotoElement] = []
    var colummnGrid: [GridItem] = [
        GridItem(.adaptive(minimum: 200))
    ]
    @Published var selectedID: String?
    var columnGrid:[GridItem] = Array(repeating:.init(.flexible()), count: 3)
    @Published var searchString: String = "yorkshire"
    
    
    init(apiEndpoint: APIEndpoint = APIEndpoint(), networkManager: NetworkManager = NetworkManager()) {
        self.apiEndpoint = apiEndpoint
        self.networkManager = networkManager
        
    }
    
    /* photo search by text/tags */
    var filteredPhotos: [PhotoElement] {
        guard searchString.isEmpty else {
            return photoElementList
        }
        return photoElementList.filter {
            $0.owner.localizedCaseInsensitiveContains(searchString)
        }
    }
    
    var getPhotosbyUserID: [PhotoElement] {
        guard ((selectedID?.isEmpty) != nil) else {
            return authorDetailList
        }
        return authorDetailList.filter{ $0.owner.localizedCaseInsensitiveContains(selectedID ?? "")}
    }
    
    func getPhotos(searchText: String) async throws -> Result<FlickResponse, NetworkError> {
        let url = apiEndpoint.urlString(method: "flickr.photos.search",
                                        params: "&tags=tags&text=\(searchText)&per_page=10&safe_search=1")
        
        print("url string :\(url)")
        switch try await networkManager.getModel(FlickResponse.self, url: url) {
        case .success(let photos):
            
            self.photoElementList = photos.photos.photo ?? []
            
            return Result.success(photos)
        case .failure(let error):
            return Result.failure(error)
        }
    }
    
    
    func getPhotoDetail(photoId: String) async throws -> Result<PhotoDetails, NetworkError> {
        let url = apiEndpoint.urlString(method: "flickr.photos.getInfo", params: "&photo_id=\(photoId)&per_page=10&safe_search=1")
        switch try await networkManager.getModel(PhotoDetails.self, url: url) {
        case .success(let photoDetail):
            
            DispatchQueue.main.async {
                
                self.photoDetailsList = photoDetail
                
            }
            
            //            print(" details list printing \(photoDetail)")
            return Result.success(photoDetail)
        case .failure(let error):
            print(error)
            return Result.failure(error)
        }
    }
    
    func getPersonDetails(userId: String) async throws -> Result<PersonDetails, NetworkError> {
        let url = apiEndpoint.urlString(method: "flickr.people.getInfo", params: "&user_id=\(userId)&per_page=10&safe_search=1")
        switch try await networkManager.getModel(PersonDetails.self, url: url) {
        case .success(let details):
            personDetailsList = details
            return Result.success(details)
        case .failure(let error):
            print(error)
            return Result.failure(error)
        }
    }
    
    
    func getPhotosByUser(userId: String) async throws -> Result<FlickResponse, NetworkError> {
        let url = apiEndpoint.urlString(method: "flickr.photos.search", params: "&user_id=\(userId)&per_page=10&safe_search=1")
        switch try await networkManager.getModel(FlickResponse.self, url: url) {
        case .success(let authorDetails):
            
            self.authorDetailList = authorDetails.photos.photo ?? []
            
            print("Updated authorDetailList: \(authorDetails)")
            
            return Result.success(authorDetails)
        case .failure(let error):
            print(error)
            return Result.failure(error)
        }
    }
    
    
}




