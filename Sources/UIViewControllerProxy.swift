//
//  UIViewControllerProxy.swift
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


import UIKit

public struct UIViewControllerProxy {
    public var modalTransitionStyle: UIModalTransitionStyle = .coverVertical
    public var modalPresentationCapturesStatusBarAppearance = false
    public var disablesAutomaticKeyboardDismissal: Bool?
    public var edgesForExtendedLayout: UIRectEdge = .all
    public var extendedLayoutIncludesOpaqueBars: Bool = false
    public var preferredContentSize: CGSize = .zero
    public var preferredStatusBarStyle: UIStatusBarStyle?
    public var prefersStatusBarHidden: Bool?
    public var preferredStatusBarUpdateAnimation: UIStatusBarAnimation?
    public var isModalInPresentation: Bool = false
    public var definesPresentationContext: Bool = false
    public var providesPresentationContextTransitionStyle: Bool = false
    public var restoresFocusAfterTransition: Bool = true
    public var focusGroupIdentifier: String?
    public var preferredScreenEdgesDeferringSystemGestures: UIRectEdge?
    public var prefersPointerLocked: Bool?
    public var prefersHomeIndicatorAutoHidden: Bool?
    
    internal init(_ sheetHost: UIViewController) {
        modalTransitionStyle = sheetHost.modalTransitionStyle
        modalPresentationCapturesStatusBarAppearance = sheetHost.modalPresentationCapturesStatusBarAppearance
        edgesForExtendedLayout = sheetHost.edgesForExtendedLayout
        extendedLayoutIncludesOpaqueBars = sheetHost.extendedLayoutIncludesOpaqueBars
        preferredContentSize = sheetHost.preferredContentSize
        isModalInPresentation = sheetHost.isModalInPresentation
        definesPresentationContext = sheetHost.definesPresentationContext
        providesPresentationContextTransitionStyle = sheetHost.providesPresentationContextTransitionStyle
        restoresFocusAfterTransition = sheetHost.restoresFocusAfterTransition
        focusGroupIdentifier = sheetHost.focusGroupIdentifier
    }
    
    public init() {}
}
