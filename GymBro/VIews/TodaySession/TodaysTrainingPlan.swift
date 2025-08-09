//
//  FullTodayWorkoutView.swift
//  GymBro
//
//  Created by macbook on 09/06/2025.

import SwiftUI

struct TodaysTrainingPlan: View {
    
    @ObservedObject var viewModel: TodaySessionViewModel
    
    private var session: TrainingSessionModel {
        viewModel.draftSession
    }
    
    var body: some View {
        Group{
            if viewModel.state == .saved {
                ZStack{
                    Color.backmain.ignoresSafeArea()
                    completeSession
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            } else {
                ScrollView{
                    VStack(alignment: .leading, spacing: 16){
                        header
                        middleHeader
                        exercisesList
                        finishSessionButton
                    }
                    .ignoresSafeArea(edges: .all)
                    .frame(maxWidth: .infinity)
                    .padding(16)
                }
                .background(Color.backmain)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: viewModel.state)
    }
    
    //MARK: - Header
    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack{
                Text("Today's Training Plan:")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(.white)
            }
            
            Text("\(session.muscleName)")
                .font(.system(size: 18, weight: .medium, design: .default))
                .foregroundColor(.white)
                .fixedSize()
                .padding(8)
                .background(Capsule().fill(Color.backbutton))
                .overlay(Capsule().stroke(Color.borderbtn, lineWidth: 0.5))
        }
    }
                
    //MARK: - Middle-header
    private var middleHeader: some View {
        VStack(alignment: .leading){
            HStack(spacing: 8){
                middleSection(icon: "flame.fill", value: session.calories, label: " ~ calories", iconColor: .firecolor, valueColor: .currentday)
                middleSection(icon: "hourglass", value: session.durationMinutes, label: "min", iconColor: .white, valueColor: .currentday)
            }
            Spacer()
        }
    }
    
    private func middleSection(icon: String, value: Int, label: String, iconColor: Color, valueColor: Color, labelColor: Color = .weekDay) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundStyle(iconColor)
            Text("\(value)")
                .foregroundStyle(valueColor)
            Text("\(label)")
                .foregroundStyle(labelColor)
        }
        .padding(8)
        .background(Capsule().fill(Color.backbutton))
        .overlay(Capsule().stroke(Color.borderbtn, lineWidth: 0.5))
        .font(.system(size: 13, weight: .medium))
        .foregroundStyle(Color.white)
    }
    
    //MARK: - Exercises list
    private var exercisesList: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 8){
                ForEach(viewModel.draftSession.exercises.indices, id: \.self){ index in
                    ExerciseListView(exercise: $viewModel.draftSession.exercises[index])
                    if index < viewModel.draftSession.exercises.count - 1 {
                        HorizontalDottedLine()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            Spacer()
        }
        .background(gradientBackground)
        .cornerRadius(12)
        .shadow(color: .borderbtn, radius: 1, x: 0, y: 0)
    }
    
    //MARK: - Gradient for background exercises list
    private var gradientBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "#232531"),
                Color(hex: "#2d3436"),
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    @ViewBuilder
    private var finishSessionButton: some View {
        VStack {
            Button {
                withAnimation(.easeInOut(duration: 1)){
                    viewModel.finishSession()
                }
            } label: {
                switch viewModel.state {
                case .ready:
                    Text("Finish session")
                case .saving:
                    HStack(spacing: 8){
                        ProgressView()
                        Text("Saving...")
                    }
                case .saved:
                    Label("Saved", systemImage: "checkmark.circle,fill")
                case .failed:
                    Text("Retry please...")
                }
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(Color(.getstarted))
            .cornerRadius(12)
            .shadow(color: .white, radius: 1, x: 1, y: -1)
            
            .disabled(viewModel.state != .ready)
            .opacity(viewModel.state != .ready ? 0.6 : 1)
        }
    }
    
    private var completeSession: some View {
        HStack {
            Text("Workout complete — time to relax!")
                .font(.title)
                .foregroundStyle(.white)
                .padding(32)
                
        }
    }
}
