//
//  Extensions.swift
//  SheeKit
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

private struct TrueIdentifiable: Identifiable {
    var id: Bool { true }
}

extension View {
    /// Presents a sheet using the given item as a data source
    /// for the sheet's content.
    ///
    /// Use this method when you need to present a modal view with content
    /// from a custom data source. The example below shows a custom data source
    /// `InventoryItem` that the `content` closure uses to populate the display
    /// the action sheet shows to the user:
    ///
    /// ```swift
    ///     struct ShowPartDetail: View {
    ///         @State var sheetDetail: InventoryItem?
    ///         var body: some View {
    ///             Button("Show Part Details") {
    ///                 sheetDetail = InventoryItem(
    ///                     id: "0123456789",
    ///                     partNumber: "Z-1234A",
    ///                     quantity: 100,
    ///                     name: "Widget")
    ///             }
    ///             .shee(item: $sheetDetail,
    ///                   onDismiss: didDismiss) { detail in
    ///                 VStack(alignment: .leading, spacing: 20) {
    ///                     Text("Part Number: \(detail.partNumber)")
    ///                     Text("Name: \(detail.name)")
    ///                     Text("Quantity On-Hand: \(detail.quantity)")
    ///                 }
    ///                 .onTapGesture {
    ///                     sheetDetail = nil
    ///                 }
    ///             }
    ///         }
    ///
    ///         func didDismiss() {
    ///             // Handle the dismissing action.
    ///         }
    ///     }
    ///
    ///     struct InventoryItem: Identifiable {
    ///         var id: String
    ///         let partNumber: String
    ///         let quantity: Int
    ///         let name: String
    ///     }
    /// ```
    ///
    /// ![A view showing a custom structure acting as a data source, providing
    /// data to a modal sheet.](SwiftUI-View-SheetItemContent.png)
    ///
    /// - Parameters:
    ///   - item: A binding to an optional source of truth for the sheet.
    ///     When `item` is non-`nil`, the system passes the item's content to
    ///     the modifier's closure. You display this content in a sheet that you
    ///     create that the system displays to the user. If `item` changes,
    ///     the system dismisses the sheet and replaces it with a new one
    ///     using the same process.
    ///   - presentationStyle: the ``ModalPresentationStyle`` which configures the presentation of the `content`.
    ///   - presentedViewControllerParameters: the preferred parameters of the presented view controller.
    ///   - onDismiss: The closure to execute when dismissing the sheet.
    ///   - content: A closure returning the content of the sheet.
    @available(iOS 15, *)
    public func shee<Item, Content>(item: Binding<Item?>,
                                    presentationStyle: ModalPresentationStyle = .automatic,
                                    presentedViewControllerParameters: UIViewControllerProxy? = nil,
                                    onDismiss: (() -> Void)? = nil,
                                    @ViewBuilder content: @escaping (Item) -> Content) -> some View where Item : Identifiable, Content : View {
        return self.modifier(SheetModifier(item: item,
                                           presentationStyle: presentationStyle,
                                           presentedViewControllerParameters: presentedViewControllerParameters,
                                           onDismiss: onDismiss,
                                           content: content))
    }
    
    @available(iOS, deprecated: 15, obsoleted: 15) @_disfavoredOverload
    public func shee<Item, Content>(item: Binding<Item?>,
                                    presentationStyle: ModalPresentationStyleCompat = .automatic,
                                    presentedViewControllerParameters: UIViewControllerProxy? = nil,
                                    onDismiss: (() -> Void)? = nil,
                                    @ViewBuilder content: @escaping (Item) -> Content) -> some View where Item : Identifiable, Content : View {
        return self.modifier(SheetModifier(item: item,
                                           presentationStyle: presentationStyle,
                                           presentedViewControllerParameters: presentedViewControllerParameters,
                                           onDismiss: onDismiss,
                                           content: content))
    }


    /// Presents a sheet when a binding to a Boolean value that you
    /// provide is true.
    ///
    /// Use this method when you want to present a modal view to the
    /// user when a Boolean value you provide is true. The example
    /// below displays a modal view of the mockup for a software license
    /// agreement when the user toggles the `isShowingSheet` variable by
    /// clicking or tapping on the "Show License Agreement" button:
    ///
    /// ```swift
    ///     struct ShowLicenseAgreement: View {
    ///         @State private var isShowingSheet = false
    ///         var body: some View {
    ///             Button(action: {
    ///                 isShowingSheet.toggle()
    ///             }) {
    ///                 Text("Show License Agreement")
    ///             }
    ///             .shee(isPresented: $isShowingSheet,
    ///                   onDismiss: didDismiss) {
    ///                 VStack {
    ///                     Text("License Agreement")
    ///                         .font(.title)
    ///                         .padding(50)
    ///                     Text("""
    ///                             Terms and conditions go here.
    ///                         """)
    ///                         .padding(50)
    ///                     Button("Dismiss",
    ///                            action: { isShowingSheet.toggle() })
    ///                 }
    ///             }
    ///         }
    ///
    ///         func didDismiss() {
    ///             // Handle the dismissing action.
    ///         }
    ///     }
    ///  ```
    /// ![A screenshot of a full-screen modal sheet showing the mockup of a
    /// software license agreement with a Dismiss
    /// button.](SwiftUI-View-SheetIsPresentingContent.png)
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the sheet that you create in the modifier's
    ///     `content` closure.
    ///   - presentationStyle: the ``ModalPresentationStyle`` which configures the presentation of the ``content``.
    ///   - presentedViewControllerParameters: the preferred parameters of the presented view controller.
    ///   - onDismiss: The closure to execute when dismissing the sheet.
    ///   - content: A closure that returns the content of the sheet.
    @available(iOS 15, *)
    public func shee<Content>(isPresented: Binding<Bool>,
                              presentationStyle: ModalPresentationStyle = .automatic,
                              presentedViewControllerParameters: UIViewControllerProxy? = nil,
                              onDismiss: (() -> Void)? = nil,
                              @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
        let itemBinding = Binding<TrueIdentifiable?>(get: { isPresented.wrappedValue ? TrueIdentifiable() : nil }, set: { isPresented.wrappedValue = $0 != nil ? true : false })
        return self.modifier(SheetModifier(item: itemBinding,
                                           presentationStyle: presentationStyle,
                                           presentedViewControllerParameters: presentedViewControllerParameters,
                                           onDismiss: onDismiss) { _ in
            content()
        })
    }
    
    @available(iOS, deprecated: 15, obsoleted: 15) @_disfavoredOverload
    public func shee<Content>(isPresented: Binding<Bool>,
                              presentationStyle: ModalPresentationStyleCompat = .automatic,
                              presentedViewControllerParameters: UIViewControllerProxy? = nil,
                              onDismiss: (() -> Void)? = nil,
                              @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
        let itemBinding = Binding<TrueIdentifiable?>(get: { isPresented.wrappedValue ? TrueIdentifiable() : nil }, set: { isPresented.wrappedValue = $0 != nil ? true : false })
        return self.modifier(SheetModifier(item: itemBinding,
                                           presentationStyle: presentationStyle,
                                           presentedViewControllerParameters: presentedViewControllerParameters,
                                           onDismiss: onDismiss) { _ in
            content()
        })
    }
    
    /// Adds a condition that prevents interactive dismissal when the view
    /// is contained within a popover or a sheet.
    ///
    /// On macOS, disabling interactive dismissal in a popover makes the popover
    /// non-transient.
    ///
    /// Use this modifier to disable user-initiated
    /// dismissal of the containing hierarchy. When the condition is true, a
    /// presentation containing the view can only be dismissed programatically,
    /// by setting the environment's `\.shee_dismiss`
    /// or by updating the `Binding` controlling the presentation.
    ///
    /// In the example below, a terms of service sheet is shown. The user cannot
    /// dismiss the sheet unless they have accepted the terms of service.
    ///
    ///     struct PresentingView: View {
    ///         @Binding var showTerms: Bool
    ///
    ///         var body: some View {
    ///             AppContents()
    ///                 .shee(isPresented: $showTerms) {
    ///                     Sheet()
    ///                 }
    ///         }
    ///     }
    ///
    ///     struct Sheet: View {
    ///         @State private var acceptedTerms = false
    ///
    ///         var body: some View {
    ///             Form {
    ///                 Button("Accept Terms") {
    ///                     acceptedTerms = true
    ///                 }
    ///             }
    ///             .shee_interactiveDismissDisabled(!acceptedTerms)
    ///         }
    ///     }
    ///
    /// - Parameter isDisabled: A Boolean that indicates whether dismissal is
    ///   prevented.
    /// - SeeAlso ``UIViewControllerProxy/isModalInPresentation``.
    public func shee_interactiveDismissDisabled(_ isDisabled: Bool = true) -> some View {
        environment(\.shee_isInteractiveDismissDisabled, isDisabled)
    }
}


/// Provides functionality for dismissing a presentation.
///
/// The `DismissAction` instance in the app's `Environment` offers a handler
/// that you can use to dismiss either the `.shee` or any other system presentation.
/// The action has no effect if the view is not currently being presented. You can use
/// `shee_isPresented` to query whether the view is currently
/// being presented.
///
/// Use the `shee_dismiss` environment value to get the handler.
/// Then call the action's handler to perform the dismissal. For example,
/// you can use the action to add a done button to a sheet's toolbar:
///
/// ```swift
///     struct SheetView: View {
///         @Environment(\.shee_dismiss) var dismiss
///
///         var body: some View {
///             NavigationView {
///                 SheetContents()
///                     .toolbar {
///                         Button("Done") {
///                             dismiss()
///                         }
///                     }
///             }
///         }
///     }
/// ```
public struct DismissAction {
    let closure: () -> Void
    
    internal init(_ closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    @available(iOS 15.0, *)
    internal init(_ custom: Self?, system: SwiftUI.DismissAction?) {
        closure = {
            if let custom = custom {
                custom()
            } else {
                system?()
            }
        }
    }

    @available(iOS, deprecated: 15, obsoleted: 15) @_disfavoredOverload
    internal init(_ custom: Self?, system: (() -> Void)?) {
        closure = {
            if let custom = custom {
                custom()
            } else {
                system?()
            }
        }
    }

    /// Dismisses the view if it is currently presented.
    ///
    /// Use this method to attempt to dismiss a presentation. This function
    /// is used when you call the function `dismiss()`.
    public func callAsFunction() { closure() }
}

extension EnvironmentValues {
    private struct SheeDismissActionEnvironmentKey: EnvironmentKey {
        static var defaultValue: DismissAction?
    }

    private struct SheeIsPresentedEnvironmentKey: EnvironmentKey {
        static var defaultValue = false
    }
    
    private struct SheeInteractiveDismissDisabledEnvironmentKey: EnvironmentKey {
        static var defaultValue = false
    }

    /// Dismisses the current presentation.
    public internal(set) var shee_dismiss: DismissAction {
        get {
            if #available(iOS 15, *) {
                return DismissAction(self[SheeDismissActionEnvironmentKey.self], system: self[keyPath: \.dismiss])
            } else {
                let presentationMode = self[keyPath: \.presentationMode]
                let system = {
                    presentationMode.wrappedValue.dismiss()
                }
                return DismissAction(self[SheeDismissActionEnvironmentKey.self], system: system)
            }
        }
        set { self[SheeDismissActionEnvironmentKey.self] = newValue }
    }

    /// A Boolean value that indicates whether the view associated with this
    /// environment is currently being presented.
    public internal(set) var shee_isPresented: Bool {
        get {
            if #available(iOS 15, *) {
                return self[SheeIsPresentedEnvironmentKey.self] || self[keyPath: \.isPresented]
            } else {
                return self[SheeIsPresentedEnvironmentKey.self] || self[keyPath: \.presentationMode].wrappedValue.isPresented
            }
        }
        set { self[SheeIsPresentedEnvironmentKey.self] = newValue }
    }
    
    internal var shee_isInteractiveDismissDisabled: Bool {
        get { self[SheeInteractiveDismissDisabledEnvironmentKey.self] }
        set { self[SheeInteractiveDismissDisabledEnvironmentKey.self] = newValue }
    }
}

@available(iOS 15.0, *)
public struct Shee_Previews: PreviewProvider {
    struct SheetContent: View {
        @Environment(\.shee_dismiss) var dismiss

        var body: some View {
            NavigationView {
                ScrollView {
                    
                    
                }
                .navigationTitle("Shee Kit")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
            }
        }
    }
    
    public static var previews: some View {
        RootView(sheetStyle: .overFullScreen)
    }
    
    struct RootView: View {
        let sheetStyle: ModalPresentationStyle
        @State var isPresented = false
        
        var body: some View {
            HStack {
                Spacer()
                Button("Show") {
                    isPresented = true
                }
                .shee(isPresented: $isPresented, presentationStyle: sheetStyle) { SheetContent() }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

@available(iOS 15.0, *)
public struct Shee_Library: LibraryContentProvider {
    struct SheetContent: View {
        @Environment(\.shee_dismiss) var dismiss

        var body: some View {
            NavigationView {
                ScrollView {
                    Text("Sheet Content is here")
                }
                .navigationTitle("Shee Kit")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
            }
        }
    }
    
    @LibraryContentBuilder
    public func modifiers(base: AnyView) -> [LibraryItem] {
        LibraryItem(base.shee(isPresented: .constant(true),
                              presentationStyle: .formSheet(properties: .init(detents: [.medium(), .large()]))) { SheetContent() },
                    title: "Shee",
                    category: .control,
                    matchingSignature: "shee")
    }
}
