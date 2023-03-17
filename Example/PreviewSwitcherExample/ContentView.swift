//
//  ContentView.swift
//  PreviewSwitcherExample
//
//  Created by Yury Potapov on 17.03.2023.
//

import SwiftUI
import PreviewSwitcher

struct ContentView: View {
    let color: Color
    let isScaled: Bool

    var body: some View {
        HStack {
            color
                .frame(width: 100, height: 100)
                .scaleEffect(isScaled ? 0.5 : 1)
        }
        .animation(.default, value: color)
        .animation(.default, value: isScaled)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewSwitcher(views: examples)
    }

    private static let examples: [ContentView] = [
        ContentView(color: .red, isScaled: false),
        ContentView(color: .green, isScaled: false),
        ContentView(color: .green, isScaled: true)
    ]
}
