//
//  MainHeader.swift
//  GymBro
//
//  Created by macbook on 02/06/2025.
//
import SwiftUI

struct MainHeader: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    print("Taped")
                }) {
                    Image(.ava)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .cornerRadius(14)
                        .shadow(color: .borderbtn, radius: 1, x: 0, y: 0)
                }
                
                VStack(alignment: .leading){
                    Text("Good Morning")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.titlewords)
                    Text("John Smith")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                Spacer()
                Button(action: {
                    print("Taped")
                }) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                        
                        Circle()
                            .fill(Color.notificationbtn)
                            .frame(width: 7, height: 7)
                            .offset(x: -1, y: 0)
                    }
                    .frame(width: 40, height: 40)
                    .background(Color.backbutton)
                    .cornerRadius(14)
                    .shadow(color: .borderbtn, radius: 1, x: 0, y: 0)
                    
                }
            }
            .padding(.bottom, 20)
        }
    }
}
