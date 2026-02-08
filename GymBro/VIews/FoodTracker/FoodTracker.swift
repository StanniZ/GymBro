//
//  Recomendation.swift
//  GymBro
//
//  Created by macbook on 06/06/2025.
//
import SwiftUI

struct FoodTracker: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            title
            NutritionProgress(totalCalories: 1950, currentCalories: 570, progress: 0.25)
            Meals()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
        .background(Color.backmain)
    }
    
    private var title: some View {
        HStack {
            Text("Food Tracker")
               .font(.system(size: 24, weight: .bold))
               .foregroundStyle(Color(.white))
            Spacer()
            Button{
                
            } label: {
                Image(systemName: "pencil")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color(.white.opacity(0.5)))
            }
        }
    }
    
} 

//#Preview {
//    FoodTracker()
//}
