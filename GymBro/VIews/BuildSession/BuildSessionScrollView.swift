//
//  BuildSessionView.swift
//  GymBro
//
//  Created by macbook on 02/06/2025.
//
import SwiftUI

struct BuildSessionScrollView: View {
    @StateObject var viewModel: BuildSessionViewModel
    
    var body: some View {
        
        VStack (spacing: 6){
            headerBuildSession
            scrollSession
        }
    }
    //MARK: - Header build session
    //TODO: - Button for add new build session
    private var headerBuildSession: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Build Session")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Text("Choose a workout:")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.weekDay)
            }
            
            Spacer()
            
            Button (action: {
                print("Button tapped")
            }) {
                ZStack {
                    Capsule()
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .foregroundColor(.white)
                        .frame(width: 37, height: 32)
                    Image(systemName: "plus")
                        .foregroundColor(.currentday)
                }
            }
        }
        .padding(.bottom, 8)
    }
    
    //MARK: - Scroll session
    //TODO: - personal image
    private var scrollSession: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(viewModel.sessions) { session in
                    BuildSessionCard(session: session, viewModel: viewModel)
                }
            }
        }
        .padding(12)
        .background(Color.backbutton)
        .cornerRadius(16)
    }
}


struct BuildSessionCard: View {
    let session: TrainingSessionModel
    let viewModel: BuildSessionViewModel

    var body: some View {
        Button(action: {
            viewModel.didSelectSession(session)
        }) {
            ZStack {
                linearGradientBackground
                HStack(spacing: 0){
                    Spacer()
                    imageSession
                }
                VStack(alignment: .leading, spacing: 8) {
                    titleSession
                    countExercice
                    Spacer()
                    durationSession
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(width: 220, height: 160)
            .cornerRadius(16)
            .overlay(border)
        }
    }
    
    private var countExercice: some View {
        HStack(spacing: 4){
            Image(systemName: "dumbbell")
                .foregroundColor(.white)
            Text("\(session.countExercise)")
                .foregroundColor(.currentday)
        }
        .font(.system(size: 14, weight: .medium))
        .padding(.bottom, 16)
    }
    
    private var titleSession: some View {
        Text(session.muscleName)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.white)
            .shadow(color: Color.black, radius: 1.5, x: 0, y: 0)
    }
    
    private var durationSession: some View {
        HStack(spacing: 4){
            Image(systemName: "hourglass")
                .foregroundColor(.white)
            (
                Text("\(session.durationMinutes)")
                    .foregroundColor(.currentday)
                + Text(" min")
                    .foregroundColor(.weekDay)
            )
        }
        .font(.system(size: 14, weight: .medium))
    }
    
    private var imageSession: some View {
        Image(session.foto)
            .resizable()
            .scaledToFill()
            .frame(width: 110, height: 160)
            .clipped()
    }
    
    private var linearGradientBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "#232531"),
                Color(hex: "#2f2932"),
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private var border: some View {
        RoundedRectangle(cornerRadius: 16)
            .stroke(Color.borderbtn, lineWidth: 1)
    }
}
