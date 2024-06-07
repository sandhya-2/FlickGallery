//
//  UserNameView.swift
//  FlickGallery
//
//  Created by Sandhya on 07/06/2024.
//

import SwiftUI

struct UserNameView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = PhotoViewModel(networkManager: NetworkManager())
    @State var selectedUsername: String = ""
    var colummnGrid: [GridItem] = [
        GridItem(.adaptive(minimum: 200))
    ]
   
    var body: some View {
    
            HStack {
                detailHeader
            }
            
            ScrollView {
                
                LazyVGrid(columns: colummnGrid, spacing: 20) {
                    
                    ForEach(viewModel.searchPhotosUser, id: \.id){ photo in
                                                
                        GridCell(photo: photo)
                            .padding(10)
                        
                    }
                }.padding(10)
                    
                    
            Spacer()
        }
        
        
    }
}

#Preview {
    UserNameView()
}

extension UserNameView {
    
    private var detailHeader: some View {
        HStack {
            CircleButtonView(iconName: "chevron.left")
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Spacer()
            Text("Username")
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

