//
//  CreateTemplateView.swift
//  GymBro
//
import SwiftUI

struct CreateTemplateView: View {
    @Environment(\.dismiss) private var dismiss
    let onSave: (WorkoutTemplateModel) -> Void

    @State private var name: String = ""
    @State private var durationMinutes: Int = 45
    @State private var exercises: [TemplateExercise] = []
    @State private var showExercisePicker = false

    private var canSave: Bool { !name.isEmpty && !exercises.isEmpty }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.backmain.ignoresSafeArea()

                List {
                    Section {
                        nameField
                        durationField
                    }

                    Section {
                        ForEach(exercises.indices, id: \.self) { index in
                            exerciseRow(at: index)
                        }
                        .onDelete { exercises.remove(atOffsets: $0) }

                        addExerciseButton
                    } header: {
                        Text("EXERCISES")
                            .foregroundColor(.weekDay)
                            .font(AppFont.caption)
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
                .scrollDismissesKeyboard(.interactively)
            }
            .dismissKeyboardOnTap()
            .navigationTitle("New Template")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(WorkoutTemplateModel(
                            name: name,
                            durationMinutes: durationMinutes,
                            dayOfWeek: "",
                            calories: 0,
                            exercises: exercises
                        ))
                        dismiss()
                    }
                    .disabled(!canSave)
                    .foregroundColor(canSave ? .currentday : .weekDay)
                }
            }
            .sheet(isPresented: $showExercisePicker) {
                ExercisePickerView { selected in
                    for ex in selected where !exercises.contains(where: { $0.exerciseID == ex.id }) {
                        exercises.append(TemplateExercise(exerciseID: ex.id, setsCount: 3, reps: 10))
                    }
                }
            }
        }
    }

    private var nameField: some View {
        HStack {
            Text("Name")
                .font(AppFont.subheadline)
                .foregroundColor(.white)
            TextField("e.g. Push Day", text: $name)
                .multilineTextAlignment(.trailing)
                .foregroundColor(.currentday)
                .font(AppFont.subheadline)
        }
        .listRowBackground(Color.backbutton)
    }

    private var durationField: some View {
        HStack {
            Text("Duration")
                .font(AppFont.subheadline)
                .foregroundColor(.white)
            Spacer()
            Button(action: { if durationMinutes > 5 { durationMinutes -= 5 } }) {
                Image(systemName: "minus.circle")
                    .foregroundColor(.weekDay)
            }
            .buttonStyle(.plain)
            Text("\(durationMinutes) min")
                .foregroundColor(.currentday)
                .font(AppFont.subheadline)
                .frame(width: 70, alignment: .center)
            Button(action: { if durationMinutes < 180 { durationMinutes += 5 } }) {
                Image(systemName: "plus.circle")
                    .foregroundColor(.currentday)
            }
            .buttonStyle(.plain)
        }
        .listRowBackground(Color.backbutton)
    }

    private func exerciseRow(at index: Int) -> some View {
        let ex = exercises[index]
        let definition = ExerciseLoader.byID[ex.exerciseID]
        return HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(definition?.name ?? "Exercise \(ex.exerciseID)")
                    .font(AppFont.subheadline)
                    .foregroundColor(.white)
                Text(definition?.primaryMuscle.rawValue ?? "")
                    .font(AppFont.caption)
                    .foregroundColor(.weekDay)
            }
            Spacer()
            HStack(spacing: 12) {
                Button(action: { if exercises[index].setsCount > 1 { exercises[index].setsCount -= 1 } }) {
                    Image(systemName: "minus.circle")
                        .foregroundColor(.weekDay)
                }
                .buttonStyle(.plain)
                Text("\(ex.setsCount)")
                    .foregroundColor(.currentday)
                    .font(AppFont.subheadline)
                    .frame(width: 16, alignment: .center)
                Button(action: { if exercises[index].setsCount < 10 { exercises[index].setsCount += 1 } }) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.currentday)
                }
                .buttonStyle(.plain)
                Text("sets")
                    .font(AppFont.caption)
                    .foregroundColor(.weekDay)
            }
        }
        .listRowBackground(Color.backbutton)
    }

    private var addExerciseButton: some View {
        Button(action: { showExercisePicker = true }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.currentday)
                Text("Add Exercise")
                    .font(AppFont.subheadline)
                    .foregroundColor(.currentday)
            }
        }
        .listRowBackground(Color.backbutton)
    }
}
