# AWSome Shop iOS

员工福利积分兑换 iOS 应用

## 功能特性

- 员工登录认证
- 商品浏览与搜索
- 分类筛选
- 积分兑换流程
- 订单管理
- 积分余额与历史查询
- 收货地址管理

## 技术栈

- SwiftUI
- MVVM Architecture
- Async/Await
- SwiftData
- iOS 16+

## 快速开始

### 环境要求

- Xcode 15.0+
- iOS 16.0+
- Swift 5.9+

### 运行项目

1. 克隆仓库
2. 打开 `AwsomeShop.xcodeproj`
3. 选择模拟器或真机
4. 运行 (Cmd + R)

### 配置后端地址

修改 `Core/Network/Config.swift`:

```swift
enum Config {
    static let baseURL = "http://your-api-server:8080/api"
}
```

## 项目结构

```
AwsomeShop/
├── App/                 # 应用入口
├── Core/                # 核心模块 (网络、DI、扩展)
├── Data/                # 数据层 (模型、DTO、仓库)
├── Features/            # 功能模块
├── Navigation/          # 导航路由
├── DesignSystem/        # 设计系统组件
└── Resources/           # 资源文件
```

## 设计规范

遵循 MUI (Material Design) 风格，详见 [CLAUDE.md](./CLAUDE.md)

## API 文档

后端 API 文档位于:
- `../aidlc-docs/construction/product-service/functional-design/openapi.yaml`
- `../aidlc-docs/construction/points-service/functional-design/openapi.yaml`
- `../aidlc-docs/construction/order-service/functional-design/openapi.yaml`

## License

Internal Use Only
