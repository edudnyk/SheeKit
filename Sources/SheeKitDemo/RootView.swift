//
//  ContentView.swift
//  CustomSheetDemo
//
//  Created by Eugene Dudnyk on 28/09/2021.
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
final class SheetPropertiesObservable: ObservableObject {
    @Published var selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    @Published var prefersEdgeAttachedInCompactHeight = false
    @Published var widthFollowsPreferredContentSizeWhenEdgeAttached = false
    @Published var prefersGrabberVisible = false
    @Published var preferredCornerRadius: CGFloat?
    @Published var detents = [ UISheetPresentationController.Detent.large() ]
    @Published var animatesSelectedDetentIdentifierChange = false
    @Published var largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    @Published var prefersScrollingExpandsWhenScrolledToEdge = true
    @Published var shouldAdjustToSourceView = false
    
    init() {}
    
    var asStruct: SheetProperties {
        .init(prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
              widthFollowsPreferredContentSizeWhenEdgeAttached: widthFollowsPreferredContentSizeWhenEdgeAttached,
              prefersGrabberVisible: prefersGrabberVisible,
              preferredCornerRadius: preferredCornerRadius,
              detents: detents,
              selectedDetentIdentifier: .init(get: { [weak self] in self?.selectedDetentIdentifier },
                                              set: { [weak self] in self?.selectedDetentIdentifier = $0 }),
              animatesSelectedDetentIdentifierChange: animatesSelectedDetentIdentifierChange,
              largestUndimmedDetentIdentifier: largestUndimmedDetentIdentifier,
              prefersScrollingExpandsWhenScrolledToEdge: prefersScrollingExpandsWhenScrolledToEdge,
              shouldAdjustToSourceView: shouldAdjustToSourceView)
    }
}

@available(iOS 15, *)
struct RootView: View {
    @State var item: ModalPresentationStyle?
    @State var isInitalPropertiesViewPresented = false
    @State var presentedViewControllerParameters = UIViewControllerProxy()
    @State var selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    @StateObject var sheetProperties = SheetPropertiesObservable()
    
    var body: some View {
        NavigationView {
            destination
                .navigationTitle("SheeKit Demo")
                .navigationViewStyle(.columns)
                .navigationBarTitleDisplayMode(.large)
        }
        .environment(\.horizontalSizeClass, .compact)
    }
    
    @ViewBuilder
    var destination: some View {
        let mergedItem = mergedItem
        VStack {
            HStack {
                Spacer()
                Button("Show") {
                    isInitalPropertiesViewPresented = true
                }
                .applyLargeButtonStyle(isSelected: item != nil)
                .shee(item: mergedItem, presentationStyle: mergedItem.wrappedValue ?? .automatic, presentedViewControllerParameters: presentedViewControllerParameters) { item in
                    SheetContentView(item: .init(get: { item }, set: { self.item = $0 }),
                                     presentedViewControllerParameters: $presentedViewControllerParameters)
                        .environmentObject(sheetProperties)
                }
                .shee(isPresented: $isInitalPropertiesViewPresented, presentationStyle: .popover(adaptiveSheetProperties: .init(detents: [.medium()]))) {
                    InitialPresentationPropertiesView(nextItem: .constant(.automatic),
                                                      presentedViewControllerParameters: $presentedViewControllerParameters) { nextItem in
                        item = nextItem
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    var mergedItem: Binding<ModalPresentationStyle?> {
        .init(get: {
            switch item {
            case .pageSheet: return .pageSheet(properties: sheetProperties.asStruct)
            case .formSheet: return .formSheet(properties: sheetProperties.asStruct)
            case .popover(let permittedArrowDirections, let sourceRectTransform, _):
                return .popover(permittedArrowDirections: permittedArrowDirections,
                                sourceRectTransform: sourceRectTransform,
                                adaptiveSheetProperties: sheetProperties.asStruct)
            default: return item
            }
        },
              set: {
            item = $0
        })
    }
}

struct RootViewCompat: View {
    @State var item: ModalPresentationStyleCompat?
    @State var isInitalPropertiesViewPresented = false
    @State var presentedViewControllerParameters = UIViewControllerProxy()
    
    var body: some View {
        NavigationView {
            destination
                .navigationBarTitle(Text("SheeKit Demo"))
                .navigationViewStyle(.automatic)
        }
        .environment(\.horizontalSizeClass, .compact)
    }
    
    @ViewBuilder
    var destination: some View {
        VStack {
            HStack {
                Spacer()
                Button("Show") {
                    isInitalPropertiesViewPresented = true
                }
                .applyLargeButtonStyle(isSelected: item != nil)
                .shee(item: $item, presentationStyle: item ?? .automatic, presentedViewControllerParameters: presentedViewControllerParameters) { item in
                    SheetContentViewCompat(item: .init(get: { item }, set: { self.item = $0 }), presentedViewControllerParameters: $presentedViewControllerParameters)
                }
                .shee(isPresented: $isInitalPropertiesViewPresented, presentationStyle: .popover()) {
                    InitialPresentationPropertiesViewCompat(nextItem: .constant(.automatic),
                                                            presentedViewControllerParameters: $presentedViewControllerParameters) { nextItem in
                        item = nextItem
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15, *) {
            RootView()
        } else {
            RootViewCompat()
        }
    }
}
