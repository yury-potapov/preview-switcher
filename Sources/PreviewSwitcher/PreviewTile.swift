//
//  PreviewTile.swift
//
//  Created by Yury Potapov on 15.05.2023.
//

import SwiftUI

struct PreviewTile {

    init() {
        lightImage = Self.generateTileImage(
            light: .white,
            dark: UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1),
            size: 28
        )

        darkImage = Self.generateTileImage(
            light: .black,
            dark: UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0),
            size: 28
        )
    }

    func image(for colorScheme: ColorScheme) -> UIImage {
        return colorScheme == .light ? lightImage : darkImage
    }

    // MARK: Private

    private static func generateTileImage(
        light: UIColor, dark: UIColor, size: CGFloat
    ) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        let half = size / 2
        return renderer.image { context in
            light.setFill()
            context.fill(CGRect(x: 0, y: 0, width: half, height: half))
            context.fill(CGRect(x: half, y: half, width: half, height: half))
            dark.setFill()
            context.fill(CGRect(x: half, y: 0, width: half, height: half))
            context.fill(CGRect(x: 0, y: half, width: half, height: half))
        }
    }

    private let lightImage: UIImage
    private let darkImage: UIImage
}
