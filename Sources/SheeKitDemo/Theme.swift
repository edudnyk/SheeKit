//
//  Theme.swift
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

enum Theme {
    static let cornerRadius: CGFloat = 12
    static let spacing1x: CGFloat = 4
    static let spacing3x = spacing1x * 3
    static let spacing4x = spacing1x * 4
    static let spacing11x = spacing1x * 11
    static let spacing12x = spacing1x * 12
    static let spacing30x = spacing1x * 30
}

extension View {
    @ViewBuilder
    func applyButtonStyle(isSelected: Bool) -> some View {
        let result =
            padding(.horizontal, Theme.spacing3x)
            .frame(minHeight: Theme.spacing11x)
            .background(RoundedRectangle(cornerRadius: Theme.cornerRadius).fill(isSelected ? .blue : .gray))
            .accentColor(.white)
        if #available(iOS 15, *) {
            result
            .tint(.white)
        } else {
            result
        }
    }
    
    @ViewBuilder
    func applyLargeButtonStyle(isSelected: Bool) -> some View {
        let result =
            padding(.horizontal, Theme.spacing12x)
            .frame(minHeight: Theme.spacing30x)
            .background(RoundedRectangle(cornerRadius: Theme.cornerRadius).fill(isSelected ? .blue : .gray))
            .accentColor(.white)
        if #available(iOS 15, *) {
            result
            .tint(.white)
        } else {
            result
        }
    }
}
