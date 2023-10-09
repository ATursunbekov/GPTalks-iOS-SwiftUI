import SwiftUI

struct OnboardingView: View {
    @Binding var showOnBoarding: Bool
    @State var slider1: CGFloat = 0
    @State var slider2: CGFloat = 0
    @State var slider3: CGFloat = 0
    @State var slider4: CGFloat = 0
    @State var userAnswer: String = ""
    @State var getAnswer: String = "Typing..."
    
    var body: some View {
        TabView {
            FirstView()
            
            SecondView()
            
            ThirdView()
            
            FourthView()
            
            FifthView(showOnBoarding: $showOnBoarding)
        }
        .background(Colors.SystemBackgrounds.background01.swiftUIColor)
        .tabViewStyle(.page(indexDisplayMode: .always))
        .overlay(alignment: .topTrailing) {
            Button {
                    showOnBoarding = false
                print("SKIP")
            } label: {
                Text("Skip")
                    .foregroundColor(.white)
                    .font(.custom(FontFamily.SFProDisplay.regular, size: 17))
                    .padding(16)
                    .padding(.leading, 20)
            }
        }
        .onAppear {
            NotificationManager.shared.requestAuthorization()
        }
    }
}
struct FirstView2_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(showOnBoarding: .constant(true))
    }
}
