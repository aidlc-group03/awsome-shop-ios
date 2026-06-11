# Project Structure

## Directory Layout

```
AwsomeShop/
├── AwsomeShop.xcodeproj
├── AwsomeShop/
│   ├── App/
│   │   ├── AwsomeShopApp.swift
│   │   └── ContentView.swift
│   ├── Core/
│   │   ├── DI/
│   │   ├── Network/
│   │   └── Extensions/
│   ├── Data/
│   │   ├── Models/
│   │   ├── DTOs/
│   │   └── Repositories/
│   ├── Features/
│   │   ├── Auth/
│   │   ├── Home/
│   │   ├── ProductDetail/
│   │   ├── Redemption/
│   │   ├── Orders/
│   │   ├── Points/
│   │   └── Profile/
│   ├── Navigation/
│   ├── DesignSystem/
│   │   ├── Theme/
│   │   └── Components/
│   └── Resources/
│       ├── Assets.xcassets/
│       └── Localizable.strings
└── AwsomeShopTests/
```

## Layer Responsibilities

### App Layer
- 应用入口点
- Scene 配置
- 环境对象注入

### Core Layer
- 网络请求基础设施
- 依赖注入容器
- 通用扩展方法

### Data Layer
- 数据模型定义
- DTO 转换
- Repository 实现

### Features Layer
- 按功能模块组织
- 每个模块包含 View + ViewModel
- 模块内部组件

### Navigation Layer
- 路由定义
- 导航状态管理
- Tab 路由

### DesignSystem Layer
- 颜色/字体/间距常量
- 可复用 UI 组件
- 主题配置

## File Naming Conventions

| 类型 | 命名规范 | 示例 |
|------|---------|------|
| View | `*View.swift` | `LoginView.swift` |
| ViewModel | `*ViewModel.swift` | `LoginViewModel.swift` |
| Model | `*.swift` | `Product.swift` |
| DTO | `*Request.swift` / `*Response.swift` | `LoginRequest.swift` |
| Repository | `*Repository.swift` | `AuthRepository.swift` |
| Component | `AS*.swift` | `ASButton.swift` |

## Module Dependencies

```
App → Features → Data → Core
         ↓
    DesignSystem
         ↓
    Navigation
```

- Features 依赖 Data, DesignSystem, Navigation
- Data 依赖 Core
- DesignSystem 无依赖
- Navigation 依赖 Features (弱引用)
