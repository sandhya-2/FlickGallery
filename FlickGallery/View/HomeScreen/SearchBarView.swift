//
//  SearchBarView.swift
//  FlickGallery
//
//  Created by Sandhya on 02/06/2024.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    @State private var isEditing = false
    
    var body: some View {
        
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(!searchText.isEmpty ? Color.theme.secondaryText : .accentColor)
                .opacity(isEditing ? 0.0 : 1.0)
            
            
            TextField("Search by tags or text", text: $searchText, onEditingChanged: { editing in
                isEditing = editing
                
            })
            .foregroundColor(Color.theme.accent)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .onChange(of: searchText, { oldValue, newValue in
                isEditing = !newValue.isEmpty
                print("Search text changed: \(newValue)")
            })
            .onTapGesture {
                isEditing = true
            }
            .overlay (
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .offset(x: 10)
                    .foregroundColor(.accentColor)
                    .opacity(searchText.isEmpty ? 0.0 : 1.0)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                        isEditing = false
                        searchText = ""
                        
                        
                    }
                
                ,alignment: .trailing
            )
        }
        .font(.headline)
        .padding()
        .background(
            //
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.theme.background)
                .shadow(color: Color.theme.accent.opacity(0.15), radius: 10, x: 0, y: 0)
        ).padding()
        
    }
    
}


#Preview {
    
    SearchBarView(searchText: .constant("yorkshire"))
}


