

import SwiftUI
import AVFoundation
import AudioToolbox

struct AgeView: View {
    @StateObject var viewModel: OnboardingViewModel
    var body: some View {
        ZStack{
            divider
            VStack(alignment: .center){
//                customPicker
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            nextButton
        }
        .padding(55)
        .background(.backmain)
    }
    
//    private var customPicker: some View{
//        GeometryReader{ geo in
//            CustomPicker(selectedValue: $viewModel.userProfile.age,
//                         range: Array(16...70), selectedFontSize: 30, secondaryFontSize: 26)
//                .frameRelative(to: geo, widthPercent: 0.6, heightPercent: 0.75)
//                .clipped()
//                .position(x: geo.size.width / 2, y: geo.size.height / 2)
//            
//        }
//    }
    
    private var nextButton: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    Task {
//                        await viewModel.saveProfile()
                    }
                }) {
                    Text("Next")
                    Image(systemName: "chevron.right")
                }
                .font(.system(size: 18, weight: .thin))
                .foregroundColor(.currentday)
            }
        }
        .padding(.bottom, 100)
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

//#Preview {
//    AgeView(viewModel: OnboardingViewModel(repository: MockUserProfileRepository()))
//}

