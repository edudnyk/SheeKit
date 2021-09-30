//
//  SheetContentView.swift
//  SheeKitDemo
//
//  Created by Eugene Dudnyk on 30/09/2021.
//
//  MIT License
//
//  Copyright (c) 2021 Eugene Dudnyk
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


import SwiftUI
import SheeKit

struct SheetContentView: View {
    @Binding var item: ModalPresentationStyle
    @Binding var presentedViewControllerParameters: UIViewControllerProxy
    @State var nextItem: ModalPresentationStyle?
    @Environment(\.shee_dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack() {
                Color(.systemBackground).ignoresSafeArea(.container, edges: [.bottom, .leading, .trailing])
                ScrollView() {
                    VStack(spacing: Theme.spacing4x) {
                        Spacer(minLength: Theme.spacing4x)
                        Text(item.title)
                            .font(.system(size: 36, design: .default).bold())
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        if let subtitle = item.subtitle {
                            Text(subtitle)
                                .font(.system(size: 20, design: .default).bold())
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        Spacer(minLength: Theme.spacing4x)
                        controls
                        Spacer()
                    }
                    .padding(Theme.spacing4x)
                    .frame(maxWidth: .infinity)
                }
            }
            .colorScheme(.dark)
            .navigationTitle(item.navigationBarTitle)
            .navigationBarTitleDisplayMode(.large)
            .navigationViewStyle(.stack)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { nextItem = item.next }) {
                        HStack {
                            Text("Next Style")
                            Image(systemName: "arrow.forward.circle")
                        }
                    }
                    .shee(item: $nextItem, presentationStyle: .popover(adaptiveSheetProperties: .init(detents: [.medium()]))) { nextItem in
                        InitialPresentationPropertiesView(nextItem: .init(get: { nextItem }, set: { self.nextItem = $0 }),
                                                          presentedViewControllerParameters: $presentedViewControllerParameters) { nextItem in
                            self.item = nextItem
                        }
                    }
                }
            }
        }
        .environment(\.horizontalSizeClass, .compact)
    }
    
    @ViewBuilder
    var controls: some View {
        VStack {
            switch item {
            case .pageSheet(let sheetProperties): UpdatablePresentationPropertiesView(properties: .init(get: { sheetProperties ?? .init() }, set: { item = .pageSheet(properties: $0) }))
            case .formSheet(let sheetProperties):
                VStack(spacing: Theme.spacing4x) {
                    UpdatablePresentationPropertiesView(properties: .init(get: { sheetProperties ?? .init() }, set: { item = .formSheet(properties: $0) }))
                }
            case .popover(let permittedArrowDirections, let sourceRectTransform, let adaptiveSheetProperties):
                VStack(alignment: .leading, spacing: Theme.spacing4x) {
                    UpdatablePresentationPropertiesView(properties: .init(get: { adaptiveSheetProperties ?? .init() }, set: { item = .popover(permittedArrowDirections: permittedArrowDirections, sourceRectTransform: sourceRectTransform, adaptiveSheetProperties: $0) }))
                }
            default: EmptyView()
            }
            PreferredContentSizeView(preferredContentSize: $presentedViewControllerParameters.preferredContentSize)
        }
    }
}
