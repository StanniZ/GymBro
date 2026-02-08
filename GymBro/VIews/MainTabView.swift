//
//  MainTabView.swift
//  GymBro
//
//  Created by macbook on 06/06/2025.
import SwiftUI

struct MainTabView: View {
    
//    @EnvironmentObject var currentSessionProvider: CurrentSessionProvider
    @EnvironmentObject var profileVM: OnboardingViewModel
    @EnvironmentObject var photoVM: ProfilePhotoViewModel
    @EnvironmentObject var settingsVM: SettingsViewModel
    @State private var selection = 0
   
   var body: some View {
       ZStack(alignment: .bottom) {
           content
               .frame(maxWidth: .infinity, maxHeight: .infinity)
           backgroundTab
       }
       .ignoresSafeArea(edges: .bottom)
   }
    
   @ViewBuilder
   private var content: some View {
       switch selection {
       case 0:
           MainView()
       case 1:
           FoodTracker()
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
           Capsule()
               .fill(Color.backbutton)
               .overlay(
                   Capsule()
                       .stroke(Color.borderbtn, lineWidth: 1)
               )
               .frame(maxHeight: 50)
               .padding(.horizontal, 16)
           
           HStack(spacing: 60) {
               TabItem(index: 0, systemImageName: "house.fill")
               TabItem(index: 1, systemImageName: "fork.knife.circle")
               TabItem(index: 2, systemImageName: "chart.bar.xaxis.ascending")
               TabItem(index: 3, systemImageName: "gearshape.fill")
           }
           .padding(.horizontal, 40)
           .padding(.vertical, 16)
       }
       .padding(.bottom, 16)
   }
   
   private func TabItem(index: Int, systemImageName: String) -> some View {
       Button(action: {
           selection = index
       }) {
           VStack {
               Image(systemName: systemImageName)
                   .resizable()
                   .aspectRatio(contentMode: .fit)
                   .frame(width: 26, height: 26)
                   .foregroundStyle(selection == index ? Color.currentday : Color.weekDay)
           }
       }
   }
}

//#Preview {
//    MainTabView()
//}
