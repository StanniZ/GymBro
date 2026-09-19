import SwiftUI

// MARK: - Int Field Row
// Drop-in replacement for fieldRow { HStack { Text; Stepper } }

struct IntFieldRow: View {
    let label: String
    let unit: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    var step: Int = 1

    @State private var draft = ""
    @FocusState private var focused: Bool

    var body: some View {
        HStack(spacing: 0) {
            Text(label)
                .font(AppFont.subheadline)
                .foregroundColor(.white)
                .lineLimit(1)
            Spacer(minLength: 12)
            HStack(spacing: 6) {
                TextField("", text: $draft)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.currentday)
                    .font(.system(size: 15, weight: .medium, design: .monospaced))
                    .frame(width: 52)
                    .focused($focused)
                    .onSubmit { commit() }
                if !unit.isEmpty {
                    Text(unit)
                        .font(AppFont.caption)
                        .foregroundColor(.white.opacity(0.4))
                        .fixedSize()
                }
                stepButtons(onMinus: { decrement() }, onPlus: { increment() })
            }
        }
        .padding(.vertical, 14)
        .onAppear { draft = "\(value)" }
        .onChange(of: value) { _, _ in if !focused { draft = "\(value)" } }
        .onChange(of: focused) { _, isFocused in if !isFocused { commit() } }
    }

    private func commit() {
        let v = Int(draft.filter { $0.isNumber }) ?? value
        value = min(max(v, range.lowerBound), range.upperBound)
        draft = "\(value)"
    }

    private func increment() { value = min(value + step, range.upperBound) }
    private func decrement() { value = max(value - step, range.lowerBound) }
}

// MARK: - Double Field Row

struct DoubleFieldRow: View {
    let label: String
    let unit: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    var step: Double = 1.0
    var fractionDigits: Int = 1

    @State private var draft = ""
    @FocusState private var focused: Bool

    var body: some View {
        HStack(spacing: 0) {
            Text(label)
                .font(AppFont.subheadline)
                .foregroundColor(.white)
                .lineLimit(1)
            Spacer(minLength: 12)
            HStack(spacing: 6) {
                TextField("", text: $draft)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.currentday)
                    .font(.system(size: 15, weight: .medium, design: .monospaced))
                    .frame(width: 58)
                    .focused($focused)
                    .onSubmit { commit() }
                if !unit.isEmpty {
                    Text(unit)
                        .font(AppFont.caption)
                        .foregroundColor(.white.opacity(0.4))
                        .fixedSize()
                }
                stepButtons(onMinus: { decrement() }, onPlus: { increment() })
            }
        }
        .padding(.vertical, 14)
        .onAppear { draft = format(value) }
        .onChange(of: value) { _, _ in if !focused { draft = format(value) } }
        .onChange(of: focused) { _, isFocused in if !isFocused { commit() } }
    }

    private func commit() {
        let clean = draft.replacingOccurrences(of: ",", with: ".")
        let v = Double(clean) ?? value
        value = min(max(v, range.lowerBound), range.upperBound)
        draft = format(value)
    }

    private func increment() { value = min((value + step).rounded(toPlaces: fractionDigits), range.upperBound) }
    private func decrement() { value = max((value - step).rounded(toPlaces: fractionDigits), range.lowerBound) }

    private func format(_ v: Double) -> String {
        String(format: "%.\(fractionDigits)f", v)
    }
}

// MARK: - Shared step button control

func stepButtons(onMinus: @escaping () -> Void, onPlus: @escaping () -> Void) -> some View {
    HStack(spacing: 0) {
        Button(action: onMinus) {
            Image(systemName: "minus")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white.opacity(0.6))
                .frame(width: 28, height: 30)
        }
        Rectangle()
            .fill(Color.white.opacity(0.08))
            .frame(width: 1, height: 16)
        Button(action: onPlus) {
            Image(systemName: "plus")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white.opacity(0.6))
                .frame(width: 28, height: 30)
        }
    }
    .background(Color.white.opacity(0.06))
    .cornerRadius(8)
}

// MARK: - Double rounding helper

private extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
