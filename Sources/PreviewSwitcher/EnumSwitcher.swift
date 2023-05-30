//
//  EnumSwitcher.swift
//
//  Created by Yury Potapov on 15.05.2023.
//

import SwiftUI

public struct EnumPicker<SelectionValue: CaseIterable & Hashable>: View
    where SelectionValue.AllCases: RandomAccessCollection
{
    public init(
        titleKey: LocalizedStringKey? = nil,
        selection: Binding<SelectionValue>
    ) {
        self.titleKey = titleKey ?? "\(String(describing: type(of: selection.wrappedValue)))"
        self.selection = selection
    }

    public var body: some View {
        Picker(titleKey, selection: selection) {
            ForEach(SelectionValue.allCases, id: \.self) {
                Text(String(describing: $0))
            }
        }
    }

    private let titleKey: LocalizedStringKey
    private let selection: Binding<SelectionValue>
}
