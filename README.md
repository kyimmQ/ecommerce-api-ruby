# 🛒 ECommerce API Platform

A full-featured ecommerce platform built with Ruby on Rails that provides both web interfaces and RESTful APIs for managing an online store. The application supports multiple user types with role-based access control and offers comprehensive product management, shopping, and order processing capabilities.

## 📋 Features

### 🌐 Multi-Interface Architecture
- **Buyer Web Interface** - Modern Bootstrap UI for customers
- **Admin/Ops Dashboard** - Comprehensive store management interface  
- **RESTful API** - JSON endpoints for mobile apps and integrations

### 👥 User Management
- **Role-Based Access Control** (Buyers, Store Owners, Admins)
- **JWT Authentication** with session persistence
- **Secure Registration & Login** with bcrypt password hashing
- **User Profiles** with order history

### 🛍️ Product Catalog
- **Hierarchical Categories** (Electronics → Smartphones → iPhone)
- **Product Variants** with multiple options (Color, Size, Storage, etc.)
- **Rich Product Information** with image support
- **Advanced Search & Filtering** by category, price, name
- **Inventory Management** with stock tracking

### 🛒 Shopping Experience
- **Shopping Cart** with real-time updates
- **Secure Checkout** process
- **Order Tracking** with multiple status levels
- **Order History** and management
- **Cart Persistence** across sessions

### 📊 Analytics Dashboard
- **Sales Metrics** and revenue tracking
- **User Activity** monitoring
- **Product Performance** analytics
- **Order Management** with status updates

## 🛠️ Technology Stack

- **Ruby** 3.3.0
- **Rails** 7.2.2
- **Database** MySQL
- **Authentication** JWT (JSON Web Tokens)
- **Frontend** Bootstrap 5 + Slim Templates
- **Icons** Bootstrap Icons
- **Password Security** bcrypt

## 🚀 Getting Started

### Prerequisites

- Ruby 3.3.0
- MySQL 8.0+
- Node.js (for asset compilation)
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ecommerce_api
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Database setup**
   ```bash
   # Create and setup database
   rails db:create
   rails db:migrate
   
   # Load sample data
   rails db:seed
   ```

4. **Start the server**
   ```bash
   rails server
   ```

5. **Access the application**
   - **Buyer Interface**: http://localhost:3000
   - **Admin Dashboard**: http://localhost:3000/ops
   - **API Documentation**: http://localhost:3000/api/v1

## 🔐 Default Accounts

The seed data creates the following test accounts:

### Buyers
- **Email**: alice@example.com
- **Password**: password

### Store Owners  
- **Email**: bob@example.com
- **Password**: password

### System Admin
- **Email**: carol@example.com  
- **Password**: password

## 📱 API Usage

### Authentication
```bash
# Login to get JWT token
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "alice@example.com", "password": "password"}'
```

### Products
```bash
# Get all products
curl http://localhost:3000/api/v1/products

# Get product by ID
curl http://localhost:3000/api/v1/products/1

# Create product (requires authentication)
curl -X POST http://localhost:3000/api/v1/products \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name": "New Product", "description": "Product description", "category": 1}'
```

### Orders
```bash
# Get user orders (requires authentication)
curl http://localhost:3000/api/v1/orders \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# Create order (requires authentication)
curl -X POST http://localhost:3000/api/v1/orders \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json"
```

## 🗄️ Database Schema

### Core Models

- **Users** - Customer and admin accounts with role-based permissions
- **Products** - Product catalog with categories and variants
- **Categories** - Hierarchical product categorization
- **ProductVariants** - Product options (size, color, etc.) with individual pricing
- **Orders** - Customer orders with item details and status tracking
- **ShoppingCarts** - Persistent shopping carts with cart items
- **Roles & Permissions** - Flexible authorization system

### Key Relationships

```
User ──< UserRole >── Role ──< RolePermission >── Permission
User ──< Orders ──< OrderItems >── ProductVariant
User ── ShoppingCart ──< CartItems >── ProductVariant
Product ──< ProductVariants ──< VariantOptionValues >── ProductOptionValue
Category ──< Products
Category ── CategoryProductOption ── ProductOption ──< ProductOptionValues
```

## 🌍 Application Routes

### Buyer Interface (`/buyer/*`)
- `/` - Product catalog homepage
- `/products` - Browse all products
- `/products/:id` - Product details
- `/cart` - Shopping cart
- `/orders` - Order history
- `/profile` - User profile management
- `/login` & `/register` - Authentication

### Admin Interface (`/ops/*`)
- `/ops` - Admin dashboard
- `/ops/products` - Product management
- `/ops/categories` - Category management  
- `/ops/orders` - Order management
- `/ops/users` - User management

### API Endpoints (`/api/v1/*`)
- `POST /auth/login` - User authentication
- `POST /auth/register` - User registration
- `GET /products` - List products
- `POST /products` - Create product
- `GET /orders` - List user orders
- `POST /orders` - Create order
- `GET /categories` - List categories
- `POST /cart` - Add to cart

## 🔧 Configuration

### Environment Variables

Create a `.env` file:

```env
DATABASE_HOST=localhost
DATABASE_USERNAME=your_username
DATABASE_PASSWORD=your_password
SECRET_KEY_BASE=your_secret_key
JWT_SECRET=your_jwt_secret
```

### Database Configuration

Update `config/database.yml` for your environment:

```yaml
development:
  adapter: mysql2
  database: ecommerce_api_development
  username: <%= ENV['DATABASE_USERNAME'] %>
  password: <%= ENV['DATABASE_PASSWORD'] %>
  host: <%= ENV['DATABASE_HOST'] %>
```

## 🧪 Testing

```bash
# Run the test suite
rails test

# Run specific test files
rails test test/models/user_test.rb
rails test test/controllers/products_controller_test.rb
```

## 📦 Deployment

### Production Setup

1. **Precompile assets**
   ```bash
   RAILS_ENV=production rails assets:precompile
   ```

2. **Setup production database**
   ```bash
   RAILS_ENV=production rails db:migrate
   ```

3. **Start production server**
   ```bash
   RAILS_ENV=production rails server
   ```

### Docker Deployment

```dockerfile
# Dockerfile example
FROM ruby:3.3.0
WORKDIR /app
COPY Gemfile* ./
RUN bundle install
COPY . .
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
```

## 📝 Sample Data

The application includes comprehensive seed data:

- **6 Products** across multiple categories (Electronics, Fashion)
- **Product Variants** with different options (Color, Size, Storage, RAM)
- **7 Users** with different roles (Buyers, Owners, Admin)
- **Hierarchical Categories** (Electronics → Smartphones → iPhone/Android)
- **Product Options** and values for customization

## 🔒 Security Features

- **JWT Authentication** with configurable expiration
- **Role-Based Authorization** with granular permissions
- **Secure Password Storage** using bcrypt
- **SQL Injection Protection** via ActiveRecord
- **CSRF Protection** for web forms
- **Input Validation** and sanitization

## 🎨 UI/UX Features

- **Responsive Design** with Bootstrap 5
- **Modern Icons** using Bootstrap Icons
- **Clean Navigation** with user-friendly menus
- **Real-time Cart Updates** with quantity badges
- **Image Support** for products with fallback placeholders
- **Flash Messages** for user feedback
- **Form Validation** with helpful error messages

## 🔄 API Response Format

All API responses follow a consistent format:

```json
{
  "data": { ... },
  "message": "Success message",
  "errors": []
}
```

### Error Responses
```json
{
  "errors": ["Error message"],
  "status": 400
}
```
