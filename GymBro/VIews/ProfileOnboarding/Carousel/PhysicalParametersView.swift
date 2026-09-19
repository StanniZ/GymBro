//
//  PhysicalParametersView.swift
//  GymBro
//
//  Created by macbook on 11/08/2025.
//
import SwiftUI

struct PhysicalParametersView: View {
    
    @ObservedObject var viewModel: OnboardingViewModel
    var next: () -> Void
    
    var body: some View {
        ZStack{
            VStack(spacing: 18) {
                title
                customPicker
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(16)
        .background(.backmain)
    }

    private var title: some View {
        VStack(spacing: 6) {
            Text("Your body metrics")
                .font(.system(size: 24, weight: .thin))
                .foregroundStyle(Color.logincolor)
            Text("Set your current weight and height")
                .font(.system(size: 16, weight: .thin))
                .foregroundStyle(Color.weekDay.opacity(0.8))
        }
    }

    private var customPicker: some View {
        HStack(spacing: 18) {
            metricPicker(
                title: "Weight",
                unit: "kg",
                picker: CustomPicker(
                    selectedValue: $viewModel.userProfile.weight,
                    range: stride(from: 40.0, through: 200.0, by: 0.5).map { $0 },
                    selectedFontSize: 22,
                    secondaryFontSize: 16
                )
            )

            metricPicker(
                title: "Height",
                unit: "cm",
                picker: CustomPicker(
                    selectedValue: $viewModel.userProfile.height,
                    range: Array(130...240),
                    selectedFontSize: 22,
                    secondaryFontSize: 16
                )
            )
        }
        .frame(maxHeight: 420)
        .clipped()
    }

    private func metricPicker<Picker: View>(title: String, unit: String, picker: Picker) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.weekDay.opacity(0.85))

            picker
                .frame(maxWidth: .infinity)

            Text(unit)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.currentday)
        }
    }
}
