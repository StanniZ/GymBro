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
                    .fill(Color.blue.opacity(0.1))
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
                .foregroundStyle(.logincolor)
        }
        .padding(.top, 12)
        
    }
    
    private var backLayer: some View {
        RoundedRectangle(cornerRadius: heightLayer / 2)
            .fill(Color.blue.opacity(0.1))
            .frame(width: widthLayer, height: heightLayer)
            .overlay(RoundedRectangle(cornerRadius: heightLayer / 2).stroke(.borderbtn, lineWidth: 0.5))
    }
    
    private var buttoMale: some View {
        ZStack{
            Circle()
                .fill(buttonLinearGradient)
                .frame(width: heightLayer / 2 - 30)
                .overlay(Circle().stroke(.borderbtn, lineWidth: 0.7))
            VStack(spacing: 16){
                Text(Gender.male.displaySymbol)
                    .font(.system(size: 60, weight: .bold))
                    .foregroundStyle(.white)
                    .shadow(radius: 3)
                Text(Gender.male.displayName)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .shadow(radius: 3)
            }
        }
    }
    
    private var buttoFemale: some View {
        ZStack{
            Circle()
                .fill(buttonLinearGradient)
                .frame(width: heightLayer / 2 - 30)
                .overlay(Circle().stroke(.borderbtn, lineWidth: 0.7))
            VStack(spacing: 16){
                Text(Gender.female.displaySymbol)
                    .font(.system(size: 60, weight: .bold))
                    .foregroundStyle(.white)
                    .shadow(radius: 3)
                Text(Gender.female.displayName)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .shadow(radius: 3)
            }
        }
    }
    
    private var buttonLinearGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "#A5CC82"),
                Color(hex: "#00467F")
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
