//
//  OnboardingView.swift
//  GymBro
//
//  Created by macbook on 08/02/2026.
//
import SwiftUI

@MainActor
struct OnboardingView: View {

    @EnvironmentObject private var viewModel: OnboardingViewModel
    @State private var step = 0
    @State private var buttonOpacity: Double = 1.0
    @State private var flowOpacity: Double = 1.0
    var onFinish: () -> Void

    private let finalStep = 3
    
    var body: some View {
        ZStack{
            background
            card
            VStack(spacing: 12) {
                Spacer()
                nextButton
            }
        }
        .opacity(flowOpacity)
        .ignoresSafeArea(.all)
        .dismissKeyboardOnTap()
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
        ZStack {
            Color.backmain
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.logincolor.opacity(0.22),
                    Color.backmain.opacity(0.92)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var cardStyle: some View {
        RoundedRectangle(cornerRadius: 28)
            .overlay(RoundedRectangle(cornerRadius: 28).stroke(Color.borderbtn, lineWidth: 0.5))
    }
    
    private var nextButton: some View {
        VStack{
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    buttonOpacity = 0.0
                }

                Task {
                    try await viewModel.saveUserProfile()
                    if step == finalStep {
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
        withAnimation(.easeInOut(duration: 0.35)) {
            flowOpacity = 0.0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            onFinish()
        }
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
