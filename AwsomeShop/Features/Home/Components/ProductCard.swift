import SwiftUI

struct ProductCard: View {
    let product: Product
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                productImage

                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text(product.name)
                        .font(AppTypography.body2)
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    Text("\(product.pointsPrice) 积分")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(AppColors.primary)
                }
                .padding(AppSpacing.md)
            }
            .background(AppColors.bgWhite)
            .cornerRadius(CornerRadius.lg)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.lg)
                    .stroke(AppColors.borderLight, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var productImage: some View {
        ZStack {
            AppColors.primaryBg

            if let imageUrl = product.imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        placeholderIcon
                    case .empty:
                        ProgressView()
                    @unknown default:
                        placeholderIcon
                    }
                }
            } else {
                placeholderIcon
            }
        }
        .frame(height: 120)
        .clipped()
    }

    private var placeholderIcon: some View {
        Image(systemName: "bag.fill")
            .font(.system(size: 40))
            .foregroundColor(AppColors.primary.opacity(0.5))
    }
}

#Preview {
    ProductCard(
        product: Product(
            id: 1,
            name: "Sony WH-1000XM5 降噪耳机",
            sku: "SONY-XM5",
            category: "数码电子",
            brand: "Sony",
            pointsPrice: 2580,
            marketPrice: 2999,
            stock: 100,
            soldCount: 50,
            status: 1,
            description: nil,
            imageUrl: nil,
            subtitle: nil,
            deliveryMethod: nil,
            serviceGuarantee: nil,
            promotion: nil,
            colors: nil,
            specs: nil,
            createdAt: nil,
            updatedAt: nil
        )
    ) {}
    .frame(width: 180)
    .padding()
}
