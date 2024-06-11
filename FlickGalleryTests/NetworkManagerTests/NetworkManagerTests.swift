//
//  NetworkManagerTests.swift
//  FlickGalleryTests
//
//  Created by Sandhya on 06/06/2024.
//
//
import XCTest
import Foundation
@testable import FlickGallery

final class NetworkManagerTests: XCTestCase {
    
    var mocknetworkManager: MockNetworkManager!
    
    @MainActor override func setUp()  {
        
        mocknetworkManager = MockNetworkManager()
        
    }
    
    override func tearDown() {
        
        mocknetworkManager = nil
    }
        
    /*when API is successful, get function will return expected data*/
    func testFetchData_withValidURL_shouldReturnJsonData() async {
        let  mockNetworkManager = MockNetworkManager()
        
        // GIVEN
        let data = """
                {
                    "id": "123"
                }
                """.data(using: .utf8)
        
        
        let decodedObject = try! JSONDecoder().decode(DummyResponse.self, from: data!)
        let mockResult: Result<DummyResponse, NetworkError> = .success(decodedObject)
        mockNetworkManager.mockResult = mockResult
        
        // When
        do {
            let result = try await mockNetworkManager.getModel(DummyResponse.self, url: "testURL")
            switch result {
            case .success(let actualData):
                // Then
                XCTAssertEqual(actualData, DummyResponse(id: "123"))
            case .failure(let error):
                XCTFail("Unexpected error \(error)")
            }
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }
    
    /*when API fails with status code 404 */
    func testGetAllPhotosWhenAPIFailsToReturnExpectedData() async {
        let  mockNetworkManager = MockNetworkManager()
        // Given
        let mockError = NetworkError.mockError
        
        let mockResult: Result<DummyResponse, NetworkError> = .failure(mockError)
        mockNetworkManager.error = mockError
        mockNetworkManager.mockResult = mockResult
        
        do {
            _ = try await mockNetworkManager.getModel(EmptyResponse.self, url: "testURL")
            
            XCTAssertNil(mockNetworkManager.mockResult)
            XCTFail("Expected error was not thrown")
        } catch {
            XCTAssertEqual(error as! NetworkError, mockError)
        }
    }
    
    /*when API fails with invalid request*/
    func testGetPhotosWhenRequestIsInValidAndYouDontGetData() async {
        let  mockNetworkManager = MockNetworkManager()
        
        // Given
        let mockError = NetworkError.mockError
        
        do {
            mockNetworkManager.error =  mockError
            _ = try await mockNetworkManager.getModel(DummyResponse.self, url: "testURLhlj")
            XCTFail("Expected error was not thrown")
            
        } catch {
            XCTAssertEqual(error as! NetworkError, mockError)
        }
    }
    
    /*when API fails with invalid request with empty string*/
    func testGetPhotosWhenRequestIsEmptyStringAndYouDontGetData() async {
        let  mockNetworkManager = MockNetworkManager()
        let mockError = NetworkError.mockError
        
        do {
            //Given
            mockNetworkManager.error =  NetworkError.mockError
            
            //When
            _ = try await mockNetworkManager.getModel(DummyResponse.self, url: " ")
            XCTFail("Expected error was not thrown")
            
        } catch {
            XCTAssertEqual(error as! NetworkError, mockError)
        }
    }
    
}
