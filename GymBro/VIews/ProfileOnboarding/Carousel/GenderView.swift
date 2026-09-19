//
//  GenderView.swift
//  GymBro
//
//  Created by macbook on 03/09/2025.
import SwiftUI

struct GenderView: View {
    
    @ObservedObject var viewModel: OnboardingViewModel
    var next: () -> Void
    
    let heightLayer: CGFloat = 430
    let widthLayer: CGFloat = 210
    
    var body: some View {
        VStack {
            title
            Spacer()
            ZStack{
                RoundedRectangle(cornerRadius: heightLayer / 2)
                    .fill(Color.backbutton.opacity(0.72))
                    .frame(width: widthLayer, height: heightLayer)
                    .overlay(RoundedRectangle(cornerRadius: heightLayer / 2).stroke(.borderbtn, lineWidth: 0.5))
                VStack(spacing: 28){
                    buttoMale
                    buttoFemale
                }
                .frame(width: widthLayer, height: heightLayer)
            }
            Spacer()
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backmain)
    }
    
    private var title: some View {
        VStack{
            Text("Select your gender identity:")
                .font(.system(size: 24, weight: .thin))
                .foregroundStyle(Color.logincolor)
        }
        .padding(.top, 12)
        
    }
    
    private var backLayer: some View {
        RoundedRectangle(cornerRadius: heightLayer / 2)
            .fill(Color.backbutton.opacity(0.72))
            .frame(width: widthLayer, height: heightLayer)
            .overlay(RoundedRectangle(cornerRadius: heightLayer / 2).stroke(.borderbtn, lineWidth: 0.5))
    }
    
    private var buttoMale: some View {
        genderButton(.male)
    }
    
    private var buttoFemale: some View {
        genderButton(.female)
    }

    private func genderButton(_ gender: Gender) -> some View {
        Button {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                viewModel.userProfile.gender = gender
            }
        } label: {
            let isSelected = viewModel.userProfile.gender == gender

            ZStack {
                Circle()
                    .fill(isSelected ? buttonLinearGradient : inactiveButtonGradient)
                    .frame(width: heightLayer / 2 - 30)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.currentday : Color.borderbtn.opacity(0.65), lineWidth: isSelected ? 2 : 0.7)
                    )
                VStack(spacing: 16) {
                    Text(gender.displaySymbol)
                        .font(.system(size: 60, weight: .bold))
                        .foregroundStyle(Color.white)
                        .shadow(radius: 3)
                    Text(gender.displayName)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color.white)
                        .shadow(radius: 3)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var buttonLinearGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.currentday,
                Color.logincolor
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var inactiveButtonGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.backbutton.opacity(0.95),
                Color.logincolor.opacity(0.35)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
