//
//  OnboardingView.swift
//  GymBro
//
//  Created by macbook on 08/02/2026.
//
import SwiftUI

@MainActor
struct OnboardingView: View {
    
    @StateObject var viewModel = OnboardingViewModel(repository: CoreDataUserProfileRepository.shared)
    @State private var step = 0
    @State private var buttonOpacity: Double = 1.0
    var onFinish: () -> Void
    
    var body: some View {
        ZStack{
            background
            card
            VStack{
                Spacer()
                nextButton
            }
        }
        .ignoresSafeArea(.all)
    }
    
    private var card: some View {
        TabView(selection: $step) {
            CardContainer{
                PersonalInfoView(viewModel: viewModel, next: next).tag(0)
            }
            CardContainer{
                AgeView(viewModel: viewModel, next: next).tag(1)
            }
            CardContainer{
                PhysicalParametersView(viewModel: viewModel, next: next).tag(2)
            }
            CardContainer{
                GenderView(viewModel: viewModel, next: finish).tag(3)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    private var background: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "304350"),
                Color(hex: "464644")
            ]),
            startPoint: .leading,
            endPoint: .trailing)
    }
    
    private var cardStyle: some View {
        RoundedRectangle(cornerRadius: 28)
            .overlay(RoundedRectangle(cornerRadius: 28).stroke(Color.borderbtn, lineWidth: 0.5))
    }
    
    private var nextButton: some View {
        VStack{
            Button(action: {
                buttonOpacity = 0.0
                
                Task{
                    try await viewModel.saveUserProfile()
                    //                    print(viewModel.userProfile.age)
                    if step == 3 {
                        finish()
                    } else {
                        next()
                        try await Task.sleep(nanoseconds: 600_000_000)
                        withAnimation(.easeInOut(duration: 0.6)) {
                            buttonOpacity = 1.0
                        }
                    }
                }
            }) {
                CustomNextButton()
            }
            .opacity(buttonOpacity)
        }
        .padding(60)
    }
    
    private func next() {
        withAnimation(.easeInOut(duration: 0.3)) {
            step += 1
        }
    }
    
    private func finish() {
        onFinish()
    }
}

struct CardContainer<Content: View>: View {
    
    @ViewBuilder var content: Content
    
    var body: some View{
        content
            .clipShape(RoundedRectangle(cornerRadius: 60))
            .overlay(RoundedRectangle(cornerRadius: 60)
                .stroke(Color.borderbtn, lineWidth: 0.5))
            .padding(.horizontal, 16)
            .padding(.top, 60)
            .padding(.bottom, 30)
            .ignoresSafeArea(.all)
    }
}

//#Preview {
//    OnboardingView()
//}

