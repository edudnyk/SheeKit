//
//  SheetInitialPresentationPropertiesView.swift
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

struct InitialPresentationPropertiesView: View {
    @Binding var nextItem: ModalPresentationStyle
    @Binding var presentedViewControllerParameters: UIViewControllerProxy
    let action: (ModalPresentationStyle) -> Void
    @Environment(\.shee_dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack() {
                Color(.systemBackground).ignoresSafeArea(.container, edges: [.bottom, .leading, .trailing])
                ScrollView {
                    VStack {
                        HStack {
                            Text("Transition style")
                            Spacer()
                            Picker("Transition style", selection: $presentedViewControllerParameters.modalTransitionStyle) {
                                Text("Cover vertical").tag(UIModalTransitionStyle.coverVertical)
                                Text("Cross disolve").tag(UIModalTransitionStyle.crossDissolve)
                                Text("Flip horizontal").tag(UIModalTransitionStyle.flipHorizontal)
                            }
                            .pickerStyle(MenuPickerStyle())
                            .accentColor(.white)
                            .padding(.horizontal, Theme.spacing3x)
                            .frame(minHeight: Theme.spacing11x)
                            .background(RoundedRectangle(cornerRadius: Theme.cornerRadius).fill(.blue))
                        }
                        switch nextItem {
                        case .pageSheet(let sheetProperties):
                            InitialSheetPropertiesView(properties: .init(get: { sheetProperties ?? .init()}, set: { nextItem = .pageSheet(properties: $0) }))
                        case .formSheet(let sheetProperties):
                            InitialSheetPropertiesView(properties: .init(get: { sheetProperties ?? .init()}, set: { nextItem = .formSheet(properties: $0) }))
                        case .popover(let permittedArrowDirections, let sourceRectTransform, let adaptiveSheetProperties):
                            HStack {
                                Text("Permitted arrow direction")
                                Spacer()
                                Picker("Permitted arrow direction", selection: .init(get: { permittedArrowDirections }, set: {
                                    nextItem = .popover(permittedArrowDirections: $0, sourceRectTransform: sourceRectTransform, adaptiveSheetProperties: adaptiveSheetProperties)
                                })) {
                                    Text("Any").tag(UIPopoverArrowDirection.any)
                                    Text("Down").tag(UIPopoverArrowDirection.down)
                                    Text("Up").tag(UIPopoverArrowDirection.up)
                                    Text("Left").tag(UIPopoverArrowDirection.left)
                                    Text("Right").tag(UIPopoverArrowDirection.right)
                                    Text("Unknown").tag(UIPopoverArrowDirection.unknown)
                                }
                                .pickerStyle(MenuPickerStyle())
                                .accentColor(.white)
                                .padding(.horizontal, Theme.spacing3x)
                                .frame(minHeight: Theme.spacing11x)
                                .background(RoundedRectangle(cornerRadius: Theme.cornerRadius).fill(.blue))
                            }
                            InitialSheetPropertiesView(properties: .init(get: { adaptiveSheetProperties ?? .init()}, set: { nextItem = .popover(permittedArrowDirections: permittedArrowDirections, sourceRectTransform: sourceRectTransform, adaptiveSheetProperties: $0) }))
                        default: EmptyView()
                        }
                        PreferredContentSizeView(preferredContentSize: $presentedViewControllerParameters.preferredContentSize)
                    }
                    .padding(Theme.spacing4x)
                    .frame(maxWidth: .infinity)
                }
            }
            .colorScheme(.dark)
            .navigationTitle(nextItem.navigationBarTitle)
            .navigationBarTitleDisplayMode(.large)
            .navigationViewStyle(.stack)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Show") {
                        let nextItem = nextItem
                        dismiss()
                        action(nextItem)
                    }
                }
            }
                
        }
        .environment(\.horizontalSizeClass, .compact)
    }
}


struct InitialSheetPropertiesView: View {
    @Binding var properties: SheetProperties
    
    var body: some View {
        Toggle("Sheet should adjust to source view:", isOn: $properties.shouldAdjustToSourceView)
    }
}
