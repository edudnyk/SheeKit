//
//  Utils.swift
//  SheeKitTests
//
//  Created by Eugene Dudnyk on 02/10/2021.
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
import XCTest

extension UIHostingController: _Test where Content == AnyView {}
extension UIHostingController: _ViewTest where Content == AnyView {
    public func initRootView() -> AnyView {
        return rootView
    }
    public func initSize() -> CGSize {
        sizeThatFits(in: UIScreen.main.bounds.size)
    }
}

extension _IdentifiedViewsKey: PreferenceKey {}
extension _ContainedScrollViewKey: PreferenceKey {}

open class ViewTestCase: XCTestCase {
    public var viewTest: UIHostingController<AnyView>?
    open override func setUp() {
        super.setUp()
        let viewTest: UIHostingController<AnyView>?
        if #available(iOS 15, *) {
            viewTest = _makeUIHostingController(initRootView(), tracksContentSize: tracksContentSize) as? UIHostingController<AnyView>
        } else {
            viewTest = _makeUIHostingController(initRootView()) as? UIHostingController<AnyView>
        }
        viewTest?.setUpTest()
        self.viewTest = viewTest
    }
    
    var window: UIWindow? {
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .windows
            .first
    }
    
    @ViewBuilder
    open func initRootView() -> AnyView { AnyView(EmptyView()) }

    @available(iOS 15, *)
    open var tracksContentSize = true
    
    open override func tearDown() {
        viewTest?.tearDownTest()
    }
}
