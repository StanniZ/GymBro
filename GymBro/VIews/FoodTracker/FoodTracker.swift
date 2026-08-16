import SwiftUI

struct FoodTracker: View {
    @EnvironmentObject var profileVM: OnboardingViewModel
    @EnvironmentObject var foodVM: FoodTrackerViewModel
    @Binding var selectedTab: Int

    @State private var showAddMeal = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    header
                    if foodVM.targets != nil {
                        NutritionProgressCard(vm: foodVM)
                        mealsSection
                        addMealButton
                    } else {
                        noProfileCard
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
            .background(Color.backmain)
            .scrollDismissesKeyboard(.interactively)
        }
        .task {
            try? await profileVM.fetchUserProfile()
            profileVM.loadAvatar()
            foodVM.updateTargets(from: profileVM.userProfile)
        }
        .sheet(isPresented: $showAddMeal) {
            AddMealSectionSheet(vm: foodVM)
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Food Tracker")
                    .font(AppFont.title)
                    .foregroundColor(.white)
                Text(formattedDate)
                    .font(AppFont.caption)
                    .foregroundColor(.white.opacity(0.4))
            }
            Spacer()
            caloriesSummaryBadge
        }
        .padding(.top, 4)
    }

    private var caloriesSummaryBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "flame.fill")
                .font(.system(size: 13))
                .foregroundColor(.firecolor)
            Text("\(foodVM.totalCalories) kcal")
                .font(AppFont.caption)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.backbutton)
        .cornerRadius(20)
    }

    // MARK: - Meals

    private var mealsSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Meals")
                    .font(AppFont.headline)
                    .foregroundColor(.white)
                Spacer()
            }
            ForEach(foodVM.meals) { meal in
                MealSectionCard(meal: meal, vm: foodVM)
            }
        }
    }

    private var addMealButton: some View {
        Button {
            showAddMeal = true
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.currentday)
                Text("Add meal")
                    .font(AppFont.subheadline)
                    .foregroundColor(.currentday)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding(16)
            .background(Color.backbutton)
            .cornerRadius(20)
        }
    }

    // MARK: - No Profile Card

    private var noProfileCard: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.crop.circle.badge.exclamationmark")
                .font(.system(size: 48))
                .foregroundColor(.white.opacity(0.2))

            VStack(spacing: 8) {
                Text("No recommendations available")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
                Text("Fill in your profile to get personalised\ncalorie and macro targets")
                    .font(AppFont.caption)
                    .foregroundColor(.white.opacity(0.35))
                    .multilineTextAlignment(.center)
            }

            Button {
                selectedTab = 3
            } label: {
                Text("Complete Profile")
                    .font(AppFont.subheadline)
                    .foregroundColor(.black)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.currentday)
                    .cornerRadius(16)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .padding(.horizontal, 24)
        .background(Color.backbutton)
        .cornerRadius(20)
    }

    // MARK: - Helpers

    private var formattedDate: String {
        let df = DateFormatter()
        df.dateFormat = "EEEE, d MMMM"
        return df.string(from: Date())
    }
}
