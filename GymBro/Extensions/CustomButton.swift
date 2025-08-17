//
//  Button.swift
//  GymBro
//
//  Created by macbook on 17/08/2025.
//

import SwiftUI

struct CustomNextButton: View {
    @StateObject var viewModel: OnboardingViewModel
    
    var body: some View {
        Button(action: {
            Task{
                await viewModel.saveProfile()
            }
        }) {
            HStack(spacing: 4){
                Text("Next")
                    .font(.system(size: 18, weight: .thin))
                    .foregroundColor(.currentday)
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .thin))
                    .foregroundColor(.currentday)
            }
            .offset(x: 130, y: 250)
        }
        .padding()
    }
}
