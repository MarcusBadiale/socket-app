//
//  Landscape+Extensions.swift
//  Socket-App
//
//  Created by Marcus Vinicius Vieira Badiale on 15/07/21.
//

import SwiftUI

struct LandscapeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .previewLayout(.fixed(width: 1000, height: 600))
            .environment(\.horizontalSizeClass, .compact)
            .environment(\.verticalSizeClass, .compact)
    }
}

extension View {
    func landscape() -> some View {
        self.modifier(LandscapeModifier())
    }
}
