//
//  WeightUnitView.swift
//  GymBro
//
//  Created by macbook on 06/02/2026.
//
import SwiftUI

struct WeightUnitView: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        ZStack {
            Color.backmain.ignoresSafeArea()
            VStack(spacing: 12) {
                ForEach(WeightUnit.allCases, id: \.self) { unit in
                    unitRow(unit)
                }
                Spacer()
            }
            .padding(16)
        }
        .navigationTitle("Weight Unit")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.backmain, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private func unitRow(_ unit: WeightUnit) -> some View {
        let isSelected = viewModel.weightUnit == unit
        return Button(action: { viewModel.weightUnit = unit }) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue.opacity(0.15))
                        .frame(width: 36, height: 36)
                    Image(systemName: "scalemass.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(unit.displayName)
                        .font(AppFont.body)
                        .foregroundColor(.white)
                    Text(unit == .kg ? "Kilograms" : "Pounds")
                        .font(AppFont.caption)
                        .foregroundColor(.weekDay)
                }
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .currentday : .weekDay)
            }
            .padding(16)
            .background(Color.backbutton)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.currentday : Color.clear, lineWidth: 1.5)
            )
        }
    }
}
