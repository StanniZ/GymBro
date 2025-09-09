//
//  ExerciseList.swift
//  GymBro
//
//  Created by macbook on 07/09/2025.
//
import SwiftUI

struct ExerciseList: View {
    @Binding var exercise: ExerciseModel
    @State private var setId: UUID? = nil
    @State private var reps: Int = 8
    @State private var weight: Double = 20
    
    var body: some View {
        VStack(spacing: 16){
            exerciseHeader
            table
            addSetButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backmain)
        
    }
    
    private var exerciseHeader: some View {
        HStack(spacing: 8) {
            Text(exercise.name)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.white)
            Button(action: {
                
            }) {
                Image(systemName: "info.circle")
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.5))
            }
            Spacer()
            Button(action: {
                
            }) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18))
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
    }
    
    private var table: some View {
        Grid(horizontalSpacing: 12, verticalSpacing: 12) {
            GridRow {
                Text("Set")
                Text("Previous")
                Text("Weight")
                Text("Reps")
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(.white.opacity(0.5))
            .gridColumnAlignment(.leading)

            ForEach(Array($exercise.sets.enumerated()), id: \.1.id) { index, $set in
                GridRow {
                    Text("\(index + 1)")
                        .frame(height: 40)
                        .frame(minWidth: 40)
                        .background(RoundedRectangle(cornerRadius: 6).fill(Color.backbutton))

                    Text("22kg × 12")
                        .padding(.horizontal, 16)
                        .frame(minHeight: 40)
                        .background(RoundedRectangle(cornerRadius: 6).fill(Color.currentday).opacity(0.05))

                    TextField("Weight", value: $set.weightKg, format: .number)
                        .textFieldStyle(.plain)
                        .padding(.horizontal, 16)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .frame(minHeight: 40)
                        .frame(maxWidth: 80)
                        .background(RoundedRectangle(cornerRadius: 6).stroke(Color.white.opacity(0.5), lineWidth: 0.5))
                    
                    TextField("Reps", value: $set.reps, format: .number)
                        .textFieldStyle(.plain)
                        .padding(.horizontal, 16)
                        .multilineTextAlignment(.center)
                        .frame(minHeight: 40)
                        .frame(maxWidth: 70)
                        .background(RoundedRectangle(cornerRadius: 6).stroke(Color.white.opacity(0.5), lineWidth: 0.5))
                    Spacer()
                    removeSetButton($set)
                        .frame(minHeight: 40)
                    
                }
                .foregroundStyle(.white)
            }
        }
        .gridColumnAlignment(.leading)
        .padding(1)
    }
    
    private func removeSetButton(_ set: Binding<ExerciseSetModel>) -> some View {
        Button(action: {
            removeSet(at: set)
        }) {
            Image(systemName: "xmark")
                .font(.system(size: 16))
                .foregroundStyle(.white.opacity(0.3))
        }
    }
    
    private var addSetButton: some View {
        Button(action: {
            addSet()
        }) {
            Text("ADD SET")
                .font(.system(size: 16, weight: .medium))
                
        }
        .frame(maxWidth: .infinity)
        .frame(height: 40)
        .foregroundColor(.currentday)
        .background(Color.backbutton)
        .cornerRadius(8)
    }
    
    private func removeSet(at set: Binding<ExerciseSetModel>) {
        if exercise.sets.count > 1 {
            if let index = exercise.sets.firstIndex(where: { $0.id == set.id.wrappedValue }) {
                exercise.sets.remove(at: index)
            }
        }
    }
    
    private func addSet() {
        if exercise.sets.count < 20 {
            exercise.sets.append(ExerciseSetModel(reps: 12, timestamp: Date(), weightKg: 20))
        }
    }
}
