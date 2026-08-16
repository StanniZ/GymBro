//
//  WelcomeView.swift
//  GymBro
//
//  Created by macbook on 30/05/2025.
//
import SwiftUI

struct WelcomeView: View {
    @State private var offsetY: CGFloat = -300
    @State private var rotateDumbbell = false
    @State private var showImpact = false
    @State private var showTitle = false
    @State private var scaleEffect: CGFloat = 1.0
    @State private var fadeOut = false
    @State private var showSparks = false
    
    var onFinish: () -> Void

    let sparks: [Spark] = (0..<12).map { _ in
        Spark(
            angle: Double.random(in: 0..<360),
            distance: CGFloat.random(in: 20...60),
            color: [Color.green, Color.yellow, Color.orange, Color.red].randomElement() ?? Color.green
        )
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Image(.welcomegym)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer()

                    ZStack {
                        if showSparks {
                            ForEach(sparks) { spark in
                                Circle()
                                    .fill(spark.color)
                                    .frame(width: 4, height: 4)
                                    .offset(x: showSparks ? spark.distance * CGFloat(cos(spark.angle * .pi / 180)) : 0,
                                            y: showSparks ? spark.distance * CGFloat(sin(spark.angle * .pi / 180)) : 0)
                                    .opacity(showSparks ? 0 : 1)
                                    .animation(.easeOut(duration: 0.5), value: showSparks)
                            }
                        }

                        Image(systemName: "dumbbell")
                            .resizable()
                            .frame(width: 80, height: 60)
                            .foregroundColor(Color.currentday)
                            .shadow(color: Color.black, radius: 2, x: 0, y: 0)
                            .shadow(color: Color.getstarted.opacity(0.6), radius: 2)
                            .rotationEffect(.degrees(rotateDumbbell ? 10 : -25))
                            .offset(y: offsetY)
                            .scaleEffect(scaleEffect)
                            .animation(.easeIn(duration: 0.6), value: offsetY)
                    }
                    .frame(height: 100)

                    if showTitle {
                        Text("GymBro")
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                            .foregroundColor(Color.currentday)
                            .shadow(color: Color.black, radius: 2, x: 0, y: 0)
                            .scaleEffect(scaleEffect)
                            .transition(.opacity)
                            .opacity(fadeOut ? 0 : 1)
                    }

                    Spacer()

                    if showTitle && !fadeOut {
                        SwipeButton {
                            onFinish()
                        }
                    }
                }
                .opacity(fadeOut ? 0 : 1)
            }
            .onAppear {
                withAnimation(Animation.easeIn(duration: 0.6)) {
                    offsetY = 0
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    showSparks = true
                    rotateDumbbell.toggle()

                    withAnimation(.easeOut(duration: 0.3)) {
                        scaleEffect = 1.3
                    }

                    withAnimation(.easeInOut(duration: 0.3).delay(0.3)) {
                        scaleEffect = 1.0
                    }
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation {
                        showTitle = true
                    }
                }
            }
        }
    }
}

struct Spark: Identifiable {
    let id = UUID()
    let angle: Double
    let distance: CGFloat
    let color: Color
}

struct SwipeButton: View {
    var action: () -> Void

    @GestureState private var dragOffset: CGFloat = 0
    @State private var isCompleted = false

    let buttonWidth: CGFloat = UIScreen.main.bounds.width * 0.8
    let sliderSize: CGFloat = 50
    
    private var maxDragOffset: CGFloat {
        buttonWidth - sliderSize - 16
    }
    
    private var initialOffset: CGFloat {
        -(buttonWidth / 2 - sliderSize / 2 - 6)
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.white.opacity(0.1))
                .frame(width: buttonWidth, height: 62)
                .shadow(color: .white.opacity(0.5), radius: 0.4, x: 0.5, y: -0.5)
            Circle()
                .fill(Color.getstarted)
                .frame(width: sliderSize, height: sliderSize)
                .shadow(color: .white.opacity(0.5), radius: 0.4, x: 0.5, y: -0.5)
                .overlay(
                    HStack(spacing: -6){
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white.opacity(0.4))
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white.opacity(0.6))
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white.opacity(0.8))
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                )
                .offset(x: initialOffset + dragOffset)
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            let limitedOffset = min(max(0, value.translation.width), maxDragOffset)
                            state = limitedOffset
                        }
                        .onEnded { value in
                            if value.translation.width > maxDragOffset * 0.7 {
                                withAnimation {
                                    isCompleted = true
                                }
                                action()
                            }
                        }
                )
            
            Spacer()
            
            HStack {

                if !isCompleted {
                    Text("Get started")
                        .font(.system(size: 19))
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }

            }
            .frame(width: buttonWidth - sliderSize, height: 60)
        }
        .padding(36)
    }
}





