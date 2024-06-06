//
//  PhotoListItem.swift
//  FlickGallery
//
//  Created by Sandhya on 04/06/2024.
//

import SwiftUI

struct PhotoCardView: View {
    let photo: Photo
    let userInfo: PhotoInfo
    @ObservedObject var viewModel = PhotoViewModel(networkManager: NetworkManager())
    
    var body: some View {
    
        GroupBox {
            
            VStack(alignment: .leading) {
                
                CacheImageView(imageSource: .photo(photo))
                    .padding(.bottom, 2)
                
                let user = userInfo.owner
                HStack {
                    //user icon
                   CacheImageView(imageSource: .photoInfo(userInfo))
        
                   
                    ///User id
                    Text(user.nsid ?? "")
                        .font(.subheadline)
                        .foregroundColor(Color.theme.accent)
                        .fontWeight(.heavy)
                        
                    Spacer()
                }
            
                Text("#\(photo.tags)")
                    .font(.caption)
                    .foregroundColor(Color.theme.greenColor)
                    .multilineTextAlignment(.leading)
                    .bold()
                    .padding(.bottom, 5)
                Spacer()
                
            }.padding(.horizontal, 5)
                    
        }
        .groupBoxStyle( CardGroupBoxStyle())
    }
}



//#Preview {
//    PhotoListItem(photo: Photo(id: "1234567890", owner: "ownerID", secret: "secretString", server: "", farm: 1, title: "Photo Title", ispublic: 1, isfriend: 0, isfamily: 0, dateupload: "2024-06-03", datetaken: "2024-06-03 12:00:00", datetakenunknown: "0", ownername: "Owner Name", iconserver: "iconServer", iconfarm: 1, tags: "tag1,tag2", description: nil), userInfo: PhotoInfo(id: <#T##String?#>, secret: <#T##String?#>, server: <#T##String?#>, farm: <#T##Int#>, dateuploaded: <#T##String#>, isfavorite: <#T##Int#>, license: <#T##String#>, safetyLevel: <#T##String?#>, rotation: <#T##Int#>, originalsecret: <#T##String?#>, originalformat: <#T##String?#>, owner: <#T##Owner#>, title: <#T##Comments#>, description: <#T##Comments#>, visibility: <#T##Geoperms#>, dates: <#T##Dates#>, views: <#T##String#>, editability: <#T##Editability#>, publiceditability: <#T##Editability#>, usage: <#T##Usage#>, comments: <#T##Comments#>, notes: <#T##Notes?#>, people: <#T##People?#>, tags: <#T##Tags?#>, location: <#T##Location?#>, geoperms: <#T##Geoperms?#>, urls: <#T##Urls#>, media: <#T##String#>))
//}

