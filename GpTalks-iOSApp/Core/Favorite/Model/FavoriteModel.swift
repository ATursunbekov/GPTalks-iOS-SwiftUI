import SwiftUI

struct CheckUI: View {
    @State private var offset: CGFloat = 0
    
    var body: some View {
        VStack {
            // Button to move the view
            Button(action: {
                withAnimation {
                    // Move the view to the left
                    offset -= 50
                }
            }) {
                Text("Move Left")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
            }
            
            // Container to clip the moving view
            ZStack {
                // The view you want to move
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 100, height: 100)
                    .offset(x: offset)
            }
            .frame(width: UIScreen.main.bounds.width)
        }
        .frame(width: 200)
        .background(Color.cyan)
        .clipped() // This clips the content inside the VStack to its frame
    }
}

struct CheckUI_Preview: PreviewProvider {
    static var previews: some View {
        CheckUI()
    }
}
