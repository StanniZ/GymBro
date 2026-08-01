//
//  ExercisePickerView.swift
//  GymBro
//
import SwiftUI

struct ExercisePickerView: View {
    @Environment(\.dismiss) private var dismiss
    let onSelect: ([ExerciseDefinition]) -> Void

    @State private var searchText = ""
    @State private var selected: Set<Int> = []
    @State private var selectedCategory: MuscleCategory = .all

    private var filtered: [ExerciseDefinition] {
        let byCategory: [ExerciseDefinition] = selectedCategory == .all
            ? ExerciseLoader.all
            : ExerciseLoader.all.filter { selectedCategory.muscleGroups.contains($0.primaryMuscle) }

        guard !searchText.isEmpty else { return byCategory }
        return byCategory.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.backmain.ignoresSafeArea()

                VStack(spacing: 0) {
                    categoryBar
                    exerciseList
                }
            }
            .navigationTitle("Add Exercises")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search exercises")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(selected.isEmpty ? "Add" : "Add (\(selected.count))") {
                        let result = ExerciseLoader.all.filter { selected.contains($0.id) }
                        onSelect(result)
                        dismiss()
                    }
                    .disabled(selected.isEmpty)
                    .foregroundColor(selected.isEmpty ? .weekDay : .currentday)
                }
            }
        }
    }

    // MARK: - Category bar

    private var categoryBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(MuscleCategory.allCases, id: \.self) { category in
                    Button(action: { selectedCategory = category }) {
                        HStack(spacing: 4) {
                            Image(systemName: category.icon)
                                .font(.system(size: 11))
                            Text(category.rawValue)
                                .font(AppFont.caption)
                        }
                        .foregroundColor(selectedCategory == category ? .backmain : .white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(
                            Capsule()
                                .fill(selectedCategory == category ? Color.currentday : Color.backbutton)
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
    }

    // MARK: - Exercise list

    private var exerciseList: some View {
        List(filtered) { exercise in
            Button(action: { toggle(exercise) }) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(exercise.name)
                            .font(AppFont.subheadline)
                            .foregroundColor(.white)
                        Text(exercise.primaryMuscle.rawValue.replacingOccurrences(of: "_", with: " ").capitalized)
                            .font(AppFont.caption)
                            .foregroundColor(.weekDay)
                    }
                    Spacer()
                    Image(systemName: selected.contains(exercise.id)
                          ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(selected.contains(exercise.id) ? .currentday : .weekDay)
                }
            }
            .listRowBackground(Color.backbutton)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .animation(.easeInOut(duration: 0.2), value: selectedCategory)
    }

    private func toggle(_ exercise: ExerciseDefinition) {
        if selected.contains(exercise.id) {
            selected.remove(exercise.id)
        } else {
            selected.insert(exercise.id)
        }
    }
}
