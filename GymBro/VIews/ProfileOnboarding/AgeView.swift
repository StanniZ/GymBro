

import SwiftUI
import AVFoundation
import AudioToolbox

struct AgeView: View {
    @StateObject var viewModel: OnboardingViewModel
    var body: some View {
        ZStack{
            divider
            VStack(alignment: .center){
                customPicker
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(55)
        .background(.backmain)
    }
    
    private var customPicker: some View{
        GeometryReader{ geo in
            CustomPicker(selectedValue: $viewModel.userProfile.age, range: Array(16...70))
                .frameRelative(to: geo, widthPercent: 0.6, heightPercent: 0.75)
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
            
        }
    }
    
    private var divider: some View {
        GeometryReader { geo in
            ZStack {
                HorizontalDottedLine(dotSize: 3, spacing: 3)
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                HorizontalDottedLine(dotSize: 3, spacing: 3)
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                    .padding(.top, -75)
            }
        }
    }
}

#Preview {
    AgeView(viewModel: OnboardingViewModel(repository: MockUserProfileRepository()))
}

struct CustomPicker: View {
    @Binding var selectedValue: Int
    let range: [Int]
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    @State private var timer: Timer?
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 20) {
                ForEach(range, id: \.self) { value in
                    GeometryReader { innerGeo in
                        let globalFrame = innerGeo.frame(in: .global)
                        let midY = globalFrame.midY
                        let centerY = geo.frame(in: .global).midY
                        let distance = abs(centerY - midY)
                        let isClosest = distance < 30
                        
                        Text("\(value)")
                            .font(.system(size: isClosest ? 30 : 26))
                            .fontWeight(isClosest ? .bold : .regular)
                            .foregroundColor(isClosest ? .white : .gray.opacity(0.5))
                            .scaleEffect(scaleEffect(for: distance))
                            .opacity(opacity(for: distance))
                            .frame(width: geo.size.width, height: 50)
                            .animation(.easeInOut(duration: 0.2))
                    }
                    .frame(height: 45)
                }
            }
            .padding(.vertical, geo.size.height / 2 - 20)
            .offset(y: dragOffset)
            .onReceive(timer ?? Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
                updateSelectedValue(geometry: geo)
            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        isDragging = true
                        dragOffset = gesture.translation.y
                        startTimer()
                        
                    }
                    .onEnded { _ in
                        stopTimer()
                        snapToNearestValue()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            isDragging = false
                            playTickSound()
                        }
                    }
            )
            .mask(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .clear, location: 0),
                        .init(color: .black, location: 0.15),
                        .init(color: .black, location: 0.85),
                        .init(color: .clear, location: 1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .onAppear {
                // Инициализируем позицию для выбранного значения
                if let initialIndex = range.firstIndex(of: selectedValue) {
                    let itemHeight: CGFloat = 65
                    dragOffset = -CGFloat(initialIndex) * itemHeight
                }
            }
        }
        .padding(.bottom, 80)
    }
    
    private func startTimer() {
        timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    }
    
    private func stopTimer() {
        timer?.upstream.connect().cancel()
        timer = nil
    }
    
    private func updateSelectedValue(geometry: GeometryProxy) {
        guard !isDragging else { return }
        
        let itemHeight: CGFloat = 65
        let currentIndex = -Int(round(dragOffset / itemHeight))
        let clampedIndex = max(0, min(range.count - 1, currentIndex))
        let newValue = range[clampedIndex]
        
        if newValue != selectedValue {
            selectedValue = newValue
        }
    }
    
    private func snapToNearestValue() {
        let itemHeight: CGFloat = 65
        let targetIndex = -Int(round(dragOffset / itemHeight))
        let clampedIndex = max(0, min(range.count - 1, targetIndex))
        let targetValue = range[clampedIndex]
        let targetOffset = -CGFloat(clampedIndex) * itemHeight
        
        selectedValue = targetValue
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            dragOffset = targetOffset
        }
    }
    
    func playTickSound() {
        AudioServicesPlaySystemSound(1104)
        
        // Добавляем тактильную обратную связь
        if #available(iOS 10.0, *) {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.prepare()
            impactFeedback.impactOccurred()
        }
    }
    
    func opacity(for distance: CGFloat) -> Double {
        let maxDistance: CGFloat = 120
        let normalized = max(0.2, 1 - (distance / maxDistance))
        return Double(normalized)
    }
    
    func scaleEffect(for distance: CGFloat) -> Double {
        let maxDistance: CGFloat = 200
        let minScale: Double = 0.6
        let maxScale: Double = 1.6
        
        let normalized = max(0, 1 - (distance / maxDistance))
        let scale = minScale + (maxScale - minScale) * normalized
        return scale
    }
}
