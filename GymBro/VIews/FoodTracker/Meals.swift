import SwiftUI

// MARK: - Meal Section Card

struct MealSectionCard: View {
    let meal: MealSection
    @ObservedObject var vm: FoodTrackerViewModel
    @State private var isExpanded = true
    @State private var showAddFood = false
    @State private var showRenameMeal = false

    var body: some View {
        VStack(spacing: 0) {
            header
            if isExpanded {
                Divider().background(Color.white.opacity(0.08))
                entriesList
                addFoodRow
            }
        }
        .background(Color.backbutton)
        .cornerRadius(20)
        .sheet(isPresented: $showAddFood) {
            AddFoodEntrySheet(mealID: meal.id, vm: vm)
                .presentationDetents([.fraction(0.82)])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showRenameMeal) {
            RenameMealSectionSheet(meal: meal, vm: vm)
        }
    }

    // MARK: Header

    private var header: some View {
        HStack {
            Image(systemName: "fork.knife")
                .font(.system(size: 14))
                .foregroundColor(.currentday)
                .frame(width: 28, height: 28)
                .background(Color.currentday.opacity(0.12))
                .cornerRadius(8)

            Text(meal.title)
                .font(AppFont.body)
                .foregroundColor(.white)

            Spacer()

            if meal.totalCalories > 0 {
                Text("\(meal.totalCalories) kcal")
                    .font(AppFont.caption)
                    .foregroundColor(.white.opacity(0.5))
            }

            Menu {
                Button("Rename") { showRenameMeal = true }
                Button("Copy from yesterday") { vm.copyMealFromYesterday(to: meal.id) }
                Button("Clear meal", role: .destructive) { vm.clearEntries(from: meal.id) }
                Button("Delete meal", role: .destructive) { vm.deleteMealSection(id: meal.id) }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.45))
                    .frame(width: 28, height: 28)
            }

            Button {
                withAnimation(.easeInOut(duration: 0.2)) { isExpanded.toggle() }
            } label: {
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.4))
                    .frame(width: 28, height: 28)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    // MARK: Entries

    @ViewBuilder
    private var entriesList: some View {
        if meal.entries.isEmpty {
            HStack {
                Text("No food added yet")
                    .font(AppFont.caption)
                    .foregroundColor(.white.opacity(0.3))
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        } else {
            VStack(spacing: 0) {
                ForEach(meal.entries) { entry in
                    FoodEntryRow(entry: entry) {
                        vm.deleteEntry(entryID: entry.id, from: meal.id)
                    }
                    if entry.id != meal.entries.last?.id {
                        Divider().background(Color.white.opacity(0.06)).padding(.horizontal, 16)
                    }
                }
            }
        }
    }

    // MARK: Add food row

    private var addFoodRow: some View {
        Button {
            showAddFood = true
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.currentday)
                Text("Add food")
                    .font(AppFont.subheadline)
                    .foregroundColor(.currentday)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}

// MARK: - Food Entry Row

private struct FoodEntryRow: View {
    let entry: FoodEntry
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.name)
                    .font(AppFont.subheadline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                if entry.protein > 0 || entry.fat > 0 || entry.carbs > 0 {
                    Text(macroSummary)
                        .font(AppFont.caption)
                        .foregroundColor(.white.opacity(0.4))
                }
            }
            Spacer()
            Text("\(entry.calories) kcal")
                .font(AppFont.caption)
                .foregroundColor(.white.opacity(0.6))
            Button(action: onDelete) {
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white.opacity(0.3))
                    .frame(width: 22, height: 22)
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(6)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private var macroSummary: String {
        var parts: [String] = []
        if let amount = entry.amountGrams, amount > 0 {
            parts.append("\(String(format: "%.0f", amount))g")
        }
        if entry.protein > 0 { parts.append("P \(String(format: "%.0f", entry.protein))g") }
        if entry.fat > 0     { parts.append("F \(String(format: "%.0f", entry.fat))g") }
        if entry.carbs > 0   { parts.append("C \(String(format: "%.0f", entry.carbs))g") }
        return parts.joined(separator: "  ·  ")
    }
}

// MARK: - Add Food Entry Sheet

struct AddFoodEntrySheet: View {
    let mealID: UUID
    @ObservedObject var vm: FoodTrackerViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var amountText = ""
    @State private var caloriesText = ""
    @State private var caloriesPer100Text = ""
    @State private var proteinText = ""
    @State private var fatText = ""
    @State private var carbsText = ""
    @State private var proteinPer100Text = ""
    @State private var fatPer100Text = ""
    @State private var carbsPer100Text = ""
    @FocusState private var focusedField: Field?

    private enum Field { case name, amount, calories, caloriesPer100, protein, fat, carbs, proteinPer100, fatPer100, carbsPer100 }

    private var canAdd: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        (Int(caloriesText) ?? 0) > 0
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    inputCard(title: "Food name") {
                        TextField("e.g. Oatmeal", text: $name)
                            .foregroundColor(.white)
                            .focused($focusedField, equals: .name)
                    }

                    if !vm.recentFoods.isEmpty {
                        recentFoodsSection
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Serving")
                            .font(AppFont.caption)
                            .foregroundColor(.white.opacity(0.4))
                            .padding(.horizontal, 4)
                        VStack(spacing: 0) {
                            inputRow(label: "Amount", placeholder: "0", unit: "g", text: $amountText, field: .amount, keyboard: .decimalPad)
                            Divider().background(Color.white.opacity(0.08))
                            inputRow(label: "Calories", placeholder: "0", unit: "kcal", text: $caloriesText, field: .calories, keyboard: .numberPad)
                            Divider().background(Color.white.opacity(0.08))
                            inputRow(label: "Per 100g", placeholder: "0", unit: "kcal", text: $caloriesPer100Text, field: .caloriesPer100, keyboard: .numberPad)
                        }
                        .background(Color.backbutton)
                        .cornerRadius(16)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Macros (optional)")
                            .font(AppFont.caption)
                            .foregroundColor(.white.opacity(0.4))
                            .padding(.horizontal, 4)

                        VStack(spacing: 0) {
                            macroField(label: "Protein (g)", text: $proteinText, field: .protein)
                            Divider().background(Color.white.opacity(0.08))
                            macroField(label: "Fat (g)", text: $fatText, field: .fat)
                            Divider().background(Color.white.opacity(0.08))
                            macroField(label: "Carbs (g)", text: $carbsText, field: .carbs)
                            Divider().background(Color.white.opacity(0.08))
                            macroField(label: "Protein / 100g", text: $proteinPer100Text, field: .proteinPer100)
                            Divider().background(Color.white.opacity(0.08))
                            macroField(label: "Fat / 100g", text: $fatPer100Text, field: .fatPer100)
                            Divider().background(Color.white.opacity(0.08))
                            macroField(label: "Carbs / 100g", text: $carbsPer100Text, field: .carbsPer100)
                        }
                        .background(Color.backbutton)
                        .cornerRadius(16)
                    }

                    Button {
                        addEntry()
                    } label: {
                        Text("Add to meal")
                            .font(AppFont.body)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(canAdd ? Color.currentday : Color.currentday.opacity(0.3))
                            .cornerRadius(16)
                    }
                    .disabled(!canAdd)
                }
                .padding(16)
            }
            .background(Color.backmain)
            .scrollDismissesKeyboard(.interactively)
            .dismissKeyboardOnTap()
            .navigationTitle("Add Food")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.white.opacity(0.6))
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedField = nil
                    }
                    .foregroundColor(.currentday)
                }
            }
            .onAppear { focusedField = .name }
            .onChange(of: amountText) { _, _ in updateCalculatedValues() }
            .onChange(of: caloriesPer100Text) { _, _ in updateCalculatedValues() }
            .onChange(of: proteinPer100Text) { _, _ in updateCalculatedValues() }
            .onChange(of: fatPer100Text) { _, _ in updateCalculatedValues() }
            .onChange(of: carbsPer100Text) { _, _ in updateCalculatedValues() }
        }
    }

    private var recentFoodsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recent foods")
                .font(AppFont.caption)
                .foregroundColor(.white.opacity(0.4))
                .padding(.horizontal, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(vm.recentFoods.prefix(8)) { food in
                        Button {
                            applyRecentFood(food)
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(food.name)
                                    .font(AppFont.caption)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                Text("\(food.calories) kcal")
                                    .font(.system(size: 11))
                                    .foregroundColor(.weekDay)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 9)
                            .background(Color.backbutton)
                            .cornerRadius(12)
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func inputCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppFont.caption)
                .foregroundColor(.white.opacity(0.4))
                .padding(.horizontal, 4)
            content()
                .padding(14)
                .background(Color.backbutton)
                .cornerRadius(16)
        }
    }

    private func macroField(label: String, text: Binding<String>, field: Field) -> some View {
        inputRow(label: label, placeholder: "0", unit: "g", text: text, field: field, keyboard: .decimalPad)
    }

    private func inputRow(
        label: String,
        placeholder: String,
        unit: String,
        text: Binding<String>,
        field: Field,
        keyboard: UIKeyboardType
    ) -> some View {
        HStack {
            Text(label)
                .font(AppFont.subheadline)
                .foregroundColor(.white.opacity(0.6))
            Spacer()
            TextField(placeholder, text: text)
                .keyboardType(keyboard)
                .multilineTextAlignment(.trailing)
                .foregroundColor(.white)
                .focused($focusedField, equals: field)
                .frame(width: 80)
            Text(unit)
                .font(AppFont.caption)
                .foregroundColor(.white.opacity(0.35))
                .frame(width: 34, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func addEntry() {
        let entry = FoodEntry(
            name: name.trimmingCharacters(in: .whitespaces),
            calories: Int(caloriesText) ?? 0,
            amountGrams: parseDouble(amountText),
            protein: Double(proteinText.replacingOccurrences(of: ",", with: ".")) ?? 0,
            fat:     Double(fatText.replacingOccurrences(of: ",", with: ".")) ?? 0,
            carbs:   Double(carbsText.replacingOccurrences(of: ",", with: ".")) ?? 0
        )
        vm.addEntry(entry, to: mealID)
        dismiss()
    }

    private func updateCalculatedValues() {
        guard let amount = parseDouble(amountText), amount > 0 else { return }

        if let caloriesPer100 = parseDouble(caloriesPer100Text), caloriesPer100 > 0 {
            caloriesText = "\(Int((caloriesPer100 * amount / 100).rounded()))"
        }
        if let proteinPer100 = parseDouble(proteinPer100Text), proteinPer100 > 0 {
            proteinText = formatMacro(proteinPer100 * amount / 100)
        }
        if let fatPer100 = parseDouble(fatPer100Text), fatPer100 > 0 {
            fatText = formatMacro(fatPer100 * amount / 100)
        }
        if let carbsPer100 = parseDouble(carbsPer100Text), carbsPer100 > 0 {
            carbsText = formatMacro(carbsPer100 * amount / 100)
        }
    }

    private func applyRecentFood(_ food: FoodEntry) {
        name = food.name
        amountText = food.amountGrams.map(formatMacro) ?? ""
        caloriesText = "\(food.calories)"
        proteinText = food.protein > 0 ? formatMacro(food.protein) : ""
        fatText = food.fat > 0 ? formatMacro(food.fat) : ""
        carbsText = food.carbs > 0 ? formatMacro(food.carbs) : ""
        focusedField = nil
    }

    private func parseDouble(_ value: String) -> Double? {
        Double(value.replacingOccurrences(of: ",", with: "."))
    }

    private func formatMacro(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", value)
        }
        return String(format: "%.1f", value)
    }
}

// MARK: - Add Meal Section Sheet

struct AddMealSectionSheet: View {
    @ObservedObject var vm: FoodTrackerViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @FocusState private var focused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Meal name")
                        .font(AppFont.caption)
                        .foregroundColor(.white.opacity(0.4))
                        .padding(.horizontal, 4)
                    TextField("e.g. Pre-workout", text: $title)
                        .foregroundColor(.white)
                        .focused($focused)
                        .padding(14)
                        .background(Color.backbutton)
                        .cornerRadius(16)
                }
                Button {
                    vm.addMealSection(title: title)
                    dismiss()
                } label: {
                    Text("Add meal")
                        .font(AppFont.body)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(title.trimmingCharacters(in: .whitespaces).isEmpty
                            ? Color.currentday.opacity(0.3) : Color.currentday)
                        .cornerRadius(16)
                }
                .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                Spacer()
            }
            .padding(16)
            .background(Color.backmain)
            .dismissKeyboardOnTap()
            .navigationTitle("New Meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .onAppear { focused = true }
        }
        .presentationDetents([.fraction(0.35)])
        .presentationDragIndicator(.visible)
    }
}

private struct RenameMealSectionSheet: View {
    let meal: MealSection
    @ObservedObject var vm: FoodTrackerViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @FocusState private var focused: Bool

    init(meal: MealSection, vm: FoodTrackerViewModel) {
        self.meal = meal
        self.vm = vm
        _title = State(initialValue: meal.title)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TextField("Meal name", text: $title)
                    .foregroundColor(.white)
                    .focused($focused)
                    .padding(14)
                    .background(Color.backbutton)
                    .cornerRadius(16)

                Button {
                    vm.renameMealSection(id: meal.id, title: title)
                    dismiss()
                } label: {
                    Text("Save")
                        .font(AppFont.body)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.currentday.opacity(0.3) : Color.currentday)
                        .cornerRadius(16)
                }
                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                Spacer()
            }
            .padding(16)
            .background(Color.backmain)
            .dismissKeyboardOnTap()
            .navigationTitle("Rename Meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.white.opacity(0.6))
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { focused = false }
                        .foregroundColor(.currentday)
                }
            }
            .onAppear { focused = true }
        }
        .presentationDetents([.fraction(0.35)])
        .presentationDragIndicator(.visible)
    }
}
