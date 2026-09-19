//
//  CastomPicker.swift
//  GymBro
//
//  Created by macbook on 16/08/2025.
//
import SwiftUI


struct CustomPicker<T: Hashable & Comparable & Strideable & LosslessStringConvertible>: View {
    
    @Binding var selectedValue: T
    
    let range: [T]
    let selectedFontSize: CGFloat
    let secondaryFontSize: CGFloat
    let selectedColor: Color
    let secondaryColor: Color

    init(
        selectedValue: Binding<T>,
        range: [T],
        selectedFontSize: CGFloat,
        secondaryFontSize: CGFloat,
        selectedColor: Color = Color.currentday,
        secondaryColor: Color = Color.weekDay.opacity(0.7)
    ) {
        self._selectedValue = selectedValue
        self.range = range
        self.selectedFontSize = selectedFontSize
        self.secondaryFontSize = secondaryFontSize
        self.selectedColor = selectedColor
        self.secondaryColor = secondaryColor
    }
    
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
                        
                        Text(String(value))
                            .font(.system(size: isClosest ? selectedFontSize : secondaryFontSize))
                            .fontWeight(isClosest ? .bold : .regular)
                            .foregroundColor(isClosest ? selectedColor : secondaryColor)
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
                            PlaySound.playTickSound()
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
