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

@available(iOS 15, *)
struct SheetContentView: View {
    @Binding var item: ModalPresentationStyle
    @Binding var presentedViewControllerParameters: UIViewControllerProxy
    @EnvironmentObject var sheetProperties: SheetPropertiesObservable
    @State private var nextItem: ModalPresentationStyle?
    @Environment(\.shee_dismiss) private var dismiss
    
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
    private var controls: some View {
        VStack(alignment: .leading, spacing: Theme.spacing4x) {
            switch item {
            case .pageSheet: UpdatableSheetPresentationPropertiesView()
            case .formSheet: UpdatableSheetPresentationPropertiesView()
            case .popover: UpdatableSheetPresentationPropertiesView()
            default: EmptyView()
            }
            PreferredContentSizeView(preferredContentSize: $presentedViewControllerParameters.preferredContentSize)
        }
    }
}

struct SheetContentViewCompat: View {
    @Binding var item: ModalPresentationStyleCompat
    @Binding var presentedViewControllerParameters: UIViewControllerProxy
    @State private var nextItem: ModalPresentationStyleCompat?
    @Environment(\.shee_dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack() {
                Color(.systemBackground).edgesIgnoringSafeArea([.bottom, .leading, .trailing])
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
            .navigationBarTitle(Text(item.navigationBarTitle))
            .navigationViewStyle(.stack)
            .navigationBarItems(leading: Button("Done") { dismiss() }, trailing:
                    Button(action: { nextItem = item.next }) {
                        HStack {
                            Text("Next Style")
                            Image(systemName: "arrow.forward.circle")
                        }
                    }
                    .shee(item: $nextItem, presentationStyle: .popover()) { nextItem in
                        InitialPresentationPropertiesViewCompat(nextItem: .init(get: { nextItem }, set: { self.nextItem = $0 }),
                                                                presentedViewControllerParameters: $presentedViewControllerParameters) { nextItem in
                            self.item = nextItem
                        }
                    }
                )
        }
        .environment(\.horizontalSizeClass, .compact)
    }
    
    @ViewBuilder
    private var controls: some View {
        VStack {
            PreferredContentSizeView(preferredContentSize: $presentedViewControllerParameters.preferredContentSize)
        }
    }
}
