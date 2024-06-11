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

    func test_GetPhotos_Success_when_searchText_matches() async throws {
        let mockNetworkManager = MockNetworkManager()
        
        let viewModel = await PhotoViewModel(apiEndpoint: apiEndpoint, networkManager: mockNetworkManager)
        XCTAssertNotNil(viewModel)
        let searchText = "yorkshire"
        
        let expectedPhotos = [
            PhotoElement(id: "1", secret: "owner1", server: "secret1", farm: 66, owner: "1", title: "title1", ispublic: 1, isfriend: 0, isfamily: 0),
            
            PhotoElement(id: "2", secret: "owner2", server: "secret2", farm: 66, owner: "2", title: "title2", ispublic: 1, isfriend: 0, isfamily: 0),
            
            PhotoElement(id: "53614826416", secret: "ec915cb481", server: "65535", farm: 66, owner: "39627107@N07", title: "Gannets", ispublic: 1, isfriend: 0, isfamily: 0)
        ]
        
        let expectedPhotosList =  PhotosImage(photo: expectedPhotos)
        
        let expectedPhotoSearch = FlickResponse(photos: expectedPhotosList)
        
        mockNetworkManager.setModelResult(result: Result<FlickResponse, NetworkError>.success(expectedPhotoSearch))

        do {
            switch try await viewModel.getPhotos(searchText: searchText) {
            case .success(let photos):
                XCTAssertEqual(photos, expectedPhotoSearch)
            case .failure(let error):
                XCTFail("Expected success\nReceived \(error)")
            }
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    
    func test_GetPhotos_Function_failure_when_searchTextInput() async throws {
        
        let mockNetworkManager = MockNetworkManager()
        let viewModel = await PhotoViewModel(apiEndpoint: apiEndpoint, networkManager: mockNetworkManager)
      
        XCTAssertNotNil(viewModel)
     
        let searchText = "yorkshire"
        let expectedError = NetworkError.mockError
        
        mockNetworkManager.setModelResult(result: Result<FlickResponse, NetworkError>.failure(expectedError))
        
        do {
            switch try await viewModel.getPhotos(searchText: searchText) {
            case .success:
                XCTFail("Expected failure, but received success result")
            case .failure(let error):
                XCTAssertEqual(error, expectedError, "Expected error to be \(expectedError), but received \(error)")
            }
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
        
        
    }

    
    func test_ForFetching_UserDetails_Success() async throws {
        let mockNetworkManager = MockNetworkManager()
        let viewModel = await PhotoViewModel(apiEndpoint: apiEndpoint, networkManager: mockNetworkManager)
      
        XCTAssertNotNil(viewModel)
        
        let userId = "exampleUserId"
        let expectedPerson = Person(id: "sampleId", nsId: "sampleUserId", username: Description(content: "username"))
        
        let expectedDetails = PersonDetails(person: expectedPerson)
        
        mockNetworkManager.setModelResult(result: Result<PersonDetails, NetworkError>.success(expectedDetails))
            
        do {
            switch try await viewModel.getPersonDetails(userId: userId) {
            case .success(let personDetails):
                if let actualPerson = personDetails.person {
                    
                    // Here it compares all properties of the Person struct
                    XCTAssertEqual(actualPerson, expectedPerson)
                } else {
                    XCTFail("Person details should not be nil")
                }
            case .failure(let error):
                XCTFail("Expected success\nReceived \(error)")
            }
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
        
    }
    
    func testing_GetPhotoDetails_Success() async throws {
        let mockNetworkManager = MockNetworkManager()
        let viewModel = await PhotoViewModel(apiEndpoint: apiEndpoint, networkManager: mockNetworkManager)
      
        XCTAssertNotNil(viewModel)
        
        let photoId = "samplePhotoId"
        let expectedDetails = PhotoDetails(photo: Photo(id: "samplePhotoId", title: Comments(content: "Title"), description: Comments(content: "Description"), dates: Dates(posted: "someTimestamp"), tags: Tags(tag: [Tag(id: "1", raw: "#name")])))
        
        mockNetworkManager.setModelResult(result: Result<PhotoDetails, NetworkError>.success(expectedDetails))
        
        do {
            switch try await viewModel.getPhotoDetail(photoId: photoId) {
            case .success(let details):
                // Compare the nested structures properly
                XCTAssertEqual(details.photo?.id, expectedDetails.photo?.id)
                XCTAssertEqual(details.photo?.title?.content, expectedDetails.photo?.title?.content)
                
                XCTAssertEqual(details.photo?.description?.content, expectedDetails.photo?.description?.content)
                
                XCTAssertEqual(details.photo?.dates?.posted, expectedDetails.photo?.dates?.posted)
                XCTAssertEqual(details.photo?.tags?.tag.first?.id, expectedDetails.photo?.tags?.tag.first?.id)
                XCTAssertEqual(details.photo?.tags?.tag.first?.raw, expectedDetails.photo?.tags?.tag.first?.raw)
            case .failure(let error):
                XCTFail("Expected success\nReceived \(error)")
            }
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }

        
    }
    
    
    func test_ForFetching_UserDetails_Failure() async throws {
        let mockNetworkManager = MockNetworkManager()
        let viewModel = await PhotoViewModel(apiEndpoint: apiEndpoint, networkManager: mockNetworkManager)
      
        XCTAssertNotNil(viewModel)
        
        let userId = "exampleUserId"
        let expectedError = NetworkError.mockError
        
        mockNetworkManager.setModelResult(result: Result<PersonDetails, NetworkError>.failure(expectedError))
        
        do {
            switch try await viewModel.getPersonDetails(userId: userId) {
            case .success:
                XCTFail("Expected failure, but succeeded")
            case .failure(let error):
                XCTAssertEqual(error, expectedError, "Expected error to be \(expectedError), but received \(error)")
            }
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    
    
    func test_GetPhotosbyUserID_Success_when_selectedUserId_matches() async throws {
        
             let mockNetworkManager = MockNetworkManager()
             let viewModel = await PhotoViewModel(apiEndpoint: apiEndpoint, networkManager: mockNetworkManager)
             XCTAssertNotNil(viewModel)
             
             let userId = "owner1"
             
             let expectedPhotos = [
                 PhotoElement(id: "1", secret: "secret1", server: "server1", farm: 66, owner: "owner1", title: "title1", ispublic: 1, isfriend: 0, isfamily: 0),
                 PhotoElement(id: "2", secret: "secret2", server: "server2", farm: 66, owner: "owner1", title: "title2", ispublic: 1, isfriend: 0, isfamily: 0),
                 PhotoElement(id: "3", secret: "secret3", server: "server3", farm: 66, owner: "owner1", title: "title3", ispublic: 1, isfriend: 0, isfamily: 0)
             ]
        
        let expectedPhotosList =  PhotosImage(photo: expectedPhotos)
        
        let expectedPhotoSearch = FlickResponse(photos: expectedPhotosList)
        
        mockNetworkManager.setModelResult(result: Result<FlickResponse, NetworkError>.success(expectedPhotoSearch))
        do {
            switch try await viewModel.getPhotosByUser(userId: userId) {
            case .success(let photos):
                XCTAssertEqual(photos, expectedPhotoSearch)
            case .failure(let error):
                XCTFail("Expected success\nReceived \(error)")
            }
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
        
    }
    
    func test_GetPhotosbyUserID_Failure_when_selectedUserId_doNotmatch() async throws {
        
        let mockNetworkManager = MockNetworkManager()
        let viewModel = await PhotoViewModel(apiEndpoint: apiEndpoint, networkManager: mockNetworkManager)
      
        XCTAssertNotNil(viewModel)
     
        let expectedError = NetworkError.mockError
        
        mockNetworkManager.setModelResult(result: Result<FlickResponse, NetworkError>.failure(expectedError))
        let userId = "owner1"
        
        do {
            switch try await viewModel.getPhotosByUser(userId: userId) {
            case .success:
                XCTFail("Expected failure, but received success result")
            case .failure(let error):
                XCTAssertEqual(error, expectedError, "Expected error to be \(expectedError), but received \(error)")
            }
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
        
        
    }
    

}

