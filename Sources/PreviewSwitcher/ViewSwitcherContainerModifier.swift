//
//  ViewSwitcherContainerModifier.swift
//
//  Created by Yury Potapov on 13.03.2023.
//

import SwiftUI

struct ViewSwitcherContainerModifier: ViewModifier {

    init(
        backgroundColor: Color? = nil,
        onAnimation: @escaping (() -> Void),
        onTransition: @escaping (() -> Void)
    ) {
        self.backgroundColor = backgroundColor
        self.onAnimation = onAnimation
        self.onTransition = onTransition
    }

    func body(content: Content) -> some View {
        VStack {
            HStack {
                animationButton
                transitionButton
            }

            content
                .border(Color.gray)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundContent().ignoresSafeArea())
    }

    @ViewBuilder
    private func backgroundContent() -> some View {
        if let bgColor = backgroundColor {
            bgColor
        } else {
            Image(uiImage: Self.tile.image(for: colorScheme))
                .resizable(resizingMode: .tile)
        }
    }

    private var animationButton: some View {
        Button(action: onAnimation) {
            Text("Animation")
        }
        .buttonStyle(PreviewButtonStyle())
    }

    private var transitionButton: some View {
        Button(action: onTransition) {
            Text("Transition")
        }
        .buttonStyle(PreviewButtonStyle())
    }

    @Environment(\.colorScheme) private var colorScheme

    private let backgroundColor: Color?
    private let onAnimation: (() -> Void)
    private let onTransition: (() -> Void)

    private static let tile = Tile()
}

extension View {
    func viewSwitcherContainer(
        backgroundColor: Color? = nil,
        onAnimation: @escaping (() -> Void),
        onTransition: @escaping (() -> Void)
    ) -> some View {
        return modifier(
            ViewSwitcherContainerModifier(
                backgroundColor: backgroundColor,
                onAnimation: onAnimation,
                onTransition: onTransition
            )
        )
    }
}

private struct Tile {

    init() {
        lightImage = Self.generateTileImage(
            light: .white,
            dark: UIColor(red: 245, green: 245, blue: 245, alpha: 1),
            size: 28
        )

        darkImage = Self.generateTileImage(
            light: .black,
            dark: UIColor(red: 25, green: 25, blue: 25, alpha: 1),
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
