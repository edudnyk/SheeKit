//
//  Utils.swift
//  SheeKitTests
//
//  Created by Eugene Dudnyk on 02/10/2021.
//

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
