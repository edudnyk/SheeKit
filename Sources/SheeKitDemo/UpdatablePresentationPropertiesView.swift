//
//  UpdatableSheetPresentationPropertiesView.swift
//  SheeKitDemo
//
//  Created by Eugene Dudnyk on 30/09/2021.
//
//  MIT License
//
//  Copyright (c) 2021-2022 Eugene Dudnyk
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
struct UpdatableSheetPresentationPropertiesView: View {
    @EnvironmentObject private var sheetProperties: SheetPropertiesObservable
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing4x) {
            Toggle("Prefers edge attached in compact height", isOn: $sheetProperties.prefersEdgeAttachedInCompactHeight)
            Toggle("Width follows preferred content size when edge attached", isOn: $sheetProperties.widthFollowsPreferredContentSizeWhenEdgeAttached)
            Toggle("Prefers grabber visible", isOn: $sheetProperties.prefersGrabberVisible)
            Toggle("Animates selected detent identifier change", isOn: $sheetProperties.animatesSelectedDetentIdentifierChange)
            Toggle("Prefers scrolling expands when scrolled to edge", isOn: $sheetProperties.prefersScrollingExpandsWhenScrolledToEdge)
            Toggle("Use custom corner radius", isOn: .init(get: { sheetProperties.preferredCornerRadius != nil }, set: { flag in withAnimation { sheetProperties.preferredCornerRadius = flag ? Theme.cornerRadius : nil } }))
            if sheetProperties.preferredCornerRadius != nil {
                Slider(value: .init(get: { sheetProperties.preferredCornerRadius ?? 0 }, set: { sheetProperties.preferredCornerRadius = $0 }), in: 0...UIScreen.main.bounds.width / 2.0)
            }
            HStack {
                Text("Detents")
                Spacer()
                Button("Medium") {
                    if hasMediumDetent {
                        var detents = sheetProperties.detents
                        detents.remove(at: sheetProperties.detents.firstIndex(where: { $0 == UISheetPresentationController.Detent.medium() })!)
                        if detents.count == 0 {
                            detents.append(UISheetPresentationController.Detent.large())
                        }
                        sheetProperties.detents = detents
                    } else {
                        sheetProperties.detents.append(UISheetPresentationController.Detent.medium())
                    }
                }
                .applyButtonStyle(isSelected: hasMediumDetent)
                Button("Large") {
                    if hasLargeDetent {
                        var detents = sheetProperties.detents
                        detents.remove(at: sheetProperties.detents.firstIndex(where: { $0 == UISheetPresentationController.Detent.large() })!)
                        if detents.count == 0 {
                            detents.append(UISheetPresentationController.Detent.medium())
                        }
                        sheetProperties.detents = detents
                    } else {
                        sheetProperties.detents.append(UISheetPresentationController.Detent.large())
                    }
                }
                .applyButtonStyle(isSelected: hasLargeDetent)
            }
            HStack {
                Text("Selected detent identifier")
                Spacer()
                Picker("Selected detent identifier", selection: $sheetProperties.selectedDetentIdentifier) {
                    Text("Medium").tag(Optional(UISheetPresentationController.Detent.Identifier.medium))
                    Text("Large").tag(Optional(UISheetPresentationController.Detent.Identifier.large))
                    Text("None").tag(Optional<UISheetPresentationController.Detent.Identifier>.none)
                }
                .pickerStyle(MenuPickerStyle())
                .applyButtonStyle(isSelected: sheetProperties.selectedDetentIdentifier != nil)
            }
            HStack {
                Text("Largest undimmed detent identifier")
                Spacer()
                Picker("Largest undimmed detent identifier", selection: $sheetProperties.largestUndimmedDetentIdentifier) {
                    Text("Medium").tag(Optional(UISheetPresentationController.Detent.Identifier.medium))
                    Text("Large").tag(Optional(UISheetPresentationController.Detent.Identifier.large))
                    Text("None").tag(Optional<UISheetPresentationController.Detent.Identifier>.none)
                }
                .pickerStyle(MenuPickerStyle())
                .applyButtonStyle(isSelected: sheetProperties.largestUndimmedDetentIdentifier != nil)
            }
        }
    }
    
    private var hasLargeDetent: Bool {
        sheetProperties.detents.contains(UISheetPresentationController.Detent.large())
    }
    
    private var hasMediumDetent: Bool {
        sheetProperties.detents.contains(UISheetPresentationController.Detent.medium())
    }
}

