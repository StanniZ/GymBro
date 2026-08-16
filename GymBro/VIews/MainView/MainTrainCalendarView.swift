//
//  MainTrainCalendarView.swift
//  GymBro
//
//  Created by macbook on 02/06/2025.
//
import SwiftUI

@MainActor
struct MainTrainCelendarView: View {
    @ObservedObject var viewModel: CalendarViewModel
    let alldDays = Date.generateTwoWeeks(from: Date())
    let calendar = Calendar.current
    
    
    var body: some View {
        VStack {
            scrollCalendar
        }
        .background(Color.backbutton)
        .cornerRadius(28)
    }
    
    private var scrollCalendar: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(alldDays, id: \.self) { date in
                        ZStack {
                            RoundedRectangle(cornerRadius: 22)
                                .fill(calendar.isDateInToday(date) ? Color.currentday : Color.clear)
                                .fill(viewModel.isCompleted(date) ? Color.green : Color.clear)
                                .frame(width: 50, height: 50)
                            VStack(spacing: 4){
                                Text(WeekDay(date: date).dayNumber)
                                    .fontWeight(.bold)
                                    .fontDesign(.rounded)
                                    .foregroundColor(calendar.isDateInToday(date) ? Color.black.opacity(0.8): Color.white)
                                Text(WeekDay(date: date).dayString)
                                    .fontWeight(.semibold)
                                    .foregroundColor(calendar.isDateInToday(date) ? Color.black.opacity(0.8): Color.white)
                            }
                            .font(.subheadline)
                        }
                        .id(date)
                    }
                    .padding(.horizontal, 1)
                }
                .padding(.vertical, 1)
            }
            .onAppear {
                if let startOfWeak = calendar.dateInterval(of: .weekOfYear, for: Date())?.start {
                    if let monday = alldDays.first(where: { calendar.isDate($0, inSameDayAs: startOfWeak) }) {
                        proxy.scrollTo(monday, anchor: .leading)
                    }
                }
            }
        }
        .padding(8)
    }
}
