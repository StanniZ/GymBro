//
//  NutrtionProgress.swift
//  GymBro
//
//  Created by macbook on 14/01/2026.
//
import SwiftUI

struct NutritionProgress: View {
    let totalCalories: Int
    let currentCalories: Int
    let progress: Double
    let lineWidthRingProgress: CGFloat = 20
    let arc: Double = 0.66
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                ringProgress
                progressCalories
            }
            .offset(y: 15)
            VStack(spacing: 16) {
                NutrientRow(
                    title: "Carbs",
                    value: "57",
                    totalValue: "190",
                    progress: 0.2,
                    color: .white
                )
                NutrientRow(
                    title: "Proteins",
                    value: "65",
                    totalValue: "120",
                    progress: 0.7,
                    color: .white
                )
                NutrientRow(
                    title: "Fat",
                    value: "18",
                    totalValue: "60",
                    progress: 0.3,
                    color: .white
                )
            }
        }
        .padding(10)
        .background(Color.purple.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.2), lineWidth: 1))
        .frame(maxHeight: 190)
    }
    
    private var ringProgress: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: arc)
                .stroke(Color.white.opacity(0.1), style: StrokeStyle(lineWidth: lineWidthRingProgress, lineCap: .round))
                .rotationEffect(.degrees(90 + (1 - arc) * 180))
            Circle()
                .trim(from: 0, to: arc * progress)
                .stroke(Color.white, style: StrokeStyle(lineWidth: lineWidthRingProgress, lineCap: .round))
                .rotationEffect(.degrees(90 + (1 - arc) * 180))
        }
        .padding([.leading, .trailing], 10)
    }
    
    private var progressCalories: some View {
        VStack(spacing: 4) {
            Text(String(currentCalories))
                .font(Font.system(size: 29, weight: .regular))
                .foregroundColor(.white)
            Text("Your goal \(totalCalories)")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color.white.opacity(0.5))
        }
    }
}

struct NutrientRow: View {
    var title: String
    var value: String
    var totalValue: String
    var progress: Double
    var color: Color
    
    var body: some View {
        VStack{
            HStack(spacing: 0){
                Text(title)
                Spacer()
                Text(value)
                    .foregroundStyle(Color.white)
                Text("/\(totalValue)")
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(Color.white.opacity(0.5))
            
            ProgressView(value: progress)
                .tint(color)
        }
    }
}
