//
//  ErrorView.swift
//  FlickGallery
//
//  Created by Sandhya on 03/06/2024.
//

import SwiftUI

struct ErrorView: View {
    
    let error: Error
    
    var body: some View {
        print(error)
        return Text("❌ **Error**").font(.system(size: 30))
    }
}

#Preview {
    ErrorView(error: NetworkError.dataNotFound)
}
