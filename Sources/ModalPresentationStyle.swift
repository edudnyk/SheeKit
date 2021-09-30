//
//  ModalPresentationStyle.swift
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

public enum ModalPresentationStyle {
    /// The default presentation style chosen by the system.
    case automatic
    /// A presentation style that partially covers the underlying content.
    ///
    /// - Parameters:
    ///   - properties: properties to assign to ``UISheetPresentationController``
    case pageSheet(properties: SheetProperties? = nil)
    /// A presentation style that displays the content centered in the screen.
    ///
    /// - Parameters:
    ///   - properties: properties to assign to ``UISheetPresentationController``
    case formSheet(properties: SheetProperties? = nil)
    /// A view presentation style in which the presented view covers the screen.
    case overFullScreen
    /// A presentation style where the content is displayed over another view controller’s content.
    case overCurrentContext
    /// A presentation style where the content is displayed in a popover view.
    /// - Parameters:
    ///   - permittedArrowDirections: The arrow directions that you allow for the popover.
    ///   - sourceRectTransform: allows to change the ``sourceRect`` of the ``UIPopoverPresentationController``
    ///   - adaptiveSheetProperties: properties to assign to adaptive ``UISheetPresentationController`` which will be used when the app's scene is resized into ``.compact`` horizontal size class (via multitasking).
    case popover(permittedArrowDirections: UIPopoverArrowDirection = .any, sourceRectTransform: ((CGRect) -> CGRect)? = nil, adaptiveSheetProperties: SheetProperties? = nil)
    /// A custom view presentation style that is managed by a custom presentation controller and one or more custom animator objects.
    case custom(transitioningDelegate: UIViewControllerTransitioningDelegate?)
    
    internal func setup(_ viewController: UIViewController, presenter: UIViewController, isInitial: Bool) {
        switch self {
        case .automatic:
            Self.setupModalPresentationStyle(viewController, style: .automatic, isInitial: isInitial)
        case .pageSheet(let properties):
            Self.setupPageSheet(viewController, presenter: presenter, properties: properties, isInitial: isInitial)
        case .formSheet(let properties):
            Self.setupFormSheet(viewController, presenter: presenter, properties: properties, isInitial: isInitial)
        case .overFullScreen:
            Self.setupModalPresentationStyle(viewController, style: .overFullScreen, isInitial: isInitial)
        case .overCurrentContext:
            Self.setupModalPresentationStyle(viewController, style: .overCurrentContext, isInitial: isInitial)
        case .popover(let permittedArrowDirections, let sourceRectTransform, let adaptiveSheetProperties):
            Self.setupPopover(viewController,
                              presenter: presenter,
                              sourceRectTransform: sourceRectTransform,
                              permittedArrowDirections: permittedArrowDirections,
                              adaptiveSheetProperties: adaptiveSheetProperties,
                              isInitial: isInitial)
        case .custom(let transitioningDelegate):
            Self.setupCustom(viewController, transitioningDelegate: transitioningDelegate, isInitial: isInitial)
        }
    }
    
    internal var selectedDetentIdentifierBinding: Binding<UISheetPresentationController.Detent.Identifier?>? {
        switch self {
        case .pageSheet(let properties): return properties?.selectedDetentIdentifier
        case .formSheet(let properties): return properties?.selectedDetentIdentifier
        case .popover(_, _, let adaptiveSheetProperties): return adaptiveSheetProperties?.selectedDetentIdentifier
        default: return nil
        }
    }
    
    private static func setupModalPresentationStyle(_ viewController: UIViewController, style: UIModalPresentationStyle, isInitial: Bool) {
        if isInitial {
            viewController.modalPresentationStyle = style
        }
    }
    
    private static func setupPageSheet(_ viewController: UIViewController, presenter: UIViewController, properties: SheetProperties?, isInitial: Bool) {
        setupModalPresentationStyle(viewController, style: .pageSheet, isInitial: isInitial)
        setup(viewController.sheetPresentationController, presenter: presenter, properties: properties, isInitial: isInitial)
    }
    
    private static func setupFormSheet(_ viewController: UIViewController, presenter: UIViewController, properties: SheetProperties?, isInitial: Bool) {
        setupModalPresentationStyle(viewController, style: .formSheet, isInitial: isInitial)
        setup(viewController.sheetPresentationController, presenter: presenter, properties: properties, isInitial: isInitial)
    }
    
    private static func setupPopover(_ viewController: UIViewController,
                                     presenter: UIViewController,
                                     sourceRectTransform: ((CGRect) -> CGRect)?,
                                     permittedArrowDirections: UIPopoverArrowDirection,
                                     adaptiveSheetProperties: SheetProperties?,
                                     isInitial: Bool) {
        setupModalPresentationStyle(viewController, style: .popover, isInitial: isInitial)
        if isInitial {
            viewController.popoverPresentationController?.sourceView = presenter.view
        }
        if isInitial {
            let sourceRect = sourceRectTransform?(presenter.view.bounds) ?? presenter.view.bounds
            viewController.popoverPresentationController?.sourceRect = sourceRect
        }
        if isInitial {
            viewController.popoverPresentationController?.permittedArrowDirections = permittedArrowDirections
        }
        setup(viewController.popoverPresentationController?.adaptiveSheetPresentationController, presenter: presenter, properties: adaptiveSheetProperties, isInitial: isInitial)
    }
    
    private static func setupCustom(_ viewController: UIViewController, transitioningDelegate: UIViewControllerTransitioningDelegate?, isInitial: Bool) {
        setupModalPresentationStyle(viewController, style: .custom, isInitial: isInitial)
        viewController.transitioningDelegate = transitioningDelegate
    }
    
    private static func setup(_ sheetPresentationController: UISheetPresentationController?, presenter: UIViewController, properties: SheetProperties?, isInitial: Bool) {
        guard let sheetPresentationController = sheetPresentationController,
              let properties = properties
        else { return }
        
        if sheetPresentationController.prefersEdgeAttachedInCompactHeight != properties.prefersEdgeAttachedInCompactHeight {
            sheetPresentationController.prefersEdgeAttachedInCompactHeight = properties.prefersEdgeAttachedInCompactHeight
        }

        if sheetPresentationController.widthFollowsPreferredContentSizeWhenEdgeAttached != properties.widthFollowsPreferredContentSizeWhenEdgeAttached {
            sheetPresentationController.widthFollowsPreferredContentSizeWhenEdgeAttached = properties.widthFollowsPreferredContentSizeWhenEdgeAttached
        }

        if sheetPresentationController.prefersGrabberVisible != properties.prefersGrabberVisible {
            sheetPresentationController.prefersGrabberVisible = properties.prefersGrabberVisible
        }

        if sheetPresentationController.preferredCornerRadius != properties.preferredCornerRadius {
            sheetPresentationController.preferredCornerRadius = properties.preferredCornerRadius
        }
        
        if !sheetPresentationController.detents.elementsEqual(properties.detents) {
            sheetPresentationController.detents = properties.detents
        }

        if sheetPresentationController.selectedDetentIdentifier != properties.selectedDetentIdentifier?.wrappedValue {
            let setter = {
                sheetPresentationController.selectedDetentIdentifier = properties.selectedDetentIdentifier?.wrappedValue
            }
            if !isInitial, properties.animatesSelectedDetentIdentifierChange {
                sheetPresentationController.animateChanges(setter)
            } else {
                setter()
            }
        }

        if sheetPresentationController.largestUndimmedDetentIdentifier != properties.largestUndimmedDetentIdentifier {
            sheetPresentationController.largestUndimmedDetentIdentifier = properties.largestUndimmedDetentIdentifier
        }

        if sheetPresentationController.prefersScrollingExpandsWhenScrolledToEdge != properties.prefersScrollingExpandsWhenScrolledToEdge {
            sheetPresentationController.prefersScrollingExpandsWhenScrolledToEdge = properties.prefersScrollingExpandsWhenScrolledToEdge
        }
        
        if isInitial {
            sheetPresentationController.sourceView = properties.shouldAdjustToSourceView ? presenter.view : nil
        }
    }
}
