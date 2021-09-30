//
//  ContentView.swift
//  CustomSheetDemo
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
import SheeKit

struct RootView: View {
    @State var item: ModalPresentationStyle?
    @State var isInitalPropertiesViewPresented = false
    @State var presentedViewControllerParameters = UIViewControllerProxy()
    
    var body: some View {
        NavigationView {
            destination
                .navigationTitle("SheeKit Demo")
                .navigationViewStyle(.columns)
                .navigationBarTitleDisplayMode(.large)
        }
        .environment(\.horizontalSizeClass, .compact)
    }
    
    @ViewBuilder
    var destination: some View {
        VStack {
            HStack {
                Spacer()
                Button("Show") {
                    isInitalPropertiesViewPresented = true
                }
                .tint(.white)
                .padding(.horizontal, Theme.spacing12x)
                .frame(minHeight: Theme.spacing30x)
                .background(RoundedRectangle(cornerRadius: Theme.cornerRadius).fill(item == nil ? .gray : .blue))
                .shee(item: $item, presentationStyle: item ?? .automatic, presentedViewControllerParameters: presentedViewControllerParameters) { item in
                    SheetContentView(item: .init(get: { item }, set: { self.item = $0 }), presentedViewControllerParameters: $presentedViewControllerParameters)
                }
                .shee(isPresented: $isInitalPropertiesViewPresented, presentationStyle: .popover(adaptiveSheetProperties: .init(detents: [.medium()]))) {
                    InitialPresentationPropertiesView(nextItem: .constant(.automatic),
                                                      presentedViewControllerParameters: $presentedViewControllerParameters) { nextItem in
                        item = nextItem
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
