//
//  PresenterController.swift
//  SheeKit
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

final class SheetPresenterController: UIViewController {
    private final class AppearanceCallbackView: UIView {
        override class var layerClass: AnyClass { CATransformLayer.self }
        var onAppearCallback: (() -> Void)?
        override func didMoveToWindow() {
            if window != nil {
                onAppearCallback?()
                onAppearCallback = nil
            }
        }
        
        @MainActor
        func scheduleOnAppear(_ closure: @escaping () -> Void) {
            if window != nil {
                closure()
            } else {
                onAppearCallback = closure
            }
        }
        
        @MainActor
        func cancelSheduledOnAppear() {
            onAppearCallback = nil
        }
    }
    
    override func loadView() {
        view = AppearanceCallbackView()
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @MainActor
    func scheduleOnAppear(_ closure: @escaping () -> Void) {
        guard let appearanceCallbackView = view as? AppearanceCallbackView else { return }
        appearanceCallbackView.scheduleOnAppear(closure)
    }
    
    @MainActor
    func cancelSheduledOnAppear() {
        guard isViewLoaded, let appearanceCallbackView = view as? AppearanceCallbackView else { return }
        appearanceCallbackView.cancelSheduledOnAppear()
    }
}

private extension UIView {
    var nextResponderViewController: UIViewController? {
        guard let next = next as? UIViewController else {
            if let next = next as? UIView {
                return next.nextResponderViewController
            } else {
                return nil
            }
        }
        return next
    }
}

struct SheetPresenterControllerRepresentable<Item>: UIViewControllerRepresentable where Item : Identifiable {
    @Binding var item: Item?
    let onDismiss: (() -> Void)?
    let sheetHostProvider: (AdaptiveDelegate<Item>, UIViewController, Item, DismissAction) -> SheetHostingController<Item>
    let sheetHostUpdater: (AdaptiveDelegate<Item>, UIViewController, Bool, DismissAction) -> Void
    
    func makeCoordinator() -> AdaptiveDelegate<Item> {
        if #available(iOS 15, *) {
            return AdaptiveSheetDelegate()
        } else {
            return .init()
        }
    }

    func makeUIViewController(context: Context) -> SheetPresenterController { .init() }

    func updateUIViewController(_ presenter: SheetPresenterController, context: Context) {
        let coordinator = context.coordinator
        let dismissAction = dismissAction(coordinator)
        coordinator.dismissedByUserCallback = dismissAction
        let isCurrentItemSheet = updateSheet(presenter, context: context)
        if let sheetHost = coordinator.sheetHost,
           sheetHost.itemId != nil,
           let presentingViewController = sheetHost.presentingViewController,
           !isCurrentItemSheet {
            sheetHost.itemId = nil
            presentingViewController.dismiss(animated: true, completion: coordinator.performNextPresentationIfNeeded)
            onDismiss?()
        }
        if item != nil,
           !isCurrentItemSheet {
            presenter.scheduleOnAppear { [weak coordinator, weak presenter] in
                guard let item = item,
                      let coordinator = coordinator,
                      coordinator.sheetHost?.itemId != item.id,
                      let presenter = presenter else { return }
                if presenter.parent == nil,
                   let superview = presenter.view.superview,
                   let parent = superview.nextResponderViewController,
                   presenter.view.isDescendant(of: parent.view)
                {
                    parent.addChild(presenter)
                    presenter.didMove(toParent: parent)
                }
                let worker = { [weak coordinator, weak presenter] in
                    guard let coordinator = coordinator,
                          let presenter = presenter,
                          let item = self.item,
                          coordinator.sheetHost?.itemId == nil
                    else { return }
                    let sheetHost = sheetHostProvider(coordinator, presenter, item, dismissAction)
                    sheetHost.onDismiss = onDismiss
                    sheetHost.presentationController?.delegate = coordinator
                    presenter.present(sheetHost, animated: true)
                }
                if let previousSheetHost = coordinator.sheetHost,
                   previousSheetHost.itemId == nil,
                   previousSheetHost.presentingViewController != nil {
                    coordinator.nextPresentation = worker
                } else {
                    coordinator.nextPresentation = nil
                    worker()
                }
            }
        }
    }
    
    func updateSheet(_ presenter: SheetPresenterController, context: Context) -> Bool {
        guard let sheetHost = context.coordinator.sheetHost,
              sheetHost.presentingViewController != nil else { return false }
        let isCurrentItemSheet = item != nil && sheetHost.itemId == item?.id
        if isCurrentItemSheet, let item = item {
            sheetHost.item = item
            sheetHost.onDismiss = onDismiss
        }
        sheetHostUpdater(context.coordinator, presenter, isCurrentItemSheet, dismissAction(context.coordinator))
        return isCurrentItemSheet
    }
    
    static func dismantleUIViewController(_ presenter: SheetPresenterController, coordinator: AdaptiveDelegate<Item>) {
        if let sheetHost = coordinator.sheetHost,
           let presentingViewController = sheetHost.presentingViewController,
           sheetHost.itemId != nil {
            sheetHost.itemId = nil
            presentingViewController.dismiss(animated: true)
            sheetHost.onDismiss?()
        }

        presenter.cancelSheduledOnAppear()
        coordinator.nextPresentation = nil
        coordinator.sheetHost = nil

        if presenter.parent != nil {
            presenter.willMove(toParent: nil)
            if presenter.isViewLoaded {
                presenter.view.removeFromSuperview()
            }
            presenter.removeFromParent()
        }
    }
    
    func dismissAction(_ coordinator: AdaptiveDelegate<Item>) -> DismissAction {
        let currentItemId = item?.id
        return .init { [weak coordinator] in
            guard let coordinator = coordinator,
                  let currentItemId = currentItemId,
                  coordinator.sheetHost?.itemId == currentItemId else { return }
            self.item = nil
            if coordinator.sheetHost?.presentingViewController == nil {
                /// Dismissal transition already ended,
                /// ``sheetHost`` has been dismissed by the user via interactive dismiss
                coordinator.sheetHost?.itemId = nil
                onDismiss?()
            }
        }
    }
}
