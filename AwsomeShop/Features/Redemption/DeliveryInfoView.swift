import SwiftUI

struct DeliveryInfoView: View {
    let productId: Int64
    @StateObject private var viewModel = DeliveryInfoViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            navigationBar

            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    if !viewModel.addresses.isEmpty {
                        savedAddressesSection
                    }

                    newAddressForm

                    buttonRow
                }
                .padding(AppSpacing.lg)
            }
        }
        .background(AppColors.bgPage)
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.loadAddresses()
        }
    }

    private var navigationBar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(AppColors.textPrimary)
            }

            Spacer()

            Text("收货地址")
                .font(AppTypography.headline3)
                .foregroundColor(AppColors.textPrimary)

            Spacer()

            Color.clear.frame(width: 24)
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
        .background(AppColors.bgWhite)
    }

    private var savedAddressesSection: some View {
        ASCard {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                Text("已保存地址")
                    .font(AppTypography.headline3)
                    .foregroundColor(AppColors.textPrimary)

                ForEach(viewModel.addresses) { address in
                    AddressRow(
                        address: address,
                        isSelected: viewModel.selectedAddressId == address.id
                    ) {
                        viewModel.selectedAddressId = address.id
                    }

                    if address.id != viewModel.addresses.last?.id {
                        Divider()
                    }
                }
            }
        }
    }

    private var newAddressForm: some View {
        ASCard {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                Text("新增地址")
                    .font(AppTypography.headline3)
                    .foregroundColor(AppColors.textPrimary)

                ASTextField(
                    placeholder: "收货人姓名",
                    text: $viewModel.newName,
                    icon: "person"
                )

                ASTextField(
                    placeholder: "手机号码",
                    text: $viewModel.newPhone,
                    icon: "phone",
                    keyboardType: .phonePad
                )

                ASTextField(
                    placeholder: "所在地区 (如: 北京市朝阳区)",
                    text: $viewModel.newRegion,
                    icon: "location"
                )

                ASTextField(
                    placeholder: "详细地址",
                    text: $viewModel.newDetail,
                    icon: "house"
                )

                HStack {
                    Toggle("", isOn: $viewModel.newIsDefault)
                        .labelsHidden()
                    Text("设为默认地址")
                        .font(AppTypography.body2)
                        .foregroundColor(AppColors.textPrimary)
                }
            }
        }
    }

    private var buttonRow: some View {
        HStack(spacing: AppSpacing.md) {
            if viewModel.isFormValid {
                ASButton(
                    "保存并使用",
                    isLoading: viewModel.isSubmitting
                ) {
                    Task {
                        if await viewModel.saveNewAddress() {
                            dismiss()
                        }
                    }
                }
            } else if viewModel.selectedAddressId != nil {
                ASButton("使用此地址") {
                    dismiss()
                }
            }
        }
    }
}

struct AddressRow: View {
    let address: Address
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(alignment: .top, spacing: AppSpacing.md) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? AppColors.primary : AppColors.textSecondary)

                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    HStack {
                        Text(address.name)
                            .font(AppTypography.body1)
                            .foregroundColor(AppColors.textPrimary)
                        Text(address.phone)
                            .font(AppTypography.body2)
                            .foregroundColor(AppColors.textSecondary)

                        if address.isDefault {
                            ASStatusBadge(title: "默认", type: .info)
                        }
                    }

                    Text(address.fullAddress)
                        .font(AppTypography.body2)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.leading)
                }

                Spacer()
            }
            .padding(.vertical, AppSpacing.sm)
        }
    }
}

@MainActor
final class DeliveryInfoViewModel: ObservableObject {
    @Published var addresses: [Address] = []
    @Published var selectedAddressId: Int64?
    @Published var isLoading = false
    @Published var isSubmitting = false

    @Published var newName = ""
    @Published var newPhone = ""
    @Published var newRegion = ""
    @Published var newDetail = ""
    @Published var newIsDefault = false

    private let addressRepository: AddressRepositoryProtocol

    var isFormValid: Bool {
        !newName.isEmpty && !newPhone.isEmpty && !newRegion.isEmpty && !newDetail.isEmpty
    }

    init(addressRepository: AddressRepositoryProtocol = AddressRepository()) {
        self.addressRepository = addressRepository
    }

    func loadAddresses() async {
        isLoading = true

        do {
            addresses = try await addressRepository.getAddresses()
            if let defaultAddress = addresses.first(where: { $0.isDefault }) {
                selectedAddressId = defaultAddress.id
            } else if let first = addresses.first {
                selectedAddressId = first.id
            }
        } catch {
            print("Failed to load addresses: \(error)")
        }

        isLoading = false
    }

    func saveNewAddress() async -> Bool {
        isSubmitting = true

        do {
            let request = CreateAddressRequest(
                name: newName,
                phone: newPhone,
                region: newRegion,
                detail: newDetail,
                isDefault: newIsDefault
            )
            let newAddress = try await addressRepository.createAddress(request)
            addresses.append(newAddress)
            selectedAddressId = newAddress.id
            isSubmitting = false
            return true
        } catch {
            print("Failed to save address: \(error)")
            isSubmitting = false
            return false
        }
    }
}

#Preview {
    NavigationStack {
        DeliveryInfoView(productId: 1)
    }
}
