//
//  CopyTextView.swift
//  GpTalks-iOSApp
//
//  Created by Aidar Asanakunov on 3/8/23.
//

import SwiftUI

struct CopyTextView: View {
    @Binding var isCopy: Bool
    @Binding var isDisable: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 21)
                .fill(Color.black.opacity(0.85))
            VStack(spacing: 5) {
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
                    .font(.system(size: 40))
                
                Text("Copied")
                    .foregroundColor(.white)
                    .font(.custom(FontFamily.SFProDisplay.semibold, size: 17))
            }
        }
        .frame(width: 100, height: 100)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeOut(duration: 0.5)) {
                    isCopy = false
                    isDisable = true
                }
            }
        }
        .onDisappear {
            isDisable = false
        }
    }
}
