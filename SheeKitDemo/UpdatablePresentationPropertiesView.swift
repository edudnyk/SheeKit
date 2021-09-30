//
//  UpdatablePresentationPropertiesView.swift
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

struct UpdatablePresentationPropertiesView: View {
    @Binding var properties: SheetProperties
    @State var selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing4x) {
            Toggle("Prefers edge attached in compact height", isOn: .init(get: { properties.prefersEdgeAttachedInCompactHeight }, set: {
                var properties = properties
                properties.prefersEdgeAttachedInCompactHeight = $0
                self.properties = properties
            }))
            Toggle("Width follows preferred content size when edge attached", isOn: $properties.widthFollowsPreferredContentSizeWhenEdgeAttached)
            Toggle("Prefers grabber visible", isOn: $properties.prefersGrabberVisible)
            Toggle("Animates selected detent identifier change", isOn: $properties.animatesSelectedDetentIdentifierChange)
            Toggle("Prefers scrolling expands when scrolled to edge", isOn: $properties.prefersScrollingExpandsWhenScrolledToEdge)
            Toggle("Use custom corner radius", isOn: .init(get: { properties.preferredCornerRadius != nil }, set: { flag in withAnimation { properties.preferredCornerRadius = flag ? Theme.cornerRadius : nil } }))
            if properties.preferredCornerRadius != nil {
                Slider(value: .init(get: { properties.preferredCornerRadius ?? 0 }, set: { properties.preferredCornerRadius = $0 }), in: 0...UIScreen.main.bounds.width / 2.0)
            }
            HStack {
                Text("Detents")
                Spacer()
                Button("Medium") {
                    if hasMediumDetent {
                        var detents = properties.detents
                        detents.remove(at: properties.detents.firstIndex(where: { $0 == UISheetPresentationController.Detent.medium() })!)
                        if detents.count == 0 {
                            detents.append(UISheetPresentationController.Detent.large())
                        }
                        properties.detents = detents
                    } else {
                        properties.detents.append(UISheetPresentationController.Detent.medium())
                    }
                }
                .tint(.white)
                .padding(.horizontal, Theme.spacing3x)
                .frame(minHeight: Theme.spacing11x)
                .background(RoundedRectangle(cornerRadius: Theme.cornerRadius).fill(hasMediumDetent ? .blue : .gray))
                Button("Large") {
                    if hasLargeDetent {
                        var detents = properties.detents
                        detents.remove(at: properties.detents.firstIndex(where: { $0 == UISheetPresentationController.Detent.large() })!)
                        if detents.count == 0 {
                            detents.append(UISheetPresentationController.Detent.medium())
                        }
                        properties.detents = detents
                    } else {
                        properties.detents.append(UISheetPresentationController.Detent.large())
                    }
                }
                .tint(.white)
                .padding(.horizontal, Theme.spacing3x)
                .frame(minHeight: Theme.spacing11x)
                .background(RoundedRectangle(cornerRadius: Theme.cornerRadius).fill(hasLargeDetent ? .blue : .gray))
            }
            HStack {
                Text("Selected detent identifier")
                Spacer()
                Picker("Selected detent identifier", selection: .init(get: { properties.selectedDetentIdentifier?.wrappedValue ?? .none }, set: {
                    selectedDetentIdentifier = $0 == .none ? nil : $0
                    properties.selectedDetentIdentifier = $0  == .none ? nil : $selectedDetentIdentifier
                })) {
                    Text("Medium").tag(UISheetPresentationController.Detent.Identifier.medium)
                    Text("Large").tag(UISheetPresentationController.Detent.Identifier.large)
                    Text("None").tag(UISheetPresentationController.Detent.Identifier.none)
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(.white)
                .padding(.horizontal, Theme.spacing3x)
                .frame(minHeight: Theme.spacing11x)
                .background(RoundedRectangle(cornerRadius: Theme.cornerRadius).fill(properties.selectedDetentIdentifier?.wrappedValue == nil ? .gray : .blue))
            }
            HStack {
                Text("Largest undimmed detent identifier")
                Spacer()
                Picker("Largest undimmed detent identifier", selection: .init(get: { properties.largestUndimmedDetentIdentifier ?? UISheetPresentationController.Detent.Identifier.none }, set: { properties.largestUndimmedDetentIdentifier = $0 == UISheetPresentationController.Detent.Identifier.none ? nil : $0 })) {
                    Text("Medium").tag(UISheetPresentationController.Detent.Identifier.medium)
                    Text("Large").tag(UISheetPresentationController.Detent.Identifier.large)
                    Text("None").tag(UISheetPresentationController.Detent.Identifier.none)
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(.white)
                .padding(.horizontal, Theme.spacing3x)
                .frame(minHeight: Theme.spacing11x)
                .background(RoundedRectangle(cornerRadius: Theme.cornerRadius).fill(properties.largestUndimmedDetentIdentifier == nil ? .gray : .blue))
            }
        }
    }
    
    var hasLargeDetent: Bool {
        properties.detents.contains(UISheetPresentationController.Detent.large())
    }
    
    var hasMediumDetent: Bool {
        properties.detents.contains(UISheetPresentationController.Detent.medium())
    }
}

