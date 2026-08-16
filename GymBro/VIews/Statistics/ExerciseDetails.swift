//
//  ExerciseDetails.swift
//  GymBro
//
//  Created by macbook on 20/09/2025.
//
import SwiftUI

struct ExerciseDetails: View {
    let exercise: SessionExerciseModel
    
    var body: some View {
        VStack(alignment: .leading) {
            exerciseName
            tableSet
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(.backmain)
    }
    
    private var exerciseName: some View {
        HStack {
            Text(String(exercise.exerciseID))
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.white)
            Spacer()
            Button(action: {
                
            }) {
                Image(systemName: "info.circle")
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
    }
    
    private var tableSet: some View {
        Grid(horizontalSpacing: 8, verticalSpacing: 8) {
            ForEach(Array(exercise.sets.enumerated()), id: \.1.id) { index, setValue in
                GridRow {
                    Text("\(index + 1)")
                        .foregroundStyle(.white)
                        .frame(height: 20)
                        .frame(minWidth: 20)
                        .background(RoundedRectangle(cornerRadius: 6).fill(Color.backbutton))
                    Text("\(setValue.weightKg.formatted(.number.precision(.fractionLength(0...2))))")
                        .foregroundStyle(.white)
                    Text("kg,")
                        .foregroundStyle(.white.opacity(0.7))
                    Text("\(setValue.reps)")
                        .foregroundStyle(.white)
                    Text("reps")
                        .foregroundStyle(.white.opacity(0.7))
                }
                .font(.system(size: 14, weight: .medium))
            }
        }
        .gridColumnAlignment(.leading)
        .padding(.horizontal, 16)
    }
}
