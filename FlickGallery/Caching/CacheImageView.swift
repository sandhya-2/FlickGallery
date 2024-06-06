//
//  CacheImageView.swift
//  FlickGallery
//
//  Created by Sandhya on 02/06/2024.
//

import SwiftUI

enum ImageSource {
    case photo(Photo)
    case photoInfo(PhotoInfo)
}

struct CacheImageView: View {
    
    let imageSource: ImageSource
    let viewModel = PhotoViewModel(networkManager: NetworkManager())
    
    var body: some View {
        switch imageSource {
            
        case .photo(let photo):
            
             let imageUrl = photo.imageUrl
                
                CacheAsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: 600)
                            .clipped()
                            .cornerRadius(5)
                            .padding(1)
                        
                    case .failure(_):
                        VStack {
                            Image(systemName: "exclamationmark.triangle")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 200)
                                .padding(5)
                            Text("Failed to load image")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    case .empty:
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .red))
                            Spacer()
                        }
                    @unknown default:
                        Image(systemName: "questionmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .padding(1)
                    
                }
            }
            
        case .photoInfo(let photoInfo):
            if let url = viewModel.userIconURL(for: photoInfo) {
                CacheAsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                        
                        
                        
                    case .failure(_):
                        VStack {
                            Image(systemName: "exclamationmark.triangle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .padding(5)
                            
                        }
                    case .empty:
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .red))
                            Spacer()
                        }
                    @unknown default:
                        Image(systemName: "questionmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding(2)
                    }
                }
                .padding()
            } else {
                Image(systemName: "questionmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .padding(2)
            }
        }
    }
}

