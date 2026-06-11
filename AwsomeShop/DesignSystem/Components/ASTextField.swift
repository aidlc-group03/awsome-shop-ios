import SwiftUI

struct ASTextField: View {
    let placeholder: String
    @Binding var text: String
    var icon: String?
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(AppColors.textSecondary)
                    .frame(width: 20)
            }

            if isSecure {
                SecureField(placeholder, text: $text)
                    .focused($isFocused)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .focused($isFocused)
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .frame(height: 48)
        .background(AppColors.bgWhite)
        .cornerRadius(CornerRadius.md)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.md)
                .stroke(isFocused ? AppColors.primary : AppColors.border, lineWidth: 1)
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        ASTextField(placeholder: "用户名", text: .constant(""), icon: "person")
        ASTextField(placeholder: "密码", text: .constant(""), icon: "lock", isSecure: true)
        ASTextField(placeholder: "手机号", text: .constant(""), icon: "phone", keyboardType: .phonePad)
    }
    .padding()
    .background(AppColors.bgPage)
}
