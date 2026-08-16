//
//  ProfileVIew.swift
//  GymBro
//
//  Created by macbook on 13/02/2026.
//
import SwiftUI

struct ProfileVIew: View {
    
    var body: some View {
        VStack(spacing: 40) {
            userName
            photoUser
            userData
            userGoals
            Spacer()
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backmain)
    }
    
    private var userName: some View {
        VStack{
            Text("Your profile")
                .font(.system(size: 24, weight: .regular))
                .foregroundStyle(Color.white)
        }
        .padding(.bottom, 60)
    }
    
    private var photoUser: some View {
        VStack{
            Image(systemName: "person")
                .font(.system(size: 80))
                .foregroundStyle(.white)
        }
        .frame(width: 160, height: 160)
        .overlay(Circle().stroke(Color.white, lineWidth: 0.5))
    }
    
    private var userData: some View {
        VStack{
            HStack(spacing: 0) {
                parametersUserData(title: "Weight", value: "65", measurement: "kg")
                VerticalDottedLine(dotSize: 1, spacing: 2, height: 100)
                parametersUserData(title: "Age", value: "24", measurement: "y.o")
                VerticalDottedLine(dotSize: 1, spacing: 2, height: 100)
                parametersUserData(title: "Height", value: "1.80", measurement: "m")
            }
        }
    }
    
    private func parametersUserData(title: String, value: String, measurement: String) -> some View {
        VStack(alignment: .leading ,spacing: 10){
            Text(title)
                .font(.system(size: 22, weight: .regular))
                .foregroundStyle(.currentday)
            Text(value)
                .font(.system(size: 26, weight: .regular))
                .foregroundStyle(.white)
            Text(measurement)
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private func parametersUserGoal(goal: String, title: String, value: String?, measurement: String?) -> some View {
        VStack(alignment: .leading, spacing: 8){
            Text(goal)
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(.gray)
            HStack{
                Text(title)
                    .font(.system(size: 22, weight: .regular))
                    .foregroundStyle(.white)
                Spacer()
                if let value{
                    Text(value)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(.white)
                }
                if let measurement {
                    Text(measurement)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(.gray)
                }
            }
        }
    }
    
    private var userGoals: some View {
        VStack(spacing: 8) {
            Text("My goals")
                .font(.system(size: 26, weight: .medium))
                .foregroundStyle(.currentday)
            HorizontalDottedLineFull()
            parametersUserGoal(goal: "Lose Weight", title: "Reduce calories", value: "2100", measurement: "kcal")
            HorizontalDottedLineFull()
            parametersUserGoal(goal: "Intensity", title: "Workouts per week", value: "2", measurement: nil)
            HorizontalDottedLineFull()
            parametersUserGoal(goal: "Weight goal", title: "Reach Target Weight", value: "62", measurement: "kg")
            HorizontalDottedLineFull()
        }
    }
    
    private var buttonDone: some View {
        NavigationLink(destination: MainView()) {
            
        }
    }
}

#Preview {
    ProfileVIew()
}
