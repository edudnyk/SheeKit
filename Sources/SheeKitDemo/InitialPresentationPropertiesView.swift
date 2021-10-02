//
//  InitialPresentationPropertiesView.swift
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

@available(iOS 15, *)
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
                            .applyButtonStyle(isSelected: true)
                        }
                        NextItemView(nextItem: $nextItem)
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

@available(iOS 15, *)
struct NextItemView: View {
    @Binding var nextItem: ModalPresentationStyle
    var body: some View {
        switch nextItem {
        case .pageSheet(let sheetProperties):
            InitialSheetPropertiesView(properties: .init(get: { sheetProperties ?? .init()}, set: { nextItem = .pageSheet(properties: $0) }))
        case .formSheet(let sheetProperties):
            InitialSheetPropertiesView(properties: .init(get: { sheetProperties ?? .init()}, set: { nextItem = .formSheet(properties: $0) }))
        case .popover(let permittedArrowDirections, let sourceRectTransform, let adaptiveSheetProperties):
            HStack {
                Text("Permitted arrow directions")
                Spacer()
                HStack {
                    VStack {
                        Spacer()
                        arrowDirectionToggle(.left,
                                             in: permittedArrowDirections,
                                             sourceRectTransform: sourceRectTransform,
                                             adaptiveSheetProperties: adaptiveSheetProperties)
                        Spacer()
                    }
                    VStack {
                        arrowDirectionToggle(.up,
                                             in: permittedArrowDirections,
                                             sourceRectTransform: sourceRectTransform,
                                             adaptiveSheetProperties: adaptiveSheetProperties)
                        Spacer()
                        arrowDirectionToggle(.down,
                                             in: permittedArrowDirections,
                                             sourceRectTransform: sourceRectTransform,
                                             adaptiveSheetProperties: adaptiveSheetProperties)
                    }
                    VStack {
                        Spacer()
                        arrowDirectionToggle(.right,
                                             in: permittedArrowDirections,
                                             sourceRectTransform: sourceRectTransform,
                                             adaptiveSheetProperties: adaptiveSheetProperties)
                        Spacer()
                    }
                }
            }
            InitialSheetPropertiesView(properties: .init(get: { adaptiveSheetProperties ?? .init()}, set: { nextItem = .popover(permittedArrowDirections: permittedArrowDirections, sourceRectTransform: sourceRectTransform, adaptiveSheetProperties: $0) }))
        default: EmptyView()
        }
    }
    
    @ViewBuilder
    func arrowDirectionToggle(_ arrowDirection: UIPopoverArrowDirection, in permittedArrowDirections: UIPopoverArrowDirection, sourceRectTransform: ((CGRect) -> CGRect)?, adaptiveSheetProperties: SheetProperties?) -> some View {
        Button(action: {
            var permittedArrowDirections = permittedArrowDirections
            if permittedArrowDirections.contains(arrowDirection) {
                permittedArrowDirections.remove(arrowDirection)
            } else {
                permittedArrowDirections.formUnion(arrowDirection)
            }
            nextItem = .popover(permittedArrowDirections: permittedArrowDirections, sourceRectTransform: sourceRectTransform, adaptiveSheetProperties: adaptiveSheetProperties)
        }) {
            Image(systemName: arrowDirection.iconName)
        }
        .applyButtonStyle(isSelected: permittedArrowDirections.contains(arrowDirection))
    }
}

struct InitialPresentationPropertiesViewCompat: View {
    @Binding var nextItem: ModalPresentationStyleCompat
    @Binding var presentedViewControllerParameters: UIViewControllerProxy
    let action: (ModalPresentationStyleCompat) -> Void
    @Environment(\.shee_dismiss) var dismiss
    @State var showingPicker = false
    
    var body: some View {
        NavigationView {
            ZStack() {
                Color(.systemBackground).edgesIgnoringSafeArea([.bottom, .leading, .trailing])
                ScrollView {
                    VStack(spacing: Theme.spacing4x) {
                        HStack {
                            Text("Transition style")
                            Spacer()
                            Button(presentedViewControllerParameters.modalTransitionStyle.title) {
                                showingPicker.toggle()
                            }
                            .applyButtonStyle(isSelected: true)
                            .shee(isPresented: $showingPicker, presentationStyle: .popover()) {
                                Picker("Transition style", selection: $presentedViewControllerParameters.modalTransitionStyle) {
                                    Text(UIModalTransitionStyle.coverVertical.title).tag(UIModalTransitionStyle.coverVertical)
                                    Text(UIModalTransitionStyle.crossDissolve.title).tag(UIModalTransitionStyle.crossDissolve)
                                    Text(UIModalTransitionStyle.flipHorizontal.title).tag(UIModalTransitionStyle.flipHorizontal)
                                }
                            }
                        }
                        NextItemViewCompat(nextItem: $nextItem)
                        PreferredContentSizeView(preferredContentSize: $presentedViewControllerParameters.preferredContentSize)
                    }
                    .padding(Theme.spacing4x)
                    .frame(maxWidth: .infinity)
                }
            }
            .colorScheme(.dark)
            .navigationBarTitle(Text(nextItem.navigationBarTitle))
            .navigationViewStyle(.stack)
            .navigationBarItems(trailing: Button("Show") {
                let nextItem = nextItem
                dismiss()
                action(nextItem)
            })  
        }
        .environment(\.horizontalSizeClass, .compact)
    }
}

struct NextItemViewCompat: View {
    @Binding var nextItem: ModalPresentationStyleCompat
    var body: some View {
        switch nextItem {
        case .popover(let permittedArrowDirections, let sourceRectTransform, _):
            HStack {
                Text("Permitted arrow directions")
                Spacer()
                HStack {
                    VStack {
                        Spacer()
                        arrowDirectionToggle(.left,
                                             in: permittedArrowDirections,
                                             sourceRectTransform: sourceRectTransform)
                        Spacer()
                    }
                    VStack {
                        arrowDirectionToggle(.up,
                                             in: permittedArrowDirections,
                                             sourceRectTransform: sourceRectTransform)
                        Spacer()
                        arrowDirectionToggle(.down,
                                             in: permittedArrowDirections,
                                             sourceRectTransform: sourceRectTransform)
                    }
                    VStack {
                        Spacer()
                        arrowDirectionToggle(.right,
                                             in: permittedArrowDirections,
                                             sourceRectTransform: sourceRectTransform)
                        Spacer()
                    }
                }
            }
        default: EmptyView()
        }
    }
    
    @ViewBuilder
    func arrowDirectionToggle(_ arrowDirection: UIPopoverArrowDirection, in permittedArrowDirections: UIPopoverArrowDirection, sourceRectTransform: ((CGRect) -> CGRect)?) -> some View {
        Button(action: {
            var permittedArrowDirections = permittedArrowDirections
            if permittedArrowDirections.contains(arrowDirection) {
                permittedArrowDirections.remove(arrowDirection)
            } else {
                permittedArrowDirections.formUnion(arrowDirection)
            }
            nextItem = .popover(permittedArrowDirections: permittedArrowDirections, sourceRectTransform: sourceRectTransform)
        }) {
            Image(systemName: arrowDirection.iconName)
        }
        .applyButtonStyle(isSelected: permittedArrowDirections.contains(arrowDirection))
    }
}

struct InitialSheetPropertiesView: View {
    @available(iOS 15, *)
    @Binding var properties: SheetProperties
    
    var body: some View {
        if #available(iOS 15, *) {
            Toggle("Sheet should adjust to source view:", isOn: $properties.shouldAdjustToSourceView)
        }
    }
}
