# AWSome Shop iOS App

## 项目概述

AWSome Shop 是一款员工福利积分兑换 iOS 应用，采用 SwiftUI + MVVM 架构，遵循 MUI (Material Design) 风格设计规范。

## 技术栈

| 类别 | 技术选型 |
|------|---------|
| UI 框架 | SwiftUI |
| 架构模式 | MVVM + Repository Pattern |
| 依赖注入 | Swift Package (Factory) |
| 网络层 | URLSession + Async/Await |
| JSON 解析 | Codable |
| 本地存储 | SwiftData / UserDefaults |
| 图片加载 | AsyncImage / Kingfisher |
| 导航 | NavigationStack (iOS 16+) |
| 最低支持版本 | iOS 16.0 |

## 项目结构

```
AwsomeShop/
├── App/
│   ├── AwsomeShopApp.swift              # App 入口
│   └── ContentView.swift                 # 根视图
├── Core/
│   ├── DI/
│   │   └── Container.swift               # 依赖注入容器
│   ├── Network/
│   │   ├── APIClient.swift               # 网络请求客户端
│   │   ├── APIEndpoint.swift             # API 端点定义
│   │   ├── APIError.swift                # 错误类型
│   │   └── AuthInterceptor.swift         # Token 拦截器
│   └── Extensions/
│       ├── View+Extensions.swift
│       └── Color+Extensions.swift
├── Data/
│   ├── Models/
│   │   ├── User.swift
│   │   ├── Product.swift
│   │   ├── Category.swift
│   │   ├── Order.swift
│   │   ├── PointsBalance.swift
│   │   ├── PointsTransaction.swift
│   │   └── Address.swift
│   ├── DTOs/
│   │   ├── LoginRequest.swift
│   │   ├── LoginResponse.swift
│   │   ├── CreateOrderRequest.swift
│   │   └── PageResponse.swift
│   └── Repositories/
│       ├── AuthRepository.swift
│       ├── ProductRepository.swift
│       ├── OrderRepository.swift
│       ├── PointsRepository.swift
│       └── AddressRepository.swift
├── Features/
│   ├── Auth/
│   │   ├── LoginView.swift
│   │   └── LoginViewModel.swift
│   ├── Home/
│   │   ├── HomeView.swift
│   │   ├── HomeViewModel.swift
│   │   └── Components/
│   │       ├── PointsBanner.swift
│   │       ├── CategoryFilter.swift
│   │       └── ProductCard.swift
│   ├── ProductDetail/
│   │   ├── ProductDetailView.swift
│   │   └── ProductDetailViewModel.swift
│   ├── Redemption/
│   │   ├── ConfirmRedemptionView.swift
│   │   ├── ConfirmRedemptionViewModel.swift
│   │   ├── DeliveryInfoView.swift
│   │   ├── DeliveryInfoViewModel.swift
│   │   └── RedemptionSuccessView.swift
│   ├── Orders/
│   │   ├── OrdersView.swift
│   │   ├── OrdersViewModel.swift
│   │   ├── OrderDetailView.swift
│   │   └── OrderDetailViewModel.swift
│   ├── Points/
│   │   ├── PointsCenterView.swift
│   │   ├── PointsCenterViewModel.swift
│   │   ├── PointsHistoryView.swift
│   │   └── PointsHistoryViewModel.swift
│   └── Profile/
│       ├── ProfileView.swift
│       └── ProfileViewModel.swift
├── Navigation/
│   ├── AppRouter.swift
│   ├── Route.swift
│   └── TabRouter.swift
├── DesignSystem/
│   ├── Theme/
│   │   ├── AppColors.swift
│   │   ├── AppTypography.swift
│   │   └── AppSpacing.swift
│   └── Components/
│       ├── ASButton.swift
│       ├── ASTextField.swift
│       ├── ASCard.swift
│       ├── ASChip.swift
│       ├── ASStatusBadge.swift
│       ├── ASBottomTabBar.swift
│       └── ASNavBar.swift
└── Resources/
    ├── Assets.xcassets/
    └── Localizable.strings
```

## 设计规范 (MUI 风格)

### 颜色系统

```swift
// AppColors.swift
extension Color {
    // Primary
    static let primary = Color(hex: "#2563EB")
    static let primaryDark = Color(hex: "#1D4ED8")
    static let primaryLight = Color(hex: "#60A5FA")
    static let primaryBg = Color(hex: "#EFF6FF")
    
    // Accent (Points/Gold)
    static let accent = Color(hex: "#D97706")
    static let accentBg = Color(hex: "#FFFBEB")
    static let accentLight = Color(hex: "#FCD34D")
    
    // Semantic
    static let success = Color(hex: "#16A34A")
    static let warning = Color(hex: "#D97706")
    static let error = Color(hex: "#DC2626")
    static let info = Color(hex: "#2563EB")
    
    // Text
    static let textPrimary = Color(hex: "#1E293B")
    static let textSecondary = Color(hex: "#64748B")
    static let textDisabled = Color(hex: "#CBD5E1")
    static let textWhite = Color.white
    
    // Background
    static let bgPage = Color(hex: "#F8FAFC")
    static let bgWhite = Color.white
    
    // Border
    static let border = Color(hex: "#E2E8F0")
    static let borderLight = Color(hex: "#F1F5F9")
    static let divider = Color(hex: "#F1F5F9")
    
    // Chips
    static let chipBlueBg = Color(hex: "#DBEAFE")
    static let chipBlueText = Color(hex: "#1E40AF")
    static let chipGreenBg = Color(hex: "#DCFCE7")
    static let chipGreenText = Color(hex: "#166534")
    static let chipOrangeBg = Color(hex: "#FEF3C7")
    static let chipOrangeText = Color(hex: "#92400E")
    static let chipRedBg = Color(hex: "#FEE2E2")
    static let chipRedText = Color(hex: "#991B1B")
}
```

### 圆角规范

```swift
// AppSpacing.swift
enum CornerRadius {
    static let sm: CGFloat = 4
    static let md: CGFloat = 8
    static let lg: CGFloat = 12
    static let xl: CGFloat = 16
    static let full: CGFloat = 9999  // Capsule
}
```

### 字体规范

```swift
// AppTypography.swift
extension Font {
    static let headline1 = Font.system(size: 28, weight: .bold)
    static let headline2 = Font.system(size: 22, weight: .bold)
    static let headline3 = Font.system(size: 18, weight: .semibold)
    static let body1 = Font.system(size: 16, weight: .regular)
    static let body2 = Font.system(size: 14, weight: .regular)
    static let caption = Font.system(size: 12, weight: .regular)
    static let button = Font.system(size: 16, weight: .semibold)
    static let chip = Font.system(size: 13, weight: .medium)
}
```

## 页面规范

### 1. 登录页 (LoginView)

**设计要点**:
- 上半部分: 渐变背景 (primary → primaryLight)，品牌 Logo + 标题
- 下半部分: 白色圆角卡片，包含表单
- Material Symbols Rounded 图标: `redeem`

```swift
// 渐变方向: 垂直从上到下
LinearGradient(
    colors: [.primary, .primaryDark],
    startPoint: .top,
    endPoint: .bottom
)
```

### 2. 首页 (HomeView)

**结构**:
1. **导航栏**: Logo + 搜索 + 通知 + 头像
2. **积分横幅**: 渐变背景，显示"我的积分"和余额
3. **分类筛选**: 横向滚动 Chip 列表
4. **商品网格**: 2列 LazyVGrid

**分类 Chips**: 全部、数码电子、生活日用、美食餐饮、礼品卡券、办公文具

### 3. 商品详情页 (ProductDetailView)

**结构**:
1. 商品图片区 (支持缩略图切换)
2. 面包屑导航
3. 商品标题 + 副标题
4. 积分价格卡片 (渐变背景: #FFFBEB → #FDE68A)
5. 配送/服务信息
6. 立即兑换 + 收藏按钮
7. 商品描述
8. 推荐商品

### 4. 确认兑换页 (ConfirmRedemptionView)

**结构**:
1. 页面标题 + 返回
2. 商品信息卡片
3. 积分扣减信息
4. 余额显示条 (蓝色背景)
5. 收货地址卡片 (可编辑)
6. 确认/取消按钮
7. 注意事项

### 5. 收货地址页 (DeliveryInfoView)

**结构**:
1. 已保存地址列表 (单选)
2. 新增地址表单
3. 确认按钮

### 6. 兑换成功页 (RedemptionSuccessView)

**结构**:
1. 成功图标 (绿色圆形背景 + check 图标)
2. 标题 + 副标题
3. 订单信息卡片
4. 查看订单 / 继续逛逛 按钮

### 7. 订单详情页 (OrderDetailView)

**结构**:
1. 订单状态卡片 (时间线)
2. 商品信息
3. 积分信息
4. 收货信息
5. 订单信息 (订单号、时间等)
6. 操作按钮

## API 端点

基于后端 OpenAPI 规范:

```swift
enum APIEndpoint {
    // Auth
    case login
    case profile
    
    // Product
    case productList
    case productDetail(id: Int64)
    case categories
    
    // Points
    case pointsBalance
    case pointsTransactions
    
    // Order
    case createOrder
    case orderList
    case orderDetail(id: Int64)
    
    // Address
    case addressList
    case createAddress
    case updateAddress(id: Int64)
    case deleteAddress(id: Int64)
    case setDefaultAddress(id: Int64)
}
```

## 数据模型

### Product

```swift
struct Product: Codable, Identifiable {
    let id: Int64
    let name: String
    let sku: String
    let category: String
    let brand: String?
    let pointsPrice: Int
    let marketPrice: Double?
    let stock: Int
    let soldCount: Int
    let status: Int
    let description: String?
    let imageUrl: String?
    let subtitle: String?
    let deliveryMethod: String?
    let serviceGuarantee: String?
    let promotion: String?
    let colors: String?
    let specs: [[String: String]]?
    let createdAt: Date?
    let updatedAt: Date?
}
```

### Order

```swift
struct Order: Codable, Identifiable {
    let id: Int64
    let userId: Int64
    let productId: Int64
    let productName: String
    let productImageUrl: String?
    let points: Int
    let status: OrderStatus
    let addressSnapshot: AddressSnapshot
    let trackingNumber: String?
    let createdAt: Date
    let shippedAt: Date?
    let completedAt: Date?
}

enum OrderStatus: String, Codable {
    case pending = "PENDING"
    case shipped = "SHIPPED"
    case completed = "COMPLETED"
    case cancelled = "CANCELLED"
}
```

### PointsBalance

```swift
struct PointsBalance: Codable {
    let userId: Int64
    let balance: Int
    let totalEarned: Int
    let totalUsed: Int
    let redemptionCount: Int
}
```

### PointsTransaction

```swift
struct PointsTransaction: Codable, Identifiable {
    let id: Int64
    let type: TransactionType
    let amount: Int
    let balanceAfter: Int
    let description: String
    let operatorId: Int64?
    let relatedOrderId: Int64?
    let createdAt: Date
}

enum TransactionType: String, Codable {
    case redemption = "REDEMPTION"
    case performance = "PERFORMANCE"
    case seniority = "SENIORITY"
    case holiday = "HOLIDAY"
    case special = "SPECIAL"
    case adminAdd = "ADMIN_ADD"
    case adminDeduct = "ADMIN_DEDUCT"
    case refund = "REFUND"
}
```

## 导航路由

```swift
enum Route: Hashable {
    case login
    case main
    case home
    case orders
    case pointsCenter
    case profile
    case productDetail(productId: Int64)
    case confirmRedemption(productId: Int64)
    case deliveryInfo
    case redemptionSuccess(orderId: Int64)
    case orderDetail(orderId: Int64)
    case pointsHistory
}
```

## 底部导航栏

```swift
enum TabItem: Int, CaseIterable {
    case home = 0
    case points = 1
    case orders = 2
    case profile = 3
    
    var title: String {
        switch self {
        case .home: return "首页"
        case .points: return "积分"
        case .orders: return "订单"
        case .profile: return "我的"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .points: return "star.fill"
        case .orders: return "list.bullet.rectangle.fill"
        case .profile: return "person.fill"
        }
    }
}
```

## 开发规范

### ViewModel 模板

```swift
@MainActor
final class ExampleViewModel: ObservableObject {
    @Published private(set) var state: ViewState = .idle
    @Published private(set) var data: [Item] = []
    
    private let repository: ExampleRepository
    
    init(repository: ExampleRepository) {
        self.repository = repository
    }
    
    func loadData() async {
        state = .loading
        do {
            data = try await repository.fetchItems()
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

enum ViewState: Equatable {
    case idle
    case loading
    case loaded
    case error(String)
}
```

### 环境变量

```swift
// Config.swift
enum Config {
    static let baseURL = "https://d2hd67t17ecfrp.cloudfront.net/api/v1"
    static let timeout: TimeInterval = 30
}
```

## 构建与运行

```bash
# 打开项目
open AwsomeShop.xcodeproj

# 或使用 xcodebuild
xcodebuild -scheme AwsomeShop -destination 'platform=iOS Simulator,name=iPhone 15'
```

## 设计稿参考

设计稿位于 `../doc/awsome-shop.pen`，使用 Pencil 工具打开查看。

主要页面:
- Employee - Login
- Employee - Shop Home
- Employee - Product Detail
- Employee - Confirm Redemption
- Employee - Delivery Info
- Employee - Redemption Success
- Employee - Order Detail
