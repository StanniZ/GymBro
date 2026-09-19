//
//  ExerciseList.swift
//  GymBro
//
//  Created by macbook on 07/09/2025.
//
import SwiftUI

struct ExerciseList: View {
    @Binding var exercise: SessionExerciseModel
    @EnvironmentObject var historyVM: HistorySessionViewModel
    var onDelete: (() -> Void)? = nil

    @State private var isCollapsed = false

    private var exerciseName: String {
        ExerciseLoader.byID[exercise.exerciseID]?.name ?? "Exercise \(exercise.exerciseID)"
    }

    private var previousSets: [ExerciseSetModel] {
        historyVM.lastSets(for: exercise.exerciseID)
    }

    var body: some View {
        VStack(spacing: 0) {
            exerciseHeader
            if !isCollapsed {
                Divider().background(Color.white.opacity(0.06))
                setsTable
                addSetRow
            }
        }
        .background(Color.backbutton)
        .cornerRadius(16)
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
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isCollapsed.toggle()
                }
            } label: {
                Image(systemName: isCollapsed ? "chevron.down" : "chevron.up")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.weekDay)
                    .frame(width: 28, height: 28)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(7)
            }
            .buttonStyle(.plain)
            if let onDelete {
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 13))
                        .foregroundColor(.red.opacity(0.6))
                        .frame(width: 28, height: 28)
                        .background(Color.red.opacity(0.08))
                        .cornerRadius(7)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }

    // MARK: - Sets Table

    private var setsTable: some View {
        VStack(spacing: 0) {
            // Column headers
            HStack {
                Text("#").frame(width: 28, alignment: .center)
                Text("Prev").frame(width: 88, alignment: .leading)
                Text("Weight").frame(maxWidth: .infinity, alignment: .leading)
                Text("Reps").frame(width: 74, alignment: .center)
                Spacer().frame(width: 28)
            }
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(.white.opacity(0.3))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)

            Divider().background(Color.white.opacity(0.04))

            ForEach(Array($exercise.sets.enumerated()), id: \.1.id) { index, $set in
                let prev = index < previousSets.count ? previousSets[index] : nil
                SetRow(index: index + 1, set: $set, previous: prev) {
                    removeSet(id: set.id)
                }
                if index < exercise.sets.count - 1 {
                    Divider().background(Color.white.opacity(0.04)).padding(.horizontal, 14)
                }
            }
        }
    }

    // MARK: - Add Set Row

    private var addSetRow: some View {
        HStack(spacing: 10) {
            Button(action: addSet) {
                HStack(spacing: 7) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 15))
                        .foregroundColor(.currentday)
                    Text("Add Set")
                        .font(AppFont.subheadline)
                        .foregroundColor(.currentday)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 12)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isCollapsed = true
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 14))
                    Text("Done")
                        .font(AppFont.subheadline)
                }
                .foregroundColor(.weekDay)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.06))
                .cornerRadius(10)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 4)
    }

    private var expandRow: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                isCollapsed = false
            }
        } label: {
            HStack(spacing: 7) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 15))
                    .foregroundColor(.currentday)
                Text("Open")
                    .font(AppFont.subheadline)
                    .foregroundColor(.currentday)
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
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
    let previous: ExerciseSetModel?
    let onRemove: () -> Void

    @FocusState private var weightFocused: Bool
    @FocusState private var repsFocused: Bool
    @State private var weightDraft = ""
    @State private var repsDraft = ""

    private var prevLabel: String {
        guard let p = previous else { return "—" }
        if p.weightKg <= 0 && p.reps <= 0 { return "—" }
        let kg  = p.weightKg > 0 ? String(format: "%.0fkg", p.weightKg) : ""
        let rep = p.reps > 0     ? "\(p.reps)r"                          : ""
        switch (kg.isEmpty, rep.isEmpty) {
        case (false, false): return "\(kg) × \(rep)"
        case (false, true):  return kg
        default:             return rep
        }
    }

    var body: some View {
        HStack(spacing: 8) {
            // Set number
            Text("\(index)")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white.opacity(0.4))
                .frame(width: 28, alignment: .center)

            // Previous performance
            Text(prevLabel)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(previous != nil ? 0.3 : 0.15))
                .frame(width: 88, alignment: .leading)
                .lineLimit(1)

            // Weight field
            HStack(alignment: .center, spacing: 3) {
                TextField("0", text: $weightDraft)
                    .keyboardType(.decimalPad)
                    .foregroundColor(.white)
                    .font(.system(size: 15, weight: .medium))
                    .multilineTextAlignment(.trailing)
                    .frame(width: 50)
                    .focused($weightFocused)
                    .onSubmit { commitWeight() }
                Text("kg")
                    .font(AppFont.caption)
                    .foregroundColor(.white.opacity(0.35))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 34)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(weightFocused ? Color.currentday.opacity(0.1) : Color.white.opacity(0.05))
            )

            // Reps field
            HStack(alignment: .center, spacing: 3) {
                TextField("0", text: $repsDraft)
                    .keyboardType(.numberPad)
                    .foregroundColor(.white)
                    .font(.system(size: 15, weight: .medium))
                    .multilineTextAlignment(.trailing)
                    .frame(width: 32)
                    .focused($repsFocused)
                    .onSubmit { commitReps() }
                Text("×")
                    .font(AppFont.caption)
                    .foregroundColor(.white.opacity(0.35))
            }
            .frame(width: 74)
            .frame(height: 34)
            .padding(.horizontal, 10)
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
        .onAppear {
            syncDrafts()
        }
        .onChange(of: weightFocused) { _, isFocused in
            isFocused ? syncWeightDraft() : commitWeight()
        }
        .onChange(of: repsFocused) { _, isFocused in
            isFocused ? syncRepsDraft() : commitReps()
        }
        .onChange(of: set.weightKg) { _, _ in
            if !weightFocused { syncWeightDraft() }
        }
        .onChange(of: set.reps) { _, _ in
            if !repsFocused { syncRepsDraft() }
        }
    }

    private func syncDrafts() {
        syncWeightDraft()
        syncRepsDraft()
    }

    private func syncWeightDraft() {
        weightDraft = formatWeight(set.weightKg)
    }

    private func syncRepsDraft() {
        repsDraft = set.reps == 0 ? "" : "\(set.reps)"
    }

    private func commitWeight() {
        let clean = weightDraft.replacingOccurrences(of: ",", with: ".")
        let parsed = Double(clean) ?? 0
        set.weightKg = max(0, parsed)
        weightDraft = formatWeight(set.weightKg)
    }

    private func commitReps() {
        let digits = repsDraft.filter { $0.isNumber }
        set.reps = max(0, Int(digits) ?? 0)
        repsDraft = set.reps == 0 ? "" : "\(set.reps)"
    }

    private func formatWeight(_ value: Double) -> String {
        guard value > 0 else { return "" }
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", value)
        }
        return String(format: "%.1f", value)
    }
}
