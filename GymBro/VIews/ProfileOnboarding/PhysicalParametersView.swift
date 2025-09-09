//
//  PhysicalParametersView.swift
//  GymBro
//
//  Created by macbook on 11/08/2025.
//
import SwiftUI

struct PhysicalParametersView: View {
    @StateObject var viewModel: OnboardingViewModel
    
    var body: some View {
        ZStack{
            text
            VStack{
                customPicker
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(55)
        .background(.backmain)
    }
    
    private var customPicker: some View{
        GeometryReader{ geo in
            HStack {
//                CustomPicker(selectedValue: $viewModel.userProfile.weight,
//                             range: stride(from: 40.0, through: 200, by: 0.5).map { $0 },
//                             selectedFontSize: 22, secondaryFontSize: 16)
//                CustomPicker(selectedValue: $viewModel.userProfile.height,
//                             range: Array(130...240),
//                             selectedFontSize: 22, secondaryFontSize: 16)
                
            }
            .clipped()
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
    }
    private var text: some View {
        GeometryReader{ geo in
            Text("kg")
                .position(x: geo.size.width / 2.3, y: geo.size.height / 2.22)
                .foregroundStyle(.currentday)
            Text("cm")
                .position(x: geo.size.width / 1.07, y: geo.size.height / 2.22)
                .foregroundStyle(.currentday)
        }
    }
}

//#Preview {
//    PhysicalParametersView(viewModel: OnboardingViewModel(repository: MockUserProfileRepository()))
//}
