//
//  PickerSymbol.swift
//  VideoPlayerDemo
//
//  Created by Standard on 7/12/21.
//

import SwiftUI

struct PickerSymbol: View {
    var body: some View {
        VStack {
            SummerSymbol(name: "Summer")
        }
    }
}


// one struct for each video category
struct SummerSymbol: View {
    var name: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 10, content: {
            Image(systemName: "staroflife.fill")
                .font(.system(size: 22))
            
            Text(name)
                .font(.custom("Ariel", size: 18))
                .frame(minWidth: 0, maxWidth: 150, minHeight: 0, maxHeight: 0, alignment: .leading)
        })
    }
}
struct PickerSymbol_Previews: PreviewProvider {
    static var previews: some View {
        PickerSymbol().previewLayout(.sizeThatFits)
    }
}
