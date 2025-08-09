//
//  MainTrainCalendarView.swift
//  GymBro
//
//  Created by macbook on 02/06/2025.
//
import SwiftUI

struct MainTrainCelendarView: View {
    let alldDays = DateUtils.generateFromCurrentDateToEndOfMonth()
    let current = WeekDay(date: Date())
    
    var body: some View {
        HStack(spacing: 8) {
            
            //MARK: - Strikes 🔥
            ZStack {
                Capsule()
                    .fill(Color.calendbtn)
                    .shadow(color: .borderbtn, radius: 1, x: 0, y: 0)
                    .frame(width: 60, height: 50)
                VStack(spacing: 2) {
                    HStack(spacing: 4){
                        Image(systemName: "flame.fill")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(Color.firecolor)
                        Text("12")
                            .font(.system(size: 14))
                            .foregroundColor(Color.white)
                            .fontWeight(.semibold)
                        
                    }
                    Text("Strikes")
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                        .foregroundColor(Color.borderbtn)
                }
            }
            
            //MARK: - Dot vertical line
            VerticalDottedLine(dotSize: 1, spacing: 2, height: 60, color: .white)
            
            //MARK: - Calendar with scroll
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    
                    //MARK: - Current day
                    
                    //TODO: - "Relax" or "Time to build"
                    
                    ZStack {
                        Capsule()
                            .fill(Color.calendbtn)
                            .stroke(Color.borderbtn, lineWidth: 1)
                            .frame(width: 165, height: 50)
                        HStack(spacing: 4){
                            ZStack(){
                                Capsule()
                                    .fill(Color.currentday)
                                    .frame(width: 50, height: 43)
                                Text(current.dayString)
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                            }
                            
                            Text("Time to build")
                            
                                .font(.system(size: 16))
                                .foregroundColor(Color.white)
                                .fontWeight(.semibold)
                        }
                        .padding(.trailing, 6)
                    }
                    .padding(.leading, 0.3)
                    
                    //MARK: - regular Calendar
                    
                    ForEach(alldDays, id: \.self) {date in
                        VStack(spacing: 2){
                            Text(WeekDay(date: date).dayNumber)
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                            Text(WeekDay(date: date).dayString)
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.weekDay)
                            
                        }
                    }
                    
                }
            }
        }
        .foregroundColor(.calendbtn)
        .padding(10)
        .background(Color.backbutton.clipShape(Capsule()))
    }
}
