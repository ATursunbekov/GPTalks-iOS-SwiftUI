//
//  HalfSheet.swift
//  GpTalks-iOSApp
//
//  Created by Alikhan Tursunbekov on 25/7/23.
//

import SwiftUI

//MARK: Custom Half Sheet
extension View {
    //Bimding show Variable
    func halfSheet<SheetView: View>(showSheet: Binding<Bool>, @ViewBuilder sheetView: @escaping ()->SheetView, onEnd: @escaping ()->())-> some View{
        
        return self
            .background(
                HalfSheetHelper(sheetView: sheetView(), showSheet: showSheet, onEnd: onEnd)
            )
    }
}
//UIKit integration
struct HalfSheetHelper<SheetView: View>: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        controller.view.backgroundColor = .clear
        
        return controller
    }
    
    var sheetView: SheetView
    @Binding var showSheet: Bool
    var onEnd: ()-> ()
    
    let controller = UIViewController()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if showSheet {
            let sheetController = CustomHostingController(rootView: sheetView)
            sheetController.presentationController?.delegate = context.coordinator
            uiViewController.present(sheetController, animated: true)
        } else {
            uiViewController.dismiss(animated: true)
        }
    }
    //onDismiss
    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        var parent: HalfSheetHelper
        
        init(parent: HalfSheetHelper) {
            self.parent = parent
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.showSheet = false
            parent.onEnd()
        }
    }
}
// Custom UIHostingController for halfSheet
class CustomHostingController<Content: View>: UIHostingController<Content> {
    override func viewDidLoad() {
        
        view.backgroundColor = .clear
        
        // setting presentation controller properties...
        if let presentatoinController = presentationController as?
            UISheetPresentationController{
            
            presentatoinController.detents = [
                .medium(),
                .large()
            ]
            
            //to show grab protion...
            presentatoinController.prefersGrabberVisible = true
        }
    }
}
