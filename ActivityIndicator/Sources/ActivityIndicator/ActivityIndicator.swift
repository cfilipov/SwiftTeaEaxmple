#if canImport(UIKit) && canImport(SwiftUI)
import UIKit
import SwiftUI

public struct ActivityIndicator: UIViewRepresentable {
    let style: UIActivityIndicatorView.Style

    public init(style: UIActivityIndicatorView.Style) {
        self.style = style
    }

    public func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    public func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        uiView.startAnimating()
    }
}
#endif
