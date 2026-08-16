//
//  StatisticsSectionPicker.swift
//  GymBro
//
//  Created by macbook on 09/01/2026.
//
import SwiftUI

struct StatisticsSectionPicker: View {
    @Binding var selection: StatisticsSection

    var body: some View {
        HStack(spacing: 4) {
            ForEach(StatisticsSection.allCases, id: \.self) { section in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { selection = section }
                } label: {
                    Text(section.title)
                        .font(.system(size: 14, weight: selection == section ? .semibold : .regular))
                        .foregroundColor(selection == section ? .black : .white.opacity(0.4))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 9)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(selection == section ? Color.currentday : Color.clear)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(Color.backbutton)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
