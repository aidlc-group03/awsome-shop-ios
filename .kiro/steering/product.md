# Product Definition

## Product Name
AWSome Shop iOS App

## Product Description
员工福利积分兑换 iOS 移动应用，支持员工使用"AWSome积分"浏览和兑换预选产品。

## Target Users
- 内部员工 (Employee)

## Core Features

### MVP 功能
1. **用户认证**
   - 员工登录
   - Token 自动刷新
   - 登出

2. **商品浏览**
   - 商品列表展示
   - 分类筛选
   - 商品详情查看

3. **积分兑换**
   - 确认兑换信息
   - 选择/新增收货地址
   - 提交兑换订单

4. **订单管理**
   - 订单列表
   - 订单详情
   - 订单状态追踪

5. **积分管理**
   - 积分余额查询
   - 积分交易历史

## Business Rules
- 积分不足时无法兑换
- 商品库存为0时无法兑换
- 下架商品不在员工端展示
- 订单创建后不可取消 (MVP 阶段)
