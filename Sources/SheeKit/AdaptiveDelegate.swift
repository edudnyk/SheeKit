//
//  AdaptiveDelegate.swift
//  SheeKit
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

class AdaptiveDelegate<Item>: NSObject, UIPopoverPresentationControllerDelegate where Item : Identifiable {
    var performNextPresentationIfNeeded: (() -> Void)?
    var dismissedByUserCallback: DismissAction?
    var isInteractiveDismissDisabled = false
    var nextPresentation: (() -> Void)?
    weak var sheetHost: SheetHostingController<Item>?

    override init() {
        super.init()
        performNextPresentationIfNeeded = { [weak self] in
            guard let nextPresentation = self?.nextPresentation else { return }
            self?.nextPresentation = nil
            nextPresentation()
        }
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        dismissedByUserCallback?()
    }

    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        !isInteractiveDismissDisabled
    }
}

@available(iOS 15.0, *)
final class AdaptiveSheetDelegate<Item>: AdaptiveDelegate<Item>, UISheetPresentationControllerDelegate where Item : Identifiable {

    var selectedDetentIdentifierBinding: Binding<UISheetPresentationController.Detent.Identifier?>?

    override init() { super.init() }
    
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        selectedDetentIdentifierBinding?.wrappedValue = sheetPresentationController.selectedDetentIdentifier
    }
}
