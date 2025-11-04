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
        .foregroundColor(.calendbtn)
        .padding(8)
        .overlay(border)
    }
    
    private var scrollCalendar: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    ForEach(alldDays, id: \.self) { date in
                        ZStack {
                            Capsule()
                                .stroke(calendar.isDateInToday(date) ? Color.currentday : Color.clear, lineWidth: 1)
                                .fill(viewModel.isCompleted(date) ? Color.currentday.opacity(0.3) : Color.clear)
                                .frame(width: 44, height: 44)
                            VStack(spacing: 2){
                                Text(WeekDay(date: date).dayNumber)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                Text(WeekDay(date: date).dayString)
                                    .fontWeight(.semibold)
                                    .foregroundColor(viewModel.isCompleted(date) ? Color.white: Color.weekDay)
                            }
                            .font(.system(size: 14))
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
    }
    
    private var border: some View {
        RoundedRectangle(cornerRadius: 40)
            .stroke(Color.borderbtn, lineWidth: 1)
    }
    
}
