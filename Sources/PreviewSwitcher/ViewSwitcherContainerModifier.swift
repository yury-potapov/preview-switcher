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
        colorScheme: Binding<ColorScheme>,
        layoutDirection: Binding<LayoutDirection>
    ) {
        self.backgroundColor = backgroundColor
        self.onAnimation = onAnimation
        self._colorScheme = colorScheme
        self._layoutDirection = layoutDirection
    }

    func body(content: Content) -> some View {
        VStack {
            HStack {
                animationButton
                ButtonSwitcher(value: $colorScheme)
                ButtonSwitcher(value: $layoutDirection)
            }
            .environment(\.layoutDirection, .leftToRight)

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
            Text("Switch")
        }
        .buttonStyle(PreviewButtonStyle())
    }

    @Binding private var colorScheme: ColorScheme
    @Binding private var layoutDirection: LayoutDirection
    private let backgroundColor: Color?
    private let onAnimation: (() -> Void)

    private static let tile = Tile()
}

extension View {
    func viewSwitcherContainer(
        backgroundColor: Color? = nil,
        onAnimation: @escaping (() -> Void),
        colorScheme: Binding<ColorScheme>,
        layoutDirection: Binding<LayoutDirection>
    ) -> some View {
        return modifier(
            ViewSwitcherContainerModifier(
                backgroundColor: backgroundColor,
                onAnimation: onAnimation,
                colorScheme: colorScheme,
                layoutDirection: layoutDirection
            )
        )
    }
}

private struct ButtonSwitcher<T: CaseIterable>: View
    where T: Equatable, T.AllCases.Index == Int
{
    init(value: Binding<T>) {
        _value = value
    }

    var body: some View {
        Button(action: next) {
            Text(String(describing: value))
        }
        .buttonStyle(PreviewButtonStyle())
    }

    private func next() {
        value = T.next(after: value)
    }

    @Binding private var value: T
}

private extension CaseIterable where AllCases.Element: Equatable, AllCases.Index == Int {
    static func next(after element: AllCases.Element) -> AllCases.Element {
        assert(!allCases.isEmpty)
        guard let index = allCases.firstIndex(of: element) else {
            assertionFailure()
            return element
        }
        let nextIndex = (index + 1) % allCases.count
        return allCases[nextIndex]
    }
}

private struct Tile {

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
