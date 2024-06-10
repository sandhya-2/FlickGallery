//
//  UserDetailView.swift
//  FlickGallery
//

import SwiftUI

struct UserDetailView: View {
    
    let photo: PhotoElement
    @ObservedObject var viewModel: PhotoViewModel
    
    var body: some View {
        
        VStack {
           
            HStack {
                
                if let personDetails = viewModel.personDetailsList {
                    HStack {
                        IconView(personDetail: personDetails)
                    }
                }
                
                Text(viewModel.personDetailsList?.person?.username.content ?? "")
                    .font(.caption)
                    .bold()
                    .foregroundColor(Color.theme.accent)
                
                Text(":")
                    .font(.caption)
                    .bold()
                    .foregroundColor(Color.theme.accent)
                Text(dateFormatter.string(from: dateFormatter.date(
                    from: viewModel.photoDetailsList?.photo?.dates?.posted ?? "") ?? Date()))
                .font(.caption)
                Spacer()
                
            }.padding(.bottom, 10)
            
            
        }.onAppear{
            Task {
                try await viewModel.getPersonDetails(userId: photo.owner)
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}


