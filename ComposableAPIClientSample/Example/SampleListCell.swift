//
//  SampleListCell.swift
//  ComposableAPIClientSample
//
//  Created by cranoo on 2025/06/04.
//

import SwiftUI

struct SampleListCell: View {
    let size: CGSize
    
    var body: some View {
        HStack(spacing: 12) {
            Image(.bgNaturalRiver)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width / 3, height: size.width / 3)
                .clipped()
            
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Hello")
                
                HStack(spacing: 8) {
                    Image(systemName: "person.circle")
                    Text("Your Name is Hello")
                        .font(.caption)
                    
                    Spacer()
                }
                
                Text("Hogehoge Fugafuga")
            }
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(radius: 5)
    }
}

#Preview {
    SampleListCell(size: CGSize(width: 406, height: 100))
}
