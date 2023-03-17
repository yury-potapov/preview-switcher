//
//  PreviewButtonStyle.swift
//  
//
//  Created by Yury Potapov on 17.03.2023.
//

import SwiftUI

struct PreviewButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}
