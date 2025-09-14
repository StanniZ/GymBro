//
//  TrackWorkoutView.swift
//  GymBro
//
//  Created by macbook on 07/09/2025.
//
import SwiftUI

struct TrackWorkoutView: View {
    @ObservedObject var viewModel: TodaySessionViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            HStack{
                header
                Spacer()
                startSessionButton
            }
            VStack(spacing: 12){
                HorizontalDottedLineFull()
                parametersSession
                HorizontalDottedLineFull()
            }
            ScrollView(.vertical, showsIndicators: false) {
                exercisesSession
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.backmain)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
            ToolbarItem(placement: .principal) {
                title
            }
            ToolbarItem(placement: .topBarTrailing) {
                finishSessionButton
            }
        }

    }
    
    private var title: some View {
        Text("Track session")
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(.white)
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Workout session")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
            Text(viewModel.draftSession.muscleName)
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(.white)
        }
    }
    
    private var startSessionButton: some View {
            Button(action: {
                
            }) {
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.currentday)
                    .padding()
                    .cornerRadius(8)
            }
    }
    
    private var parametersSession: some View {
        HStack {
            parameterSession(value: "\(viewModel.draftSession.countExercise)", title: "Total Exercises")
            VerticalDottedLine(dotSize: 1, spacing: 2, height: 50)
            parameterSession(value: "\(viewModel.draftSession.durationMinutes)", title: "Duration")
            VerticalDottedLine(dotSize: 1, spacing: 2, height: 50)
            parameterSession(value: "\(viewModel.draftSession.calories)", title: "Calories")
        }
    }
    
    private func parameterSession(value: String, title: String) -> some View {
        VStack(alignment: .center ,spacing: 8){
            Text(value)
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(.white)
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var exercisesSession: some View {
        VStack(spacing: 16){
            ForEach(viewModel.draftSession.exercises.indices, id: \.self) { index in
                ExerciseList(exercise: $viewModel.draftSession.exercises[index])
                if index < viewModel.draftSession.exercises.count - 1 {
                    HorizontalDottedLineFull()
                }
            }
        }
    }
    
    @ViewBuilder
    private var finishSessionButton: some View {
        VStack {
            Button {
                withAnimation(.easeInOut(duration: 1)){
                    viewModel.draftSession.timestamp = Date()
                    viewModel.finishSession()
                }
            } label: {
                switch viewModel.state {
                case .ready:
                    Text("SAVE")
                case .saving:
                    HStack(spacing: 8){
                        ProgressView()
                        Text("Saving...")
                    }
                case .saved:
                    withAnimation(.easeInOut(duration: 1)){
                        Label("Saved", systemImage: "checkmark.circle,fill")
                    }
                case .failed:
                    Text("Retry please...")
                }
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(.logincolor)
            .disabled(viewModel.state != .ready)
            .opacity(viewModel.state != .ready ? 0.6 : 1)
        }
    }
    
    private var backButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .font(.system(size: 18))
        }
    }
}

//#Preview {
//    TrackWorkoutView()
//}
