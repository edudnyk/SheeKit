//
//  PreferredContentSizeView.swift
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

struct PreferredContentSizeView: View {
    @Binding var preferredContentSize: CGSize
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing4x) {
            Text("Preferred content size")
            HStack{
                Text("Width:")
                Spacer()
                Text(String(format:"%.2f pt", preferredContentSize.width))
            }
            Slider(value: $preferredContentSize.width, in: 0...UIScreen.main.bounds.width)
            HStack{
                Text("Height:")
                Spacer()
                Text(String(format:"%.2f pt", preferredContentSize.height))
            }
            Slider(value: $preferredContentSize.height, in: 0...UIScreen.main.bounds.height)
        }
    }
}
