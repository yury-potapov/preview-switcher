//
//  PreviewSwitcher.swift
//
//  Created by Yury Potapov on 27.01.2023.
//

import SwiftUI

public struct PreviewSwitcher<ViewType: View>: View {
    public init(
        views: [ViewType],
        backgroundColor: Color? = nil,
        onNextHandler: (() -> Void)? = nil
    ) {
        self.views = views
        assert(!views.isEmpty)
        self.backgroundColor = backgroundColor
        self.onNextHandler = onNextHandler
    }

    public var body: some View {
        views[currentViewNum]
            .id(swiftUIid)
            .viewSwitcherContainer(
                backgroundColor: backgroundColor,
                onAnimation: onAnimation,
                onTransition: onTransition
            )
    }

    @State private var swiftUIid: UUID = UUID()
    @State private var currentViewNum: Int = 0
    private let views: [ViewType]
    private let backgroundColor: Color?
    private let onNextHandler: (() -> Void)?

    private func onAnimation() {
        switchView(updateId: false)
    }

    private func onTransition() {
        switchView(updateId: true)
    }

    private func switchView(updateId: Bool) {
        if updateId {
            swiftUIid = UUID()
        }
        currentViewNum = (currentViewNum + 1) % views.count
        onNextHandler?()
    }
}
