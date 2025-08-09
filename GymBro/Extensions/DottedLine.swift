//
//  DottedLine.swift
//  GymBro
//
//  Created by macbook on 06/06/2025.
//
import SwiftUI

struct VerticalDottedLine: View {
    var dotSize: CGFloat = 4
    var spacing: CGFloat = 6
    var height: CGFloat = 150
    var color: Color = .gray

    var body: some View {
        ZStack {
            VStack(spacing: spacing) {
                ForEach(0..<Int(height / (dotSize + spacing)), id: \.self) { index in
                    Circle()
                        .frame(width: dotSize, height: dotSize)
                        .foregroundColor(color)
                        .opacity(opacityFor(index: index))
                }
            }
        }
        .frame(width: dotSize, height: height)
    }

    private func opacityFor(index: Int) -> Double {
        let totalDots = Int(height / (dotSize + spacing))
        let middle = Double(totalDots) / 2
        let distance = abs(Double(index) - middle)
        let maxFade = middle
        return max(0.2, 1 - (distance / maxFade))
    }
}

struct HorizontalDottedLine: View {
    var dotSize: CGFloat = 1
    var spacing: CGFloat = 1
    var width: CGFloat = 200
    var color: Color = .gray

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<Int(width / (dotSize + spacing)), id: \.self) { index in
                Circle()
                    .frame(width: dotSize, height: dotSize)
                    .foregroundColor(color)
                    .opacity(opacityFor(index: index))
            }
        }
        .frame(height: dotSize)
    }

    private func opacityFor(index: Int) -> Double {
        let totalDots = Int(width / (dotSize + spacing))
        let middle = Double(totalDots) / 2
        let distance = abs(Double(index) - middle)
        let maxFade = middle
        return max(0.3, 1 - (distance / maxFade))
    }
}

struct HorizontalDottedLineSettings: View {
    var dotSize: CGFloat = 1
    var spacing: CGFloat = 1
    var width: CGFloat = 1000
    var color: Color = .gray

    var body: some View {
        HStack(spacing: spacing) {
            let dotCount = max(0, Int(width / max(dotSize + spacing, 0.1)))
        
            ForEach(0..<dotCount, id: \.self) { index in
                Circle()
                    .frame(width: dotSize, height: dotSize)
                    .foregroundColor(color)
                    .opacity(opacityFor(index: index))
            }
        }
        .frame(height: dotSize)
    }

    private func opacityFor(index: Int) -> Double {
        let totalDots = Int(width / (dotSize + spacing))
        let middle = Double(totalDots) / 2
        let distance = abs(Double(index) - middle)
        let maxFade = middle
        return max(0.3, 1 - (distance / maxFade))
    }
}
