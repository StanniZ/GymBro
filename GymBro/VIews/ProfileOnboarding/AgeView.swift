

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
            nextButton
        }
        .padding(55)
        .background(.backmain)
    }
    
    private var customPicker: some View{
        GeometryReader{ geo in
            CustomPicker(selectedValue: $viewModel.userProfile.age,
                         range: Array(16...70), selectedFontSize: 30, secondaryFontSize: 26)
                .frameRelative(to: geo, widthPercent: 0.6, heightPercent: 0.75)
                .clipped()
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
            
        }
    }
    
    private var nextButton: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    Task {
                        await viewModel.saveProfile()
                    }
                }) {
                    Text("Next")
                    Image(systemName: "chevron.right")
                }
                .font(.system(size: 18, weight: .thin))
                .foregroundColor(.currentday)
            }
        }
        .padding(.bottom, 100)
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

struct CustomPicker<T: Hashable & Comparable & Strideable & LosslessStringConvertible>: View {
    
    @Binding var selectedValue: T
    
    let range: [T]
    let selectedFontSize: CGFloat
    let secondaryFontSize: CGFloat
    
    @State private var dragOffset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    @State private var lastSoundValue: T?
    
    private let cellHeight: CGFloat = 45
    private let spacing: CGFloat = 20
    
    var body: some View {
        GeometryReader { geo in
            let itemStride = self.cellHeight + self.spacing
            VStack(spacing: 20) {
                ForEach(range, id: \.self) { value in
                    GeometryReader { innerGeo in
                        let globalFrame = innerGeo.frame(in: .global)
                        let midY = globalFrame.midY
                        let centerY = geo.frame(in: .global).midY
                        let distance = abs(centerY - midY)
                        let isClosest = distance < 30
                        
                        Text("\(value)")
                            .font(.system(size: isClosest ? selectedFontSize : secondaryFontSize))
                            .fontWeight(isClosest ? .bold : .regular)
                            .foregroundColor(isClosest ? .white : .gray.opacity(0.5))
                            .scaleEffect(scaleEffect(for: distance))
                            .opacity(opacity(for: distance))
                            .frame(width: geo.size.width, height: 50)

                    }
                    .frame(height: 45)
                }

            }
            .padding(.vertical, geo.size.height / 2 - cellHeight / 2)
            .offset(y: dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        dragOffset = lastOffset + gesture.translation.height
                        
                        let rawIndex = -dragOffset / itemStride
                        let clamped = min(max(Int(round(rawIndex)), 0), range.count - 1)
                        let newValue = range[clamped]
                        
                        if newValue != lastSoundValue {
                            playTickSound()
                            lastSoundValue = newValue
                        }
                        
                        selectedValue = newValue
                    }
                    .onEnded { _ in
                        let rawIndex = -dragOffset / itemStride
                        let snapped = Int(round(rawIndex))
                        let clamped = min(max(snapped, 0), range.count - 1)
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                            dragOffset = -CGFloat(clamped) * itemStride
                        }
                        
                        lastOffset = dragOffset
                        selectedValue = range[clamped]
                    }
            )
            .onAppear {
                if let initialIndex = range.firstIndex(of: selectedValue) {
                    let itemStride = cellHeight + spacing
                    dragOffset = -CGFloat(initialIndex) * itemStride
                    lastOffset = dragOffset
                }
            }
        }
        .padding(.bottom, 80)
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
