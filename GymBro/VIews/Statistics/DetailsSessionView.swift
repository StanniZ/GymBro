//
//  DetailsSession.swift
//  GymBro
//
//  Created by macbook on 20/09/2025.
//
import SwiftUI

struct DetailsSessionView: View {
    @Environment(\.dismiss) private var dismiss
    let session: TrainingSessionModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            dateSession
            infoSession
            exercisesTitle
            ScrollView(.vertical, showsIndicators: false) {
                exercises
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(16)
        .background(.backmain)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
            ToolbarItem(placement: .principal) {
                title
            }
        }
    }
    
    private var title: some View {
        Text("Finished session")
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(.white)
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
    
    private var header: some View {
        Text(session.name)
            .font(.system(size: 22, weight: .medium))
            .foregroundStyle(.currentday)
    }
    
    private var dateSession: some View {
        HStack(spacing: 8) {
            Image(systemName: "calendar")
                .foregroundColor(.white.opacity(0.5))
            if let timestamp = session.finishedAt {
                Text(timestamp.dateForSessionHistory)
            } else {
                Text("-")
            }
        }
        .font(.system(size: 14, weight: .medium))
        .foregroundStyle(.white.opacity(0.7))
    }
    
    private var infoSession: some View {
        VStack(spacing: 3) {
            HorizontalDottedLineFull(color: .white.opacity(0.5))
            HStack {
                parameterSession(value: "1,076", title: "Total Weight")
                VerticalDottedLine(dotSize: 1, spacing: 2, height: 50)
                parameterSession(value: "\(session.durationMinutes)", title: "Duration")
                VerticalDottedLine(dotSize: 1, spacing: 2, height: 50)
                parameterSession(value: "\(session.calories)", title: "Calories")
            }
            HorizontalDottedLineFull(color: .white.opacity(0.5))
        }
    }
    
    private func parameterSession(value: String, title: String) -> some View {
        VStack(alignment: .center ,spacing: 4){
            Text(value)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.white)
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var exercisesTitle: some View {
        Text("Exercises")
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(.white.opacity(0.7))
    }
    
    private var exercises: some View {
        VStack(spacing: 16) {
            ForEach(session.exercises.indices, id: \.self) { index in
                ExerciseDetails(exercise: session.exercises[index])
                if index < session.exercises.count - 1 {
                    HorizontalDottedLineFull(color: .white.opacity(0.7))
                }
            }
        }
    }
}
