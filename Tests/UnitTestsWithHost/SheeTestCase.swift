//
//  SheeTestCase.swift
//  SheeKitTests
//
//  Created by Eugene Dudnyk on 03/10/2021.
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
@testable import SheeKit
import XCTest

enum ID: String {
    case showPartDetailButton
    case changePartDetailButton
}

struct ShowPartDetail: View {
    var onDismiss: () -> Void
    @State var sheetDetail: InventoryItem?
    var body: some View {
        ZStack {
            HStack {
                Button("Show Part Details") {
                    sheetDetail = InventoryItem(
                        id: "0123456789",
                        partNumber: "Z-1234A",
                        quantity: 100,
                        name: "Widget")
                }
                .frame(maxWidth: .infinity)
                ._identified(by: ID.showPartDetailButton)
                Button("Change Part Details") {
                    if sheetDetail?.quantity ?? 0 < 100500 {
                        sheetDetail = InventoryItem(
                            id: "9876543210",
                            partNumber: "A-4321Z",
                            quantity: 100500,
                            name: "Gadget")
                    } else {
                        sheetDetail = nil
                    }
                }
                .frame(maxWidth: .infinity)
                ._identified(by: ID.changePartDetailButton)
            }
            .frame(maxWidth: .infinity)
            .shee(item: $sheetDetail,
                  presentationStyle: presentationStyle,
                  onDismiss: onDismiss) { detail in
                VStack(alignment: .leading, spacing: 20) {
                    Text("Part Number: \(detail.partNumber)")
                    Text("Name: \(detail.name)")
                    Text("Quantity On-Hand: \(detail.quantity)")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.red)
    }
    
    var presentationStyle: ModalPresentationStyle {
        var sheetProperties = SheetProperties()
        sheetProperties.detents = sheetDetail?.quantity ?? 0 > 100500 ? [ .large() ] : [ .medium() ]
        return .formSheet(properties: sheetProperties)
    }
}

struct InventoryItem: Identifiable {
    var id: String
    let partNumber: String
    let quantity: Int
    let name: String
}

final class SheeTestCase: ViewTestCase {
    var dismissCounter: Int = 0
    
    @ViewBuilder
    override func initRootView() -> AnyView {
        AnyView(ShowPartDetail { [weak self] in
            guard let self = self else { return }
            self.dismissCounter += 1
        })
    }
    
    override func setUp() {
        super.setUp()
        UIView.setAnimationsEnabled(false)
    }
    
    override func tearDown() {
        super.tearDown()
        UIView.setAnimationsEnabled(true)
    }
    
    var presentedViewController: UIHostingController<AnyView>? {
        window?
            .rootViewController?
            .presentedViewController as? UIHostingController<AnyView>
    }
    
    func testItemChangedTwiceDismissedTwice() {
        guard let viewTest = viewTest else {
            XCTFail("No view to test.")
            return
        }
        
        viewTest.render(seconds: 1)
        let bounds = UIScreen.main.bounds
        viewTest.sendTouchSequence([
            (location: CGPoint(x: bounds.maxX * 0.25, y: bounds.midY), globalLocation: nil, timestamp: Date())
        ])
        viewTest.render(seconds: 1)
        viewTest.turnRunloop(times: 20)
        guard let _ = presentedViewController else {
            XCTFail("No presented view to test.")
            return
        }
        viewTest.sendTouchSequence([
            (location: CGPoint(x: bounds.maxX * 0.75, y: bounds.midY), globalLocation: nil, timestamp: Date())
        ])
        viewTest.render(seconds: 1)
        viewTest.turnRunloop(times: 10)
        viewTest.sendTouchSequence([
            (location: CGPoint(x: bounds.maxX * 0.75, y: bounds.midY), globalLocation: nil, timestamp: Date())
        ])
        viewTest.render(seconds: 1)
        viewTest.turnRunloop(times: 10)
        XCTAssertEqual(dismissCounter, 2)
        XCTAssertNil(presentedViewController)
    }
    
    func testItemChangedTwiceDismissedOnce() {
        guard let viewTest = viewTest else {
            XCTFail("No view to test.")
            return
        }
        viewTest.render(seconds: 1)
        let bounds = UIScreen.main.bounds
        viewTest.sendTouchSequence([
            (location: CGPoint(x: bounds.maxX * 0.25, y: bounds.midY), globalLocation: nil, timestamp: Date())
        ])
        viewTest.render(seconds: 1)
        viewTest.turnRunloop(times: 10)
        guard let _ = presentedViewController else {
            XCTFail("No presented view to test.")
            return
        }
        viewTest.sendTouchSequence([
            (location: CGPoint(x: bounds.maxX * 0.75, y: bounds.midY), globalLocation: nil, timestamp: Date())
        ])
        viewTest.sendTouchSequence([
            (location: CGPoint(x: bounds.maxX * 0.75, y: bounds.midY), globalLocation: nil, timestamp: Date())
        ])
        viewTest.render(seconds: 1)
        viewTest.turnRunloop(times: 10)
        XCTAssertEqual(dismissCounter, 1)
        XCTAssertNil(presentedViewController)
        UIView.setAnimationsEnabled(true)
    }
}
