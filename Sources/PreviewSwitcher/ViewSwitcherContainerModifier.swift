//
//  ViewSwitcherContainerModifier.swift
//
//  Created by Yury Potapov on 13.03.2023.
//

import SwiftUI

struct ViewSwitcherContainerModifier: ViewModifier {

    init(
        backgroundColor: Color? = nil,
        onAnimation: @escaping (() -> Void)
    ) {
        self.backgroundColor = backgroundColor
        self.onAnimation = onAnimation
    }

    func body(content: Content) -> some View {
        VStack {
            HStack {
                animationButton
                Spacer()
                VStack(alignment: .trailing) {
                    EnumPicker(selection: $colorScheme)
                    EnumPicker(selection: $layoutDirection)
                }
            }
            .padding(.horizontal)

            content
                .border(Color.gray)
                .padding()
                .environment(\.colorScheme, colorScheme)
                .environment(\.layoutDirection, layoutDirection)
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
        Button("Switch", action: onAnimation)
            .buttonStyle(PreviewButtonStyle())
    }

    @State private var showingEnvironment = false
    @State private var colorScheme: ColorScheme = .light
    @State private var layoutDirection: LayoutDirection = .leftToRight

    private let backgroundColor: Color?
    private let onAnimation: (() -> Void)

    private static let tile = PreviewTile()
}

extension View {
    func viewSwitcherContainer(
        backgroundColor: Color? = nil,
        onAnimation: @escaping (() -> Void)
    ) -> some View {
        return modifier(
            ViewSwitcherContainerModifier(
                backgroundColor: backgroundColor,
                onAnimation: onAnimation
            )
        )
    }
}
