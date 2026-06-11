import SwiftUI

struct ASChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTypography.chip)
                .foregroundColor(isSelected ? AppColors.textWhite : AppColors.textPrimary)
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background(isSelected ? AppColors.primary : AppColors.bgWhite)
                .cornerRadius(CornerRadius.full)
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.clear : AppColors.border, lineWidth: 1)
                )
        }
    }
}

#Preview {
    HStack {
        ASChip(title: "全部", isSelected: true) {}
        ASChip(title: "数码电子", isSelected: false) {}
        ASChip(title: "生活日用", isSelected: false) {}
    }
    .padding()
}
