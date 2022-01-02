//
//  UserCell.swift
//  BildChallenge (iOS)
//
//  Created by Abbas Sabeti on 01/01/2022.
//

import SwiftUI

struct UserCell: View {
    
    let user: User
    
    var body: some View {
        HStack{
            AsyncImage(url: user.avatar) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .frame(width: 50, height: 50, alignment: .center)
                    .padding(7)
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50, alignment: .center)
            }
            VStack(alignment: .leading) {
                Text(user.name ?? "")
                    .font(.title)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
        }
    }
}

#if DEBUG
struct UserCell_Previews: PreviewProvider {
    static var previews: some View {
        UserCell(user: User.mockedData[0])
            .previewLayout(.fixed(width: 375, height: 60))
    }
}
#endif
