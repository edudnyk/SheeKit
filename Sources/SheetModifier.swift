//
//  CustomSheetModifier.swift
//  CustomSheet
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

struct SheetModifier<Item, SheetContent>: ViewModifier where Item : Identifiable, SheetContent : View {
    @Binding var item: Item?
    let presentationStyle: ModalPresentationStyle
    let presentedViewControllerParameters: UIViewControllerProxy?
    let shouldBeDismissedByUser: (() -> Bool)?
    let onDismiss: (() -> Void)?
    @ViewBuilder
    let content: (Item) -> SheetContent
    @State var proxy = UIViewControllerProxy()
    
    func body(content: Content) -> some View {
        content.overlay(SheetPresenterControllerRepresentable(item: $item,
                                                              shouldBeDismissedByUser: shouldBeDismissedByUser,
                                                              onDismiss: onDismiss,
                                                              sheetHostProvider: sheetHostProvider,
                                                              sheetHostUpdater: sheetHostUpdater).opacity(0).accessibilityHidden(true))
    }
    
    private var sheetHostProvider: (AdaptiveDelegate<Item>, UIViewController, Item, DismissAction) -> SheetHostingController<Item> { { coordinator, presenter, item, dismiss in
        let sheetHost = SheetHostingController(rootView: sheetContent(for: item, isPresented: true, dismiss: dismiss), item: item)
        presentationStyle.setup(sheetHost, presenter: presenter, isInitial: true)
        sheetHost.configure(by: presentedViewControllerParameters)
        coordinator.sheetHost = sheetHost
        coordinator.selectedDetentIdentifierBinding = presentationStyle.selectedDetentIdentifierBinding
        return sheetHost
    } }
    
    private var sheetHostUpdater: (AdaptiveDelegate<Item>, UIViewController, Bool, DismissAction) -> Void { { coordinator, presenter, isPresented, dismiss in
        guard let sheetHost = coordinator.sheetHost else { return }
        if isPresented {
            sheetHost.rootView = sheetContent(for: sheetHost.item, isPresented: isPresented, dismiss: dismiss)
            presentationStyle.setup(sheetHost, presenter: presenter, isInitial: false)
            sheetHost.configure(by: presentedViewControllerParameters)
            coordinator.selectedDetentIdentifierBinding = presentationStyle.selectedDetentIdentifierBinding
        }
    } }
    
    private func sheetContent(for item: Item, isPresented: Bool, dismiss: DismissAction) -> AnyView {
        AnyView(
            content(item)
                .environment(\.shee_isPresented, isPresented)
                .environment(\.shee_dismiss, dismiss)
            )
    }
}
