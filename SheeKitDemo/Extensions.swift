//
//  Extensions.swift
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

extension ModalPresentationStyle: Identifiable {
    public static var allCases: [Self] {
        [
            .pageSheet(),
            .formSheet(),
            .overFullScreen,
            .overCurrentContext,
            .popover(),
            .automatic,
        ]
    }
    
    public var id: UIModalPresentationStyle.RawValue { value.rawValue }
    
    var next: Self {
        let sortedCases = Self.allCases.sorted { $0.value.rawValue < $1.value.rawValue }
        if let index = sortedCases.firstIndex(where: { $0.id == self.id }),
           index < sortedCases.count - 1 {
            return sortedCases[index + 1]
        } else {
            return sortedCases[0]
        }
    }
    
    var value: UIModalPresentationStyle {
        switch self {
        case .pageSheet: return .pageSheet
        case .formSheet: return .formSheet
        case .overFullScreen: return .overFullScreen
        case .overCurrentContext: return .overCurrentContext
        case .popover: return .popover
        case .automatic: return .automatic
        case .custom: return .custom
        }
    }
    
    var navigationBarTitle: String {
        switch self {
        case .pageSheet: return "Page Shee"
        case .formSheet: return "Form Shee"
        case .overFullScreen: return "Over FullScreen Shee"
        case .overCurrentContext: return "Over Current Context Shee"
        case .popover: return "Popover Shee"
        case .automatic: return "Automatic Shee"
        case .custom: return "Custom"
        }
    }
    
    var title: String {
        switch self {
        case .pageSheet: return "Sheet Presentation Controller customizations:"
        case .formSheet: return "Sheet Presentation Controller customizations:"
        case .overFullScreen: return "No customizations"
        case .overCurrentContext: return "No customizations"
        case .popover: return "Adaptive Sheet Controller customizations"
        case .automatic: return "No customizations"
        case .custom: return "Custom"
        }
    }
    
    var subtitle: String? {
        switch self {
        case .pageSheet: return nil
        case .formSheet: return nil
        case .overFullScreen: return nil
        case .overCurrentContext: return nil
        case .popover: return "to see as a sheet, run on iPad and open the app on a side in Multitasking mode"
        case .automatic: return nil
        case .custom: return nil
        }
    }
}

extension UISheetPresentationController.Detent.Identifier {
    static let none = UISheetPresentationController.Detent.Identifier(rawValue: "none")
}

extension UIPopoverArrowDirection: Hashable {}
