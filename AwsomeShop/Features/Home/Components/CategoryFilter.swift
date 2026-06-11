import SwiftUI

struct CategoryFilter: View {
    let categories: [Category]
    @Binding var selectedCategory: String?
    let onSelect: (String?) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                ASChip(
                    title: "全部",
                    isSelected: selectedCategory == nil
                ) {
                    selectedCategory = nil
                    onSelect(nil)
                }

                ForEach(categories) { category in
                    ASChip(
                        title: category.name,
                        isSelected: selectedCategory == category.name
                    ) {
                        selectedCategory = category.name
                        onSelect(category.name)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.lg)
        }
    }
}

#Preview {
    CategoryFilter(
        categories: [
            Category(id: 1, name: "数码电子", description: nil, icon: nil, sortOrder: nil, status: nil),
            Category(id: 2, name: "生活日用", description: nil, icon: nil, sortOrder: nil, status: nil),
            Category(id: 3, name: "美食餐饮", description: nil, icon: nil, sortOrder: nil, status: nil),
        ],
        selectedCategory: .constant(nil),
        onSelect: { _ in }
    )
}
