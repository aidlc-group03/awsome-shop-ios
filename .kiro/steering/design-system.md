# Design System - MUI Style

## Color Palette

### Primary Colors
| Name | Hex | Usage |
|------|-----|-------|
| primary | #2563EB | 主色调、按钮、链接 |
| primaryDark | #1D4ED8 | 按压状态 |
| primaryLight | #60A5FA | 渐变辅助 |
| primaryBg | #EFF6FF | 浅色背景 |

### Accent Colors (积分/金色)
| Name | Hex | Usage |
|------|-----|-------|
| accent | #D97706 | 积分强调 |
| accentBg | #FFFBEB | 积分背景 |
| accentLight | #FCD34D | 积分渐变 |

### Semantic Colors
| Name | Hex | Usage |
|------|-----|-------|
| success | #16A34A | 成功状态 |
| warning | #D97706 | 警告状态 |
| error | #DC2626 | 错误状态 |
| info | #2563EB | 信息提示 |

### Text Colors
| Name | Hex | Usage |
|------|-----|-------|
| textPrimary | #1E293B | 主要文本 |
| textSecondary | #64748B | 次要文本 |
| textDisabled | #CBD5E1 | 禁用文本 |
| textWhite | #FFFFFF | 白色文本 |

### Background Colors
| Name | Hex | Usage |
|------|-----|-------|
| bgPage | #F8FAFC | 页面背景 |
| bgWhite | #FFFFFF | 卡片背景 |

### Border Colors
| Name | Hex | Usage |
|------|-----|-------|
| border | #E2E8F0 | 边框 |
| borderLight | #F1F5F9 | 浅色边框 |
| divider | #F1F5F9 | 分隔线 |

### Chip Colors
| Type | Background | Text |
|------|------------|------|
| Blue | #DBEAFE | #1E40AF |
| Green | #DCFCE7 | #166534 |
| Orange | #FEF3C7 | #92400E |
| Red | #FEE2E2 | #991B1B |

## Corner Radius

| Token | Value | Usage |
|-------|-------|-------|
| sm | 4pt | 小型元素 |
| md | 8pt | 按钮、输入框 |
| lg | 12pt | 卡片 |
| xl | 16pt | 大型卡片 |
| full | capsule | 圆形/胶囊 |

## Typography

### Font Family
- Primary: SF Pro (系统字体)
- Fallback: -apple-system

### Font Sizes
| Style | Size | Weight | Usage |
|-------|------|--------|-------|
| headline1 | 28pt | Bold | 页面大标题 |
| headline2 | 22pt | Bold | 卡片标题 |
| headline3 | 18pt | SemiBold | 区块标题 |
| body1 | 16pt | Regular | 正文 |
| body2 | 14pt | Regular | 次要正文 |
| caption | 12pt | Regular | 辅助说明 |
| button | 16pt | SemiBold | 按钮文字 |
| chip | 13pt | Medium | 标签文字 |

## Spacing

| Token | Value |
|-------|-------|
| xs | 4pt |
| sm | 8pt |
| md | 12pt |
| lg | 16pt |
| xl | 20pt |
| 2xl | 24pt |
| 3xl | 32pt |

## Components

### ASButton
- Height: 48pt (large), 40pt (medium), 32pt (small)
- Corner Radius: md (8pt)
- Variants: primary, secondary, outline, text

### ASTextField
- Height: 48pt
- Corner Radius: md (8pt)
- Border: 1pt solid border
- Focus Border: primary

### ASCard
- Corner Radius: lg (12pt)
- Background: bgWhite
- Border: 1pt solid borderLight
- Shadow: none (flat design)

### ASChip
- Height: 32pt
- Corner Radius: full (capsule)
- Padding: 8pt horizontal, 6pt vertical
- Variants: filled, outlined

### ASStatusBadge
- Corner Radius: sm (4pt)
- Padding: 4pt horizontal, 2pt vertical
- Font: caption

### ASBottomTabBar
- Height: 83pt (含安全区)
- Background: bgWhite
- Border Top: 1pt solid borderLight
- Icon Size: 24pt
- Label Size: 10pt

## Gradients

### Primary Gradient (Hero Banner)
```swift
LinearGradient(
    colors: [Color(hex: "#2563EB"), Color(hex: "#60A5FA")],
    startPoint: .leading,
    endPoint: .trailing
)
```

### Points Price Gradient
```swift
LinearGradient(
    colors: [Color(hex: "#FFFBEB"), Color(hex: "#FDE68A")],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
```

## Icons

使用 SF Symbols，以下为常用图标映射:

| 功能 | SF Symbol |
|------|-----------|
| 首页 | house.fill |
| 积分 | star.fill |
| 订单 | list.bullet.rectangle.fill |
| 我的 | person.fill |
| 搜索 | magnifyingglass |
| 通知 | bell.fill |
| 返回 | chevron.left |
| 更多 | chevron.right |
| 成功 | checkmark.circle.fill |
| 购物袋 | bag.fill |
| 礼物 | gift.fill |
| 地址 | location.fill |
| 编辑 | pencil |
| 删除 | trash |
