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
        HStack(spacing: 0) {
            ForEach(StatisticsSection.allCases, id: \.self) { section in
                Button {
                    selection = section
                } label: {
                    Text(section.title)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(selection == section ? Color.white.opacity(0.8) : Color.weekDay)
                        .shadow(color: selection == section ? Color.currentday : Color.clear, radius: 4, x: 0, y: 0)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
            }
        }
        .background(Color.backbutton)
        .clipShape(RoundedRectangle(cornerRadius: 18 ,style: .continuous))
        .padding(.horizontal, 8)
    }
}
