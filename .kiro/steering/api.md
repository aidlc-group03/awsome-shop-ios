# API Integration

## Base Configuration

### Endpoints

| 环境 | Base URL |
|------|----------|
| Local | http://localhost:8080/api |
| Dev | http://dev-api.awsome-shop.com/api |
| Production | https://api.awsome-shop.com/api |

### Authentication
- Bearer Token (JWT)
- Token 存储: Keychain
- 自动刷新: 401 时触发

## API Response Format

所有 API 返回统一格式:

```json
{
  "code": 0,
  "message": "success",
  "data": { ... }
}
```

分页响应:

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "current": 1,
    "size": 10,
    "total": 100,
    "pages": 10,
    "records": [ ... ]
  }
}
```

## API Endpoints

### Auth Service (Gateway: /api/v1)

| Method | Path | Description |
|--------|------|-------------|
| POST | /auth/login | 登录 |
| POST | /auth/logout | 登出 |
| GET | /user/profile | 获取用户信息 |

### Product Service (Gateway: /api/v1)

| Method | Path | Description |
|--------|------|-------------|
| POST | /public/product/list | 商品列表 |
| POST | /public/product/detail | 商品详情 |
| POST | /public/product/categories | 分类列表 |

### Points Service (Gateway: /api/v1)

| Method | Path | Description |
|--------|------|-------------|
| POST | /point/balance | 积分余额 |
| POST | /point/transactions | 交易记录 |

### Order Service (Gateway: /api/v1)

| Method | Path | Description |
|--------|------|-------------|
| POST | /order/create | 创建订单 |
| POST | /order/list | 订单列表 |
| POST | /order/detail | 订单详情 |
| POST | /address/list | 地址列表 |
| POST | /address/create | 新增地址 |
| POST | /address/update | 更新地址 |
| POST | /address/delete | 删除地址 |
| POST | /address/set-default | 设为默认 |

## Request/Response Models

### Login

**Request:**
```json
{
  "username": "string",
  "password": "string"
}
```

**Response:**
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIs...",
    "user": {
      "id": 1,
      "username": "zhangsan",
      "displayName": "张三",
      "role": "EMPLOYEE",
      "employeeId": "E001",
      "department": "技术部",
      "title": "高级工程师"
    }
  }
}
```

### Product List

**Request:**
```json
{
  "page": 1,
  "size": 10,
  "name": "耳机",
  "category": "数码电子"
}
```

**Response:**
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "current": 1,
    "size": 10,
    "total": 50,
    "pages": 5,
    "records": [
      {
        "id": 1,
        "name": "Sony WH-1000XM5 降噪耳机",
        "sku": "SONY-WH1000XM5",
        "category": "数码电子",
        "brand": "Sony",
        "pointsPrice": 2580,
        "marketPrice": 2999.00,
        "stock": 100,
        "soldCount": 50,
        "status": 1,
        "imageUrl": "https://cdn.awsome-shop.com/products/sony-xm5.jpg"
      }
    ]
  }
}
```

### Create Order

**Request:**
```json
{
  "productId": 1,
  "addressId": 10
}
```

**Response:**
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "id": 100,
    "userId": 1,
    "productId": 1,
    "productName": "Sony WH-1000XM5 降噪耳机",
    "productImageUrl": "https://cdn.awsome-shop.com/products/sony-xm5.jpg",
    "points": 2580,
    "status": "PENDING",
    "createdAt": "2026-06-11T10:30:00Z"
  }
}
```

## Error Codes

| Code | Message | Description |
|------|---------|-------------|
| 0 | success | 成功 |
| 401 | Unauthorized | 未授权/Token过期 |
| 1001 | User not found | 用户不存在 |
| 1002 | Invalid password | 密码错误 |
| 2001 | Product not found | 商品不存在 |
| 2002 | Product out of stock | 库存不足 |
| 2003 | Product offline | 商品已下架 |
| 3001 | Insufficient points | 积分不足 |
| 4001 | Order not found | 订单不存在 |
| 4002 | Invalid order status | 订单状态无效 |

## Network Implementation

```swift
// APIClient.swift
actor APIClient {
    private let session: URLSession
    private let baseURL: URL
    private var token: String?
    
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        var request = endpoint.urlRequest(baseURL: baseURL)
        
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            throw APIError.unauthorized
        }
        
        let apiResponse = try JSONDecoder().decode(APIResponse<T>.self, from: data)
        
        if apiResponse.code != 0 {
            throw APIError.serverError(code: apiResponse.code, message: apiResponse.message)
        }
        
        guard let data = apiResponse.data else {
            throw APIError.noData
        }
        
        return data
    }
}
```
