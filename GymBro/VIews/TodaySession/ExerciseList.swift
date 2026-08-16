//
//  ExerciseList.swift
//  GymBro
//
//  Created by macbook on 07/09/2025.
//
import SwiftUI

struct ExerciseList: View {
    @Binding var exercise: SessionExerciseModel

    var body: some View {
        VStack(spacing: 0) {
            exerciseHeader
            Divider().background(Color.white.opacity(0.06))
            setsTable
            addSetRow
        }
        .background(Color.backbutton)
        .cornerRadius(16)
    }

    private var exerciseName: String {
        ExerciseLoader.byID[exercise.exerciseID]?.name ?? "Exercise \(exercise.exerciseID)"
    }

    // MARK: - Header

    private var exerciseHeader: some View {
        HStack(spacing: 8) {
            Text(exerciseName)
                .font(AppFont.body)
                .foregroundColor(.white)
                .lineLimit(1)
            Spacer()
            Text("\(exercise.sets.count) sets")
                .font(AppFont.caption)
                .foregroundColor(.white.opacity(0.4))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }

    // MARK: - Sets Table

    private var setsTable: some View {
        VStack(spacing: 0) {
            // Column headers
            HStack {
                Text("#")
                    .frame(width: 28, alignment: .center)
                Text("Weight")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Reps")
                    .frame(width: 80, alignment: .center)
                Spacer().frame(width: 28)
            }
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(.white.opacity(0.3))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)

            Divider().background(Color.white.opacity(0.04))

            ForEach(Array($exercise.sets.enumerated()), id: \.1.id) { index, $set in
                SetRow(index: index + 1, set: $set, onRemove: {
                    removeSet(id: set.id)
                })
                if index < exercise.sets.count - 1 {
                    Divider().background(Color.white.opacity(0.04)).padding(.horizontal, 14)
                }
            }
        }
    }

    // MARK: - Add Set Row

    private var addSetRow: some View {
        Button(action: addSet) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 15))
                    .foregroundColor(.currentday)
                Text("Add Set")
                    .font(AppFont.subheadline)
                    .foregroundColor(.currentday)
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
        }
    }

    // MARK: - Actions

    private func removeSet(id: UUID) {
        guard exercise.sets.count > 1 else { return }
        exercise.sets.removeAll { $0.id == id }
    }

    private func addSet() {
        guard exercise.sets.count < 20 else { return }
        exercise.sets.append(
            ExerciseSetModel(reps: 0, weightKg: 0, isCompleted: false,
                             timestamp: Date(), position: exercise.sets.count + 1)
        )
    }
}

// MARK: - Single Set Row

private struct SetRow: View {
    let index: Int
    @Binding var set: ExerciseSetModel
    let onRemove: () -> Void

    @FocusState private var weightFocused: Bool
    @FocusState private var repsFocused: Bool

    var body: some View {
        HStack(spacing: 8) {
            // Set number
            Text("\(index)")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white.opacity(0.4))
                .frame(width: 28, alignment: .center)

            // Weight field
            HStack(alignment: .lastTextBaseline, spacing: 3) {
                TextField("0", value: $set.weightKg,
                          format: .number.precision(.fractionLength(0...1)).locale(Locale(identifier: "en_US")))
                    .keyboardType(.decimalPad)
                    .foregroundColor(.white)
                    .font(.system(size: 15, weight: .medium))
                    .multilineTextAlignment(.trailing)
                    .frame(width: 52)
                    .focused($weightFocused)
                Text("kg")
                    .font(AppFont.caption)
                    .foregroundColor(.white.opacity(0.35))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(weightFocused ? Color.currentday.opacity(0.1) : Color.white.opacity(0.05))
            )

            // Reps field
            HStack(alignment: .lastTextBaseline, spacing: 3) {
                TextField("0", value: $set.reps, format: .number)
                    .keyboardType(.numberPad)
                    .foregroundColor(.white)
                    .font(.system(size: 15, weight: .medium))
                    .multilineTextAlignment(.trailing)
                    .frame(width: 34)
                    .focused($repsFocused)
                Text("×")
                    .font(AppFont.caption)
                    .foregroundColor(.white.opacity(0.35))
            }
            .frame(width: 80)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(repsFocused ? Color.currentday.opacity(0.1) : Color.white.opacity(0.05))
            )

            // Remove button
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.white.opacity(0.25))
                    .frame(width: 24, height: 24)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(6)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
    }
}
