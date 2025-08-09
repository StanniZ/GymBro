//
//  TodaysWorkoutView.swift
//  GymBro
//
//  Created by macbook on 03/06/2025.

import SwiftUI

struct TodaysWorkoutView: View {
    
    @ObservedObject var viewModel: TodaySessionViewModel
    
    private var session: TrainingSessionModel {
        viewModel.draftSession
    }
    
    var body: some View {
        header
        NavigationLink(
            destination: TodaysTrainingPlan(viewModel: viewModel)
        ){
            ZStack{
                Group{
                    if viewModel.state == .saved {
                        completeSession
                    } else {
                        VStack{
                            sessionFoto
                            calories
                            Spacer()
                        }
                        VStack{
                            HStack{
                                VStack(alignment: .leading){
                                    muscleName
                                    listOfExercises
                                }
                                Spacer()
                            }
                        }
                        .padding(12)
                    }
                }
            }
            .background(gradientBackground)
            .cornerRadius(12)
            .shadow(color: Color.white, radius: 1, x: 0, y: 0)
        }
    }
    
    private var completeSession: some View {
        HStack{
            Text("Workout complete - time to relax!")
                .font(.title)
                .foregroundStyle(Color.white)
                .padding(32)
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading){
            Text("Today's Workout")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.white)
            Text("Check your list:")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color.weekDay)
            
        }
    }
    
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
    
    private var sessionFoto: some View {
        HStack(alignment: .top, spacing: 0){
            Spacer()
            Image(session.foto)
                .resizable()
                .scaledToFill()
                .frame(width: 130, height: 200)
                .cornerRadius(8)
                .clipped()
        }
    }
    
    private var calories: some View {
        VStack{
            Spacer()
            HStack(spacing: 0){
                Spacer()
                Text("caloires ~ ")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color.weekDay)
                Text("\(session.calories) ")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color.currentday)
                Image(systemName: "flame.fill")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Color.firecolor)
                
            }
            .padding(6)
        }
    }
    
    private var muscleName: some View {
        Text(session.muscleName)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.white)
            .padding(.bottom, 8)
    }
    
    private var listOfExercises: some View {
        ForEach(session.exercises.indices, id: \.self ) { index in
            ExerciseRow(exercise: session.exercises[index])
            if index < session.exercises.count - 1 {
                HorizontalDottedLine()
            }
        }
    }
    
    
}

//MARK: - List of exercises
struct ExerciseRow: View {
    let exercise: ExerciseModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4){
                Text(exercise.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(1)
                HStack{
                    Text("\(exercise.sets.count) sets")
                }
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.weekDay)
                .lineLimit(1)
            }
        }
    }
}

