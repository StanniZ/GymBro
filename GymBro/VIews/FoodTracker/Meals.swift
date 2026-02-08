//
//  Meals.swift
//  GymBro
//
//  Created by macbook on 14/01/2026.
//
import SwiftUI

struct Meals: View{
    
    var body: some View{
        VStack(alignment: .leading, spacing: 12){
            title
            mealRow
        }
    }
    
    private var title: some View{
        HStack(spacing: 6) {
            Image(systemName: "fork.knife")
                .font(.system(size: 18))
                .foregroundStyle(Color(.white.opacity(0.5)))
            Text("Meals")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color(.white))
        }
    }
    
    private var mealRow: some View{
        VStack(spacing: 16) {
            MealRowView(title: "Breakfast") { }
            MealRowView(title: "Lunch") { }
            MealRowView(title: "Dinner") { }
        }
    }
}

private struct MealRowView: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        HStack{
            Text(title)
                .font(.system(size: 22, weight: .regular))
                .foregroundStyle(Color(.white))
            Spacer()
            Button{
                action()
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color.currentday)
                    .frame(width: 15, height: 15)
                    .contentShape(Circle())
            }
                
        }
        .padding(10)
        .padding([.leading, .trailing], 5)
        .background(Color.purple.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.2)))
    }
}
