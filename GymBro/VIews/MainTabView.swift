//
//  MainTabView.swift
//  GymBro
//
//  Created by macbook on 06/06/2025.
import SwiftUI

struct MainTabView: View {

    @EnvironmentObject var profileVM: OnboardingViewModel
    @EnvironmentObject var settingsVM: SettingsViewModel
    @EnvironmentObject var foodVM: FoodTrackerViewModel
    @State private var selection = 0
   
   var body: some View {
       ZStack(alignment: .bottom) {
           Color.backmain.ignoresSafeArea()
           content
               .frame(maxWidth: .infinity, maxHeight: .infinity)
           backgroundTab
       }
       .background(Color.backmain.ignoresSafeArea())
       .ignoresSafeArea(edges: .bottom)
   }
    
   @ViewBuilder
   private var content: some View {
       switch selection {
       case 0:
           MainView()
       case 1:
           FoodTracker(selectedTab: $selection)
       case 2:
           StatisticsView()
       case 3:
           SettingsView()
       default:
           MainView()
       }
   }
   
   private var backgroundTab: some View {
       ZStack {
           RoundedRectangle(cornerRadius: 30)
               .fill(Color.backbutton)
//               .overlay(
//                   RoundedRectangle(cornerRadius: 30)
//                       .stroke(Color.borderbtn, lineWidth: 1)
//               )
               .frame(maxHeight: 60)
               .padding(.horizontal, 16)
           
           HStack(spacing: 60) {
               TabItem(index: 0, imageName: "home", size: 26)
               TabItem(index: 1, imageName: "cherry", size: 30)
               TabItem(index: 2, imageName: "statistics", size: 30)
               TabItem(index: 3, imageName: "user", size: 26)
           }
           .padding(.horizontal, 40)
           .padding(.vertical, 16)
       }
       .padding(.bottom, 16)
   }
   
   private func TabItem(index: Int, imageName: String, size: CGFloat) -> some View {
       Button(action: {
           selection = index
       }) {
           VStack {
               Image(imageName)
                   .resizable()
                   .renderingMode(.template)
                   .aspectRatio(contentMode: .fit)
                   .frame(width: size, height: size)
                   .foregroundStyle(selection == index ? Color.currentday : Color.weekDay)
           }
       }
   }
}

//#Preview {
//    MainTabView()
//}
