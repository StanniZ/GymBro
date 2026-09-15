//
//  SetEditorRow.swift
//  GymBro Watch App
//
//  Created by Codex on 14/09/2026.
//

import SwiftUI

struct SetEditorSelection: Equatable {
    let setID: UUID
    let field: EditableSetField
}

struct SetEditorRow: View {
    @EnvironmentObject private var viewModel: WatchWorkoutViewModel
    @Binding var activeEditor: SetEditorSelection?
    @State private var crownValue: Double = 0

    let exerciseID: UUID
    let set: WatchExerciseSet

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Button {
                    viewModel.updateSet(exerciseID: exerciseID, setID: set.id, isCompleted: !set.isCompleted)
                } label: {
                    Image(systemName: set.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(set.isCompleted ? WatchTheme.accent : WatchTheme.muted)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(set.isCompleted ? "Mark set incomplete" : "Mark set complete")

                Text("Set \(set.setNumber)")
                    .font(WatchTypography.body)
                    .foregroundStyle(.white)

                Spacer()

                Image(systemName: "digitalcrown.horizontal.arrow.clockwise")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(isEditing ? WatchTheme.accent : WatchTheme.muted)
            }

            HStack(spacing: 8) {
                editableValueBox(field: .weight, title: "kg", value: weightText)
                editableValueBox(field: .reps, title: "reps", value: "\(set.reps)")
            }
        }
        .padding(10)
        .background(WatchTheme.panel, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(set.isCompleted ? WatchTheme.accent.opacity(0.45) : .white.opacity(0.05), lineWidth: 1)
        )
        .focusable(isEditing)
        .digitalCrownRotation(
            $crownValue,
            from: activeField?.minimumValue ?? 0,
            through: activeField?.maximumValue ?? 1,
            by: activeField?.step ?? 1,
            sensitivity: .medium,
            isContinuous: false,
            isHapticFeedbackEnabled: true
        )
        .onAppear {
            syncCrownValueIfEditing()
        }
        .onChange(of: activeEditor) { _, _ in
            syncCrownValueIfEditing()
        }
        .onChange(of: crownValue) { _, newValue in
            applyCrownValue(newValue)
        }
        .onChange(of: set.weight) { _, _ in
            syncCrownValueIfEditing()
        }
        .onChange(of: set.reps) { _, _ in
            syncCrownValueIfEditing()
        }
    }

    private var activeField: EditableSetField? {
        guard activeEditor?.setID == set.id else { return nil }
        return activeEditor?.field
    }

    private var isEditing: Bool {
        activeField != nil
    }

    private var weightText: String {
        if set.weight.rounded() == set.weight {
            return "\(Int(set.weight))"
        }

        return String(format: "%.1f", set.weight)
    }

    private func editableValueBox(field: EditableSetField, title: String, value: String) -> some View {
        let isActive = activeEditor == SetEditorSelection(setID: set.id, field: field)

        return Button {
            if isActive {
                activeEditor = nil
            } else {
                activeEditor = SetEditorSelection(setID: set.id, field: field)
            }
        } label: {
            VStack(spacing: 3) {
                Text(value)
                    .font(WatchTypography.value)
                    .foregroundStyle(.white)
                    .monospacedDigit()
                    .minimumScaleFactor(0.75)
                    .frame(maxWidth: .infinity, minHeight: 34)
                    .background(WatchTheme.panelSecondary, in: RoundedRectangle(cornerRadius: 7, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .stroke(isActive ? WatchTheme.accent : Color.gray.opacity(0.48), lineWidth: isActive ? 2 : 1)
                    )

                Text(title.uppercased())
                    .font(WatchTypography.micro)
                    .foregroundStyle(isActive ? WatchTheme.accent : WatchTheme.muted)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(field == .weight ? "Weight" : "Repetitions")
        .accessibilityValue(value)
    }

    private func syncCrownValueIfEditing() {
        guard let activeField else { return }

        switch activeField {
        case .weight:
            crownValue = set.weight
        case .reps:
            crownValue = Double(set.reps)
        }
    }

    private func applyCrownValue(_ value: Double) {
        guard let activeField else { return }

        switch activeField {
        case .weight:
            let steppedWeight = (value * 2).rounded() / 2
            guard steppedWeight != set.weight else { return }
            viewModel.updateSet(exerciseID: exerciseID, setID: set.id, weight: steppedWeight)
        case .reps:
            let steppedReps = max(Int(value.rounded()), 1)
            guard steppedReps != set.reps else { return }
            viewModel.updateSet(exerciseID: exerciseID, setID: set.id, reps: steppedReps)
        }
    }
}

enum EditableSetField {
    case weight
    case reps

    var minimumValue: Double {
        switch self {
        case .weight: return 0
        case .reps: return 1
        }
    }

    var maximumValue: Double {
        switch self {
        case .weight: return 300
        case .reps: return 100
        }
    }

    var step: Double {
        switch self {
        case .weight: return 0.5
        case .reps: return 1
        }
    }
}
