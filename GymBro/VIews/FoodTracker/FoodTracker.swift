//
//  Recomendation.swift
//  GymBro
//
//  Created by macbook on 06/06/2025.
//
import SwiftUI

struct FoodTracker: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            title
            NutritionProgress(totalCalories: 1950, currentCalories: 570, progress: 0.25)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
        .background(Color.backmain)
    }
    
    private var title: some View {
         Text("Food Tracker")
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(Color(.white))
    }
    
}

struct NutritionProgress: View {
    let totalCalories: Int
    let currentCalories: Int
    let progress: Double
    let lineWidthRingProgress: CGFloat = 20
    let arc: Double = 0.66
    
    var body: some View {
        HStack(spacing: 30) {
            ZStack {
                ringProgress
                progressCalories
            }
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
        .padding(20)
        .background(Color.purple.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white.opacity(0.2), lineWidth: 1))
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

#Preview {
    FoodTracker()
}
