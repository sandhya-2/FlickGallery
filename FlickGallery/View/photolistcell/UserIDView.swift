//
//  UserIDView.swift
//  FlickGallery
//
//  Created by Sandhya on 06/06/2024.
//

import SwiftUI

struct UserIDView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = PhotoViewModel(networkManager: NetworkManager())
    @State var selectedID: String = ""
    var colummnGrid: [GridItem] = [
        GridItem(.adaptive(minimum: 200))
    ]
    
    var body: some View {
        
        HStack {
            detailHeader
        }
    
        ScrollView {
            VStack {
                Text("I ma here")
                let photoID = viewModel.filteredPhotoByID
                let photoUser = viewModel.searchPhotoInfo
                
                LazyVGrid(columns: colummnGrid, spacing: 20) {
                    
                    ForEach(Array(zip(photoID, photoUser)), id: \.0.id){ photo, photoInfo in
                        
                        GridCell(photo: photo, photoInfo: photoInfo)
                            .padding(10)
                        
                    }
                }.padding(10)
                
                
                
                
            }
            
            
            
            Spacer()
        }
        
        
    }
}

//#Preview {
//    UserIDView(selectedUserID: )
//}

extension UserIDView {
    
    private var detailHeader: some View {
        HStack {
            CircleButtonView(iconName: "chevron.left")
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Spacer()
            Text("User ID")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
            Spacer()
            crossButtom
        }.padding(.horizontal)
    }
    
    private var crossButtom: some View {
        Button {
            
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
                .padding(14)
                .frame(width: 25, height: 25)
                .foregroundColor(.primary)
                .background(.thickMaterial)
                .cornerRadius(10)
                .shadow(radius: 4)
                .padding()
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
        }
    }
}

