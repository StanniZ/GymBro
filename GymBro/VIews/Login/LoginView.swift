//
//  RegistrationView.swift
//  GymBro
//
//  Created by macbook on 16/07/2025.
//
import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var authSession: AuthSession
    @State private var emailText: String = ""
    @State private var passwordText: String = ""
    @State private var secureTextEntry: Bool = true
    var onFinish:() -> Void
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 16){
                skip
                header
                middleHeader
                Spacer()
                email
                password
                forgotPassword
                login
                separator
                appleAuthorization
                appleAuthorizationError
                signUp
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(26)
        .background(.backmain)
        .dismissKeyboardOnTap()
    }
    
    private var header: some View {
        Text("GymBro")
            .font(.system(size: 40))
            .fontWeight(.bold)
            .foregroundColor(Color.currentday)
            .shadow(color: Color.weekDay.opacity(0.8), radius: 8)
            .padding(.vertical, 60)
    }
    
    private var middleHeader: some View {
        HStack{
            VStack(alignment: .leading, spacing: 10){
                Text("Welcome")
                    .font(.system(size: 28))
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.white.opacity(0.95))
                Text("Sign in to your account:")
                    .font(.system(size: 16))
                    .fontWeight(.regular)
                    .foregroundStyle(Color.white.opacity(0.7))
            }
            Spacer()
        }
    }
    
    private var email: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.backbutton)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .shadow(color: Color.white.opacity(0.2), radius: 0.3, x: 2, y: -1)
            ZStack(alignment: .leading){
                if emailText.isEmpty {
                    Text("Email Address")
                        .font(.system(size: 16))
                        .foregroundColor(Color.white.opacity(0.55))
                        .padding(.leading, 26)
                        .accessibilityHidden(true)
                }
                TextField("", text: $emailText)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .textContentType(.emailAddress)
                    .foregroundStyle(Color.currentday)
                    .padding(.leading, 26)
                    .accessibilityLabel("Email Address")
            }
        }
    }
    
    private var password: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.backbutton)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .shadow(color: Color.white.opacity(0.2), radius: 0.3, x: 2, y: -1)
            ZStack(alignment: .leading){
                if passwordText.isEmpty {
                    Text("Password")
                        .font(.system(size: 16))
                        .foregroundColor(Color.white.opacity(0.55))
                        .padding(.leading, 26)
                        .accessibilityHidden(true)
                }
                HStack{
                    if secureTextEntry{
                        SecureField("", text: $passwordText)
                    } else {
                        TextField("", text: $passwordText)
                    }
                    Button(action: {
                        secureTextEntry.toggle()
                    }) {
                        Image(systemName: secureTextEntry ? "eye.slash" : "eye")
                            .foregroundColor(Color.currentday)
                            .padding(.trailing, 26)
                    }
                    .accessibilityLabel(secureTextEntry ? "Hide Password" : "Show Password")
                }
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .textContentType(.password)
                .foregroundStyle(Color.currentday)
                .padding(.leading, 26)
                .accessibilityLabel("Password")
            }
        }
    }
    
    private var forgotPassword: some View {
        HStack{
            Spacer()
            Button(action: {
                
            }) {
                Text("Forgot Password")
                    .font(.system(size: 14))
                    .foregroundColor(Color.logincolor)
            }
        }
        .padding(.bottom, 20)
    }
    
    private var login: some View {
        Button(action: {
            
        }) {
            ZStack{
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.logincolor)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .shadow(color: Color.white.opacity(0.8), radius: 0.7, x: 1.5, y: -0.5)
                Text("Login")
                    .foregroundStyle(Color.white.opacity(0.9))
            }
        }
    }
    
    private var separator: some View {
        HStack(spacing: 16){
            HorizontalDottedLine(width: 120)
            Text("Or")
                .font(.system(size: 16))
                .foregroundStyle(Color.white)
            HorizontalDottedLine(width: 120)
        }
        .padding(.vertical, 20)
    }
    
    private var appleAuthorization: some View {
        AppleSignInButtonView(onSuccess: onFinish)
    }

    @ViewBuilder
    private var appleAuthorizationError: some View {
        if case .failed(let errorMessage) = authSession.state {
            Text(errorMessage)
                .font(.system(size: 13))
                .foregroundStyle(.red.opacity(0.9))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 8)
        }
    }
    
    private var signUp: some View {
        HStack(spacing: 6){
            Text("Don't have an account?")
                .foregroundStyle(Color.white.opacity(0.65))
            Button(action: {
            }) {
                Text("Sign Up")
                    .foregroundStyle(Color.logincolor)
            }
        }
        .font(.system(size: 16))
    }
    
    private var skip: some View {
        Button(action: {
            onFinish()
        }) {
            HStack(spacing: 4){
                Spacer()
                Text("Skip")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 16))
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 16))
            }
        }
    }
}
