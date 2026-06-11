# Screen Specifications

## 1. LoginView - 登录页

### Layout
- 上半部分 (35%): 品牌区域，渐变背景 (primary → primaryDark)
- 下半部分 (65%): 白色圆角卡片，登录表单

### Brand Section
- App Icon: SF Symbol `gift.fill` 或自定义 Logo, 56pt
- App Name: "AWSome Shop", headline1, white
- Tagline: "员工积分兑换平台", body1, white@80%

### Login Form
- Title: "欢迎回来", headline2
- Subtitle: "登录您的账户以继续", body2, textSecondary
- Username Field: ASTextField, placeholder="用户名", icon=person
- Password Field: ASTextField, secure, placeholder="密码", icon=lock
- Login Button: ASButton.primary, full width, "登 录"
- Forgot Password: TextButton, "忘记密码？"

### ViewModel State
- username: String
- password: String
- isLoading: Bool
- errorMessage: String?

---

## 2. HomeView - 首页

### Layout
- Top: 导航栏 (固定)
- Content: 可滚动区域 (积分横幅 → 分类 → 商品网格)
- Bottom: Tab Bar (固定)

### Navigation Bar (64pt)
- Left: Logo + "AWSome Shop"
- Right: 搜索图标 + 通知图标 + 用户头像

### Points Banner
- 渐变背景: primary → primaryLight
- Left: "我的积分" (caption) + 余额数字 (headline1)
- Right: 箭头图标
- 点击: 跳转积分中心
- Corner Radius: lg
- Padding: 20pt

### Category Filter
- 横向 ScrollView
- Chips: 全部(selected), 数码电子, 生活日用, 美食餐饮, 礼品卡券, 办公文具
- Selected: primary background, white text
- Unselected: white background, border, textPrimary

### Product Grid
- LazyVGrid, 2 columns
- Spacing: 12pt
- Card 内容:
  - 图片区: 120pt height, primaryBg 背景
  - 商品名: body2, 2 lines max
  - 积分价: body2, semibold, primary color, "XXX 积分"

### ViewModel State
- selectedCategory: String
- products: [Product]
- pointsBalance: Int
- isLoading: Bool

---

## 3. ProductDetailView - 商品详情

### Layout
- 可滚动区域
- 底部操作栏 (固定)

### Image Section
- 主图: 400pt height, 可左右滑动
- 缩略图: 横向排列, 60pt, 可选中切换

### Product Info
- 面包屑: 首页 > 分类 > 商品名
- 标题: headline2
- 副标题: body2, textSecondary
- 价格卡片: 渐变背景
  - "限时兑换", caption
  - 积分价, headline1
  - 市场价 (划线), caption

### Info Items
- 配送方式
- 服务保障
- 促销信息

### Bottom Bar (固定)
- 收藏按钮: outline
- 立即兑换按钮: primary, "立即兑换 · XXX积分"

### ViewModel State
- product: Product?
- selectedImageIndex: Int
- isFavorite: Bool
- isLoading: Bool

---

## 4. ConfirmRedemptionView - 确认兑换

### Layout
- Page Header: "确认兑换" + 返回按钮
- 卡片列表 (可滚动)
- 底部按钮组 (固定)

### Product Card
- 商品图片 (80pt)
- 商品名
- 商品规格
- 积分价

### Points Card
- "积分扣减"
- 当前余额
- 扣减积分 (红色)
- 剩余积分

### Balance Bar
- 蓝色背景 (primaryBg)
- "扣减后余额: XXX 积分"

### Delivery Card
- 收货人
- 联系电话
- 收货地址
- 修改按钮

### Button Row
- 取消按钮: outline
- 确认兑换按钮: primary

### Notes
- 积分兑换成功后不可退换
- 预计发货时间说明

### ViewModel State
- product: Product
- address: Address?
- pointsBalance: Int
- isLoading: Bool
- showAddressSheet: Bool

---

## 5. DeliveryInfoView - 收货地址

### Layout
- Page Header
- 已保存地址列表
- 新增地址表单
- 底部按钮

### Saved Addresses
- 每个地址卡片:
  - 收货人 + 电话
  - 完整地址
  - 默认标签 (可选)
  - 单选圆点 (右侧)

### New Address Form
- 收货人: ASTextField
- 手机号: ASTextField, keyboardType=phone
- 所在地区: Picker (省市区)
- 详细地址: ASTextField, multiline

### ViewModel State
- addresses: [Address]
- selectedAddressId: Int64?
- newAddress: AddressForm
- isLoading: Bool

---

## 6. RedemptionSuccessView - 兑换成功

### Layout
- 居中卡片

### Success Card (居中)
- Success Icon: checkmark.circle.fill, 80pt, green, 圆形绿色背景
- Title: "兑换成功!", headline2
- Subtitle: "您的订单已提交，请等待发货", body2, textSecondary
- Divider
- Order Info (灰色背景区域):
  - 订单编号
  - 商品名称
  - 扣减积分
  - 下单时间
- Divider
- Button Group:
  - 查看订单: primary
  - 继续逛逛: outline

---

## 7. OrdersView - 订单列表

### Layout
- Tab Filter (全部/待发货/已发货/已完成)
- Order List

### Tab Filter
- Segmented Control 或 Chip 组

### Order Card
- 订单号 + 状态标签
- 商品图片 + 名称 + 积分
- 下单时间
- 操作按钮 (查看详情)

### ViewModel State
- selectedTab: OrderStatus?
- orders: [Order]
- isLoading: Bool

---

## 8. OrderDetailView - 订单详情

### Layout
- 可滚动卡片列表

### Status Card
- 订单状态 (大字)
- 状态时间线:
  - 已下单 ✓
  - 已发货 ✓ / 待发货
  - 已完成 / 待完成
- 物流单号 (如有)

### Product Card
- 商品图片 + 名称
- 商品规格
- 积分价

### Points Card
- 积分扣减明细

### Delivery Card
- 收货人
- 联系电话
- 收货地址

### Order Info Card
- 订单编号
- 下单时间
- 发货时间 (如有)
- 完成时间 (如有)

### Action Buttons
- 联系客服
- 确认收货 (待收货状态)

---

## 9. PointsCenterView - 积分中心

### Layout
- 积分余额卡片
- 快捷入口
- 最近交易

### Balance Card
- 渐变背景
- 当前积分 (headline1)
- 累计获得 / 累计使用

### Quick Actions
- 兑换记录
- 积分明细
- 积分规则

### Recent Transactions
- 最近5条记录
- "查看全部" 链接

---

## 10. PointsHistoryView - 积分明细

### Layout
- 筛选 Tab
- 交易列表

### Filter Tabs
- 全部 / 获取 / 使用

### Transaction Item
- Icon (根据类型)
- 交易描述
- 时间
- 积分变化 (+/- 颜色区分)
- 交易后余额

---

## 11. ProfileView - 个人中心

### Layout
- 用户信息卡片
- 功能列表

### User Card
- 头像 (60pt)
- 姓名
- 工号 / 部门

### Function List
- 我的订单
- 收货地址
- 积分明细
- 帮助中心
- 关于我们
- 退出登录
