//
//  ExtensionView.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 20/7/23.
//

import SwiftUI

func getDynamicHeight(height: Double) -> Double {
    return UIScreen.main.bounds.height * (height / 844.0)
}

func getDynamicWidth(width: Double) -> Double {
    return UIScreen.main.bounds.width * (width / 390.0)
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

extension Array where Element: Identifiable {
    func removeDuplicates() -> [Element] {
        var seen = Set<Element.ID>()
        return filter { seen.insert($0.id).inserted }
    }
}
