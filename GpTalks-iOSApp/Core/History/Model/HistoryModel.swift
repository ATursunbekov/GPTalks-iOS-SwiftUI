import SwiftUI

struct SwipeToDeleteView: View {
    @State private var offset: CGFloat = 0
    @State private var shouldDelete: Bool = false

    var body: some View {
        VStack {
            HStack {
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 100, height: 50)
                    .opacity(offset == 0 ? 0 : 0.5)
                    .overlay(Text("Delete"))
                
                Rectangle()
                    .fill(Color.red)
                    .frame(width: UIScreen.main.bounds.width - offset, height: 50)
                    .background(Color.white)
                    .offset(x: offset)
                    .gesture(
                        DragGesture()
                            .onChanged(onChanged(value:))
                            .onEnded(onEnded(value:))
                    )
            }

            if shouldDelete {
                // If item is deleted, this can be your placeholder for the next view or empty space
                Spacer()
            }
        }
        .animation(.default)
    }

    func onChanged(value: DragGesture.Value) {
        if value.translation.width < 0 { // Only swipe left
            self.offset = value.translation.width
        }
    }

    func onEnded(value: DragGesture.Value) {
        if -value.translation.width > UIScreen.main.bounds.width * 0.25 {
            self.offset = -UIScreen.main.bounds.width
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                shouldDelete = true
            }
        } else {
            self.offset = 0
        }
    }
}

struct SwipeToDeleteView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeToDeleteView()
    }
}
