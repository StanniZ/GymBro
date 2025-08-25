//
//  GymBro
//
//  Created by macbook on 03/08/2025.
//
import SwiftUI

struct PersonalInfoView: View {
    @StateObject var viewModel: OnboardingViewModel
    @Binding var selection: Int
    
    var body: some View {
        ZStack{
            VStack(spacing: 16){
                Spacer()
                title
                name
                secondTitle
                email
                quote
                Spacer()
            }
            nextButton
            .padding(.top, 70)
            .padding(.bottom, 70)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(16)
        .background(Color.backmain)
    }
    
    private var title: some View {
        VStack(spacing: 16){
            HStack{
                Text("Hi!")
                    .font(.system(size: 24, weight: .thin))
                    .foregroundColor(.orange)
                Spacer()
            }
            HStack{
                Text("Enter your name:")
                    .font(.system(size: 18, weight: .thin))
                    .foregroundColor(.white.opacity(0.6))
                Spacer()
            }
        }
    }
    
    private var name: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.backbutton)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .shadow(color: Color.white.opacity(0.2), radius: 0.3, x: 1, y: -1)
            TextField("", text: $viewModel.userProfile.name)
                .textContentType(.name)
                .font(.system(size: 24, weight: .thin))
                .padding(.leading, 26)
                .foregroundStyle(.currentday)
        }
    }
    
    private var secondTitle: some View {
        HStack{
            Text("Enter your email:")
                .font(.system(size: 18, weight: .thin))
                .foregroundColor(.white.opacity(0.6))
            Spacer()
        }
    }
    
    private var email: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.backbutton)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .shadow(color: Color.white.opacity(0.2), radius: 0.3, x: 1, y: -1)
            TextField("", text: $viewModel.userProfile.email)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .font(.system(size: 24, weight: .thin))
                .padding(.leading, 26)
                .foregroundStyle(.currentday)
        }
    }
    
    private var nextButton: some View {
        Button(action: {
            Task{
                await viewModel.saveProfile()
                print(viewModel.userProfile.email)
                selection += 1
            }
        }) {
            CustomNextButton()
        }
        .offset(x: 130, y: 250)
    }
    
    private var quote: some View {
        VStack(alignment: .trailing){
            Spacer()
            Text(". . .  The journey is made")
                .lineLimit(2)
                .font(.system(size: 24, weight: .thin, design: .rounded))
                .foregroundColor(.orange.opacity(0.8))
            Text("by those who take it.")
                .italic()
                .font(.system(size: 20, weight: .thin))
                .foregroundColor(.orange.opacity(0.7))
        }
        .multilineTextAlignment(.trailing)
    }
}

//#Preview {
//    PersonalInfoView(viewModel: OnboardingViewModel(repository: MockUserProfileRepository()), sele)
//}

