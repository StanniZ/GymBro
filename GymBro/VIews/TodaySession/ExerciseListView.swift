//
//  ExerciseListView.swift
//  GymBro
//
//  Created by macbook on 29/06/2025.
//
import SwiftUI

struct ExerciseListView: View {
    
    enum PickerType {
        case none, reps, weightKg
    }
    
    @Binding var exercise: ExerciseModel
    @State private var offsetValues: [UUID: CGFloat] = [:]
    @State private var selectedReps: Int = 8
    @State private var selectedWeight: Double = 0
    @State private var setId: UUID? = nil
    @State private var activePicker: PickerType = .none
    @State private var showPicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            exerciseHeader
            
            if exercise.isExpanded {
                exerciseContent
            }
            
            
        }
        .sheet(isPresented: $showPicker) {
            pickerSheet
        }
    }
    
    // MARK: - Exercise Header
    private var exerciseHeader: some View {
        HStack(spacing: 8) {
            Image(systemName: "chevron.down.dotted.2")
                .rotationEffect(.degrees(exercise.isExpanded ? 180 : 0))
                .font(.system(size: 10, weight: .medium, design: .default))
                .foregroundStyle(Color.white)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        exercise.isExpanded.toggle()
                    }
                }
            
            Text("\(exercise.name)")
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundStyle(Color.white)
        }
    }
    
    // MARK: - Exercise Content
    private var exerciseContent: some View {
        VStack(alignment: .leading, spacing: 4) {
            HorizontalDottedLine()
            
            addSetButton
            
            ForEach($exercise.sets) { $set in
                setRow(for: $set)
            }
        }
    }
    
    // MARK: - Add Set Button
    private var addSetButton: some View {
        HStack {
            Spacer()
            Text("Add Set")
                .font(.system(size: 12, weight: .medium, design: .default))
                .foregroundStyle(Color.gray)
            
            Image(systemName: "plus.circle")
                .frame(width: 14, height: 14)
                .foregroundStyle(Color.currentday)
                .onTapGesture {
                    addSet()
                }
        }
    }
    
    // MARK: - Set Row
    private func setRow(for set: Binding<ExerciseSetModel>) -> some View {
        let setIndex = exercise.sets.firstIndex(where: { $0.id == set.id.wrappedValue }) ?? 0
        
        return VStack {
            HorizontalDottedLine()
            
            HStack {
                deleteButton(for: set)
                Spacer()
                setInfoView(for: set, index: setIndex)
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .opacity))
    }
    
    // MARK: - Delete Button
    private func deleteButton(for set: Binding<ExerciseSetModel>) -> some View {
        Image(systemName: "trash.circle")
            .frame(width: 16, height: 16)
            .foregroundStyle(Color.trashcolor)
            .onTapGesture {
                deleteSet(set)
            }
    }
    
    // MARK: - Set Info View
    private func setInfoView(for set: Binding<ExerciseSetModel>, index: Int) -> some View {
        HStack {
            Text("\(index + 1) Set")
            repsButton(for: set)
            weightButton(for: set)
        }
        .font(.system(size: 15, weight: .medium, design: .default))
        .foregroundStyle(Color.white)
        .offset(x: offsetValues[set.id.wrappedValue] ?? 0)
        .gesture(dragGesture(for: set))
    }
    
    // MARK: - Reps Button
    private func repsButton(for set: Binding<ExerciseSetModel>) -> some View {
        Text("reps - \(set.reps.wrappedValue)")
            .onTapGesture {
                selectedReps = set.reps.wrappedValue
                setId = set.id.wrappedValue
                activePicker = .reps
                showPicker = true
            }
    }
    
    // MARK: - Weight Button
    private func weightButton(for set: Binding<ExerciseSetModel>) -> some View {
        Text("weight - \(set.weightKg.wrappedValue, specifier: "%.1f")")
            .onTapGesture {
                selectedWeight = set.weightKg.wrappedValue
                setId = set.id.wrappedValue
                activePicker = .weightKg
                showPicker = true
            }
    }
    
    // MARK: - Drag Gesture
    private func dragGesture(for set: Binding<ExerciseSetModel>) -> some Gesture {
        DragGesture()
            .onChanged { gesture in
                if gesture.translation.width < 0 {
                    offsetValues[set.id.wrappedValue] = gesture.translation.width
                }
            }
            .onEnded { _ in
                let offset = offsetValues[set.id.wrappedValue] ?? 0
                if offset < -90 {
                    withAnimation {
                        deleteSet(set)
                        offsetValues[set.id.wrappedValue] = 0
                    }
                } else {
                    withAnimation {
                        offsetValues[set.id.wrappedValue] = 0
                    }
                }
            }
    }
    
    // MARK: - Picker Sheet
    private var pickerSheet: some View {
        VStack {
            pickerContent
            doneButton
        }
        .presentationBackground(Color.clear)
        .presentationDetents([.height(300)])
    }
    
    // MARK: - Picker Content
    private var pickerContent: some View {
        VStack {
            if activePicker == .reps {
                repsPicker
            } else if activePicker == .weightKg {
                weightPicker
            }
        }
        .pickerStyle(.wheel)
        .frame(height: 200)
        .background(Color.pickercolor)
        .cornerRadius(20)
    }
    
    // MARK: - Reps Picker
    private var repsPicker: some View {
        Picker("Selected reps", selection: $selectedReps) {
            ForEach(1...10, id: \.self) { number in
                Text("\(number)").tag(number)
            }
        }
    }
    
    // MARK: - Weight Picker
    private var weightPicker: some View {
        Picker("Selected weight", selection: $selectedWeight) {
            ForEach(1...30, id: \.self) { number in
                Text("\(number)").tag(Double(number))
            }
        }
    }
    
    // MARK: - Done Button
    private var doneButton: some View {
        Button("Done") {
            updateSetValue()
            showPicker = false
            activePicker = .none
        }
        .foregroundStyle(Color.currentday)
        .font(.system(size: 18, weight: .bold, design: .default))
    }
    
    // MARK: - Helper Methods
    private func deleteSet(_ set: Binding<ExerciseSetModel>) {
        if exercise.sets.count > 1 {
            if let index = exercise.sets.firstIndex(where: { $0.id == set.id.wrappedValue }) {
                exercise.sets.remove(at: index)
            }
        }
    }
    
    private func addSet() {
        if exercise.sets.count < 12 {
            exercise.sets.append(ExerciseSetModel(reps: 8, timestamp: Date(), weightKg: 0.0))
        }
    }
    
    private func updateSetValue() {
        guard let id = setId,
              let idx = exercise.sets.firstIndex(where: { $0.id == id }) else { return }
        
        if activePicker == .reps {
            exercise.sets[idx].reps = selectedReps
        } else if activePicker == .weightKg {
            exercise.sets[idx].weightKg = selectedWeight
        }
    }
}
