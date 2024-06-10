//
//  FlickGalleryTests.swift
//  FlickGalleryTests
//
//  Created by Sandhya on 31/05/2024.
//

import XCTest
@testable import FlickGallery

final class FlickGalleryTests: XCTestCase {
    
    var viewModel: PhotoViewModel!
    var apiEndpoint: APIEndpoint!
    var mockNetworkManager: MockNetworkManager!
    
    @MainActor override func setUp() {
        super.setUp()
        apiEndpoint = APIEndpoint()
        mockNetworkManager = MockNetworkManager()
        viewModel = PhotoViewModel(apiEndpoint: apiEndpoint, networkManager: mockNetworkManager)
        
    }

    override func tearDown() {
        
        viewModel = nil
        mockNetworkManager = nil
        super.tearDown()
        
    }

    func testGetPhotosSuccess() async throws {
        let searchText = "yorkshire"
        
        let expectedPhotos = [
            PhotoElement(id: "1", secret: "owner1", server: "secret1", farm: 66, owner: "1", title: "title1", ispublic: 1, isfriend: 0, isfamily: 0),
            
            PhotoElement(id: "2", secret: "owner2", server: "secret2", farm: 66, owner: "2", title: "title2", ispublic: 1, isfriend: 0, isfamily: 0)
            
            PhotoElement(id: "53614826416", secret: "ec915cb481", server: "65535", farm: 66, owner: "39627107@N07", title: "Gannets", ispublic: 1, isfriend: 0, isfamily: 0)
        ]
        
        let expectedPhotosList =  PhotosImage(from: expectedPhotos)
        let expectedPhotoSearch = FlickResponse(photos: expectedPhotosList)
        
        mockFlickrService.setFetchResult(result: Result<PhotoSearch, APIError>.success(expectedPhotoSearch))

        do {
            switch try await viewModel.getPhotos(searchText: searchText) {
            case .success(let photos):
                XCTAssertEqual(photos, expectedPhotoSearch)
            case .failure(let error):
                XCTFail("Expecting success\nGot \(error)")
            }
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }

}
