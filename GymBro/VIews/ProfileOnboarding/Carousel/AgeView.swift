

import SwiftUI
import AVFoundation
import AudioToolbox

struct AgeView: View {
    
    @StateObject var viewModel: OnboardingViewModel
    var next: () -> Void
    
    var body: some View {
        ZStack{
            divider
            VStack(alignment: .center){
                customPicker
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(16)
        .background(.backmain)
    }
    
    private var customPicker: some View{
        GeometryReader{ geo in
            CustomPicker(selectedValue: $viewModel.userProfile.age,
                         range: Array(16...70), selectedFontSize: 30, secondaryFontSize: 26)
                .clipped()
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
            
        }
    }
    
    private var divider: some View {
        GeometryReader { geo in
            ZStack {
                HorizontalDottedLine(dotSize: 3, spacing: 3)
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                HorizontalDottedLine(dotSize: 3, spacing: 3)
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                    .padding(.top, -75)
            }
        }
    }
}
