# Tech Stack

## Platform
- **OS**: iOS 16.0+
- **IDE**: Xcode 15.0+
- **Language**: Swift 5.9+

## UI Framework
- **SwiftUI**: 声明式 UI 框架
- **SF Symbols**: 系统图标库

## Architecture
- **MVVM**: Model-View-ViewModel
- **Repository Pattern**: 数据访问抽象
- **Dependency Injection**: 使用 Factory 或手动注入

## Networking
- **URLSession**: 原生网络请求
- **Async/Await**: 异步编程模型
- **Codable**: JSON 序列化/反序列化

## Data Persistence
- **SwiftData**: 本地数据库 (iOS 17+ 可选)
- **UserDefaults**: 简单键值存储
- **Keychain**: 安全存储 (Token)

## Image Loading
- **AsyncImage**: SwiftUI 原生异步图片加载
- **Kingfisher** (可选): 第三方图片缓存库

## Navigation
- **NavigationStack**: iOS 16+ 导航
- **Coordinator Pattern**: 路由管理

## Dependencies (SPM)

```swift
// Package.swift 或 Xcode SPM
dependencies: [
    // 可选依赖
    .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.0.0"),
    .package(url: "https://github.com/hmlongco/Factory.git", from: "2.0.0"),
]
```

## Build Configuration

| 环境 | Base URL |
|------|----------|
| Debug | http://localhost:8080/api |
| Release | https://api.awsome-shop.com/api |

## Code Style
- SwiftLint 规范
- Swift API Design Guidelines
- 中文注释
