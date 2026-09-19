import SwiftUI

struct FoodTracker: View {
    @EnvironmentObject var profileVM: OnboardingViewModel
    @EnvironmentObject var foodVM: FoodTrackerViewModel
    @Binding var selectedTab: Int

    @State private var showAddMeal = false
    @State private var showRepeatYesterdayWarning = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    header
                    dateControls
                    if foodVM.targets != nil {
                        NutritionProgressCard(vm: foodVM)
                    } else {
                        noProfileCard
                    }
                    quickActions
                    mealsSection
                    addMealButton
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
        .alert("Replace current food log?", isPresented: $showRepeatYesterdayWarning) {
            Button("Cancel", role: .cancel) {}
            Button("Repeat Yesterday", role: .destructive) {
                foodVM.repeatYesterday()
            }
        } message: {
            Text("This will erase the food already logged for \(dateTitle) and replace it with yesterday's meals.")
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

    private var dateControls: some View {
        HStack(spacing: 10) {
            Button {
                foodVM.moveSelectedDate(by: -1)
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 38, height: 38)
                    .background(Color.backbutton)
                    .cornerRadius(12)
            }

            Button {
                foodVM.selectDate(Date())
            } label: {
                VStack(spacing: 2) {
                    Text(dateTitle)
                        .font(AppFont.subheadline)
                        .foregroundColor(.white)
                    Text(isToday ? "Today" : "Tap to return today")
                        .font(AppFont.caption)
                        .foregroundColor(isToday ? .currentday : .weekDay)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 38)
                .background(Color.backbutton)
                .cornerRadius(12)
            }

            Button {
                foodVM.moveSelectedDate(by: 1)
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 38, height: 38)
                    .background(Color.backbutton)
                    .cornerRadius(12)
            }
        }
    }

    private var quickActions: some View {
        HStack(spacing: 10) {
            Button {
                if foodVM.hasLoggedFood {
                    showRepeatYesterdayWarning = true
                } else {
                    foodVM.repeatYesterday()
                }
            } label: {
                quickActionLabel("Repeat yesterday", icon: "arrow.uturn.backward")
            }
            Button {
                showAddMeal = true
            } label: {
                quickActionLabel("New meal", icon: "plus")
            }
        }
    }

    private func quickActionLabel(_ title: String, icon: String) -> some View {
        HStack(spacing: 7) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
            Text(title)
                .font(AppFont.caption)
                .lineLimit(1)
        }
        .foregroundColor(.currentday)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.currentday.opacity(0.1))
        .cornerRadius(12)
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
        return df.string(from: foodVM.selectedDate)
    }

    private var dateTitle: String {
        let df = DateFormatter()
        df.dateFormat = "EEE, d MMM"
        return df.string(from: foodVM.selectedDate)
    }

    private var isToday: Bool {
        Calendar.current.isDateInToday(foodVM.selectedDate)
    }
}
