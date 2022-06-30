//
//  UIViewControllerProxy.swift
//  SheeKit
//
//  Created by Eugene Dudnyk on 30/09/2021.
//
//  MIT License
//
//  Copyright (c) 2021-2022 Eugene Dudnyk
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

/// The proxy with preferred parameters of the presented view controller that hosts the presented `View`.
public struct UIViewControllerProxy {
    
    /// Optionally override the interface style of the presented view controller.
    ///
    /// This property allows optionally overriding the interface style of the prsented view contoller if set
    /// To change the interface sytle, you must set this property before presenting the `View`. The default value for this property is `nil, which results in inherting the interface style of the current application `.
    /// Possible interface styles are .dark, .light. See the documenation for UIUserInterfaceStyle for more details.
    public var overrideUserInterfaceStyle: UIUserInterfaceStyle? = nil
    
    /// The transition style to use when presenting the view controller.
    ///
    /// This property determines how the `View` is animated onscreen when it is presented.
    /// To change the transition type, you must set this property before presenting the `View`. The default value for this property is `UIModalTransitionStyle.coverVertical`.
    /// For a list of possible transition styles, and their compatibility with the available presentation styles, see the `UIModalTransitionStyle` constant descriptions.
    public var modalTransitionStyle: UIModalTransitionStyle = .coverVertical
    
    /// Specifies whether a `View` takes over control of status bar appearance from the presenting `View`.
    ///
    /// The default value of this property is `false`.
    /// When you present a `View` by calling the `shee() { ... }` method, status bar appearance control is not transferred from the presenting to the presented `View`.
    /// By setting this property to `true`, you specify the presented view controller controls status bar appearance, even though presented non-fullscreen.
    public var modalPresentationCapturesStatusBarAppearance = false
    
    /// Specifies whether the current input view is dismissed automatically when changing controls.
    ///
    /// The default value of this property is `nil`, in which case the presented `View` uses the `true` value when the presentation style
    /// of the `View` is set to ``ModalPresentationStyle/formSheet(properties:)`` and uses `false` for other presentation styles.
    /// Thus, the system normally does not allow the keyboard to be dismissed for modal forms.
    /// Set the explicit value to allow or disallow the dismissal of the current input view (usually the system keyboard) when changing from a control that wants the input view to one that does not.
    /// Under normal circumstances, when the user taps a control that requires an input view, the system automatically displays that view.
    /// Tapping in a control that does not want an input view subsequently causes the current input view to be dismissed but may not in all cases.
    /// You can set the explicit value in those outstanding cases to allow the input view to be dismissed or use this property to prevent the view from being dismissed in other cases.
    public var disablesAutomaticKeyboardDismissal: Bool?
    
    /// The preferred size for the `View`.
    ///
    /// The value in this property is used primarily when displaying the `View` in a popover but may also be used in other situations,
    /// for example when the `View` is displayed in a form sheet.
    /// Changing the value of this property while the `View` is being displayed in a popover animates the size change;
    /// however, the change is not animated if you specify a width or height of `0.0`.
    public var preferredContentSize: CGSize = .zero
    
    /// The preferred status bar style for the `View`.
    public var preferredStatusBarStyle: UIStatusBarStyle?
    
    /// Specifies whether the view controller prefers the status bar to be hidden or shown.
    public var prefersStatusBarHidden: Bool?
    
    /// Specifies the animation style to use for hiding and showing the status bar for the `View`.
    ///
    /// Default value is `nil`, in which case system uses `UIStatusBarAnimation.fade`.
    /// This property comes into play only when you actively change the status bar’s show/hide state by changing the ``prefersStatusBarHidden`` attribute.
    public var preferredStatusBarUpdateAnimation: UIStatusBarAnimation?
    
    /// Specifies whether the presentation hosting the `View` is forced into modal behavior.
    ///
    /// When this is active, the presentation will prevent interactive dismiss and ignore events outside of the presented `View` bounds until this is set to `false`.
    public var isModalInPresentation: Bool = false
    
    /// Specifies whether the presented view is covered when the view or one of its descendants presents a view.
    ///
    /// When using the ``ModalPresentationStyle/overCurrentContext`` style to present a view,
    /// this property controls which existing view controller in your view controller hierarchy is actually covered by the new content.
    /// When a context-based presentation occurs, UIKit starts at the presenting view controller and walks up the view controller hierarchy.
    /// If it finds a view controller whose value for this property is true, it asks that view controller to present the new view controller.
    /// If no view controller defines the presentation context, UIKit asks the window’s root view controller to handle the presentation.
    ///
    /// The default value for this property is `false`.
    /// Some system-provided view controllers, such as `UINavigationController`, change the default value to `true`.
    public var definesPresentationContext: Bool = false
    
    /// Specifies whether the view controller specifies the transition style for view controllers it presents.
    ///
    /// When a view controller’s ``definesPresentationContext`` property is `true`, it can replace the transition style of the presented view with its own.
    /// When the value of this property is set to `true`, the current view’s transition style is used instead of the style associated with the presented view.
    /// When the value of this property is `false`, UIKit uses the transition style of the presented view.
    ///
    /// The default value of this property is `false`.
    public var providesPresentationContextTransitionStyle: Bool = false
    
    /// Specifies whether an item that previously was focused should again become focused when the item's view controller becomes visible and focusable.
    ///
    /// When the value of this property is `true`, the item that was last focused automatically becomes focused when its view controller becomes visible and focusable.
    /// For example, if an item in the view controller is focused and a second view controller is presented, the original item becomes focused again when the second view controller is dismissed.
    ///
    /// The default value of this property is `true`.
    public var restoresFocusAfterTransition: Bool = true
    
    /// The identifier of the focus group that this view belongs to.
    ///
    /// If this is `nil`, the view inherits the focus group of its parent focus environment.
    ///
    /// The default value of this property is `nil`.
    public var focusGroupIdentifier: String?
    
    /// The screen edges for which you want your gestures to take precedence over the system gestures.
    ///
    /// Normally, the screen-edge gestures defined by the system take precedence over any gesture recognizers that you define.
    /// The system uses its gestures to implement system level behaviors, such as to display Control Center.
    ///
    /// Whenever possible, you should allow the system gestures to take precedence.
    /// However, immersive apps can use this property to allow app-defined gestures to take precedence over the system gestures.
    /// You do that by explicitly setting the screen edges for which your gestures should take precedence.
    public var preferredScreenEdgesDeferringSystemGestures: UIRectEdge?
    
    /// Specifies whether the view prefers to lock the pointer to a specific scene.
    ///
    /// The default is `false`. Setting this property to `true` indicates the view’s preference to lock the pointer, although the system may not honor the request.
    /// For the system to consider locking the pointer:
    /// * The scene must be full screen, not in Split View or Slide Over, with no other apps in Slide Over.
    /// * The scene must be in the `UIScene.ActivationState.foregroundActive` state.
    /// * In Mac Catalyst, the app must be in the foreground, and the window that contains the scene ordered to the front.
    ///
    /// - Note: Bringing a Mac Catalyst app to the foreground doesn’t immediately enable pointer lock.
    ///         To enable pointer lock, the user must click in the window.
    ///         To exit pointer lock, users can use cmd-tab to switch to another app, or using cmd-tilde.
    ///
    /// - Note: Changing this property makes an effect only starting from iOS 14.
    ///
    /// The system continuously monitors the state and when the app no longer satisfies the requirements, it disables the pointer lock.
    ///
    /// When the lock state changes, the system posts `UIPointerLockState.didChangeNotification`.
    public var prefersPointerLocked: Bool?
    
    /// Specifies whether the system is allowed to hide the visual indicator for returning to the Home screen.
    ///
    /// Default value is `nil`, in which case system interprets it as `false`.
    /// Set this value to `true` if your view lets the system determine when to hide the indicator, or `false` if you want the indicator shown at all times.
    /// The system takes your preference into account, but setting to `true` is no guarantee that the indicator will be hidden.
    public var prefersHomeIndicatorAutoHidden: Bool?
    
    public init() {}
}
