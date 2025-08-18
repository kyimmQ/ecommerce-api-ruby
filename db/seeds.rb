# === Clear existing data in correct order ===
VariantOptionValue.delete_all
ProductReview.delete_all
ProductVariant.delete_all
ProductOptionValue.delete_all
CategoryProductOption.delete_all
ProductOption.delete_all
Product.delete_all

Category.where.not(parent_id: nil).delete_all
Category.where(parent_id: nil).delete_all

UserRole.delete_all
RolePermission.delete_all
Permission.delete_all
Role.delete_all
User.delete_all

# === Create Permissions ===
permissions = {
  purchase_items: Permission.create!(name: "purchase_items"),
  manage_store: Permission.create!(name: "manage_store"),
  manage_system: Permission.create!(name: "manage_system")
}

# === Create Roles and Assign Permissions ===
buyer = Role.create!(name: "buyer")
buyer.permissions << permissions[:purchase_items]

owner = Role.create!(name: "owner")
owner.permissions << permissions[:manage_store]

admin = Role.create!(name: "admin")
admin.permissions << permissions.values

# === Create Users and Assign Roles ===
buyer_user = User.create!(
  name: "Alice Buyer",
  email: "alice@example.com",
  password: "password",
  phone: "1234567890",
  address: "123 Market St"
)
UserRole.create!(user: buyer_user, role: buyer)

owner_user = User.create!(
  name: "Bob Owner",
  email: "bob@example.com",
  password: "password",
  phone: "2345678901",
  address: "456 Store Ave"
)
UserRole.create!(user: owner_user, role: owner)
UserRole.create!(user: owner_user, role: buyer)

admin_user = User.create!(
  name: "Carol Admin",
  email: "carol@example.com",
  password: "password",
  phone: "3456789012",
  address: "789 Admin Blvd"
)
UserRole.create!(user: admin_user, role: admin)

puts "✅ Seed completed: 3 roles, 5 permissions, 3 users with roles assigned."

# === Additional Owners ===
owners = [
  { name: "Daisy iSeller", email: "daisy@apple.com" },
  { name: "Evan Droid", email: "evan@android.com" },
  { name: "Fiona Men's Fashion", email: "fiona@menswear.com" },
  { name: "Grace Women's Fashion", email: "grace@womenswear.com" }
].map do |data|
  user = User.create!(
    name: data[:name],
    email: data[:email],
    password: "password",
    phone: "0000000000",
    address: "Somewhere"
  )
  UserRole.create!(user:, role: owner)
  user
end

# === Categories ===
electronics = Category.create!(name: "Electronics", description: "Electronic Devices")
smartphones = Category.create!(name: "Smartphones", description: "Mobile phones", parent_id: electronics.id)
laptops = Category.create!(name: "Laptops", description: "Portable computers", parent_id: electronics.id)

iphone = Category.create!(name: "iPhone", description: "Apple smartphones", parent_id: smartphones.id)
android = Category.create!(name: "Android", description: "Android smartphones", parent_id: smartphones.id)

macbook = Category.create!(name: "MacBook", description: "Apple laptops", parent_id: laptops.id)
windows = Category.create!(name: "Windows Laptops", description: "Windows OS laptops", parent_id: laptops.id)

fashion = Category.create!(name: "Fashion", description: "Clothing & Accessories")
tshirts = Category.create!(name: "T-Shirts", description: "T-shirt collection", parent_id: fashion.id)
menswear = Category.create!(name: "Men's Wear", description: "For men", parent_id: tshirts.id)
womenswear = Category.create!(name: "Women's Wear", description: "For women", parent_id: tshirts.id)

# === Helpers ===

def add_category_options(category, option_defs)
  option_defs.each do |opt|
    product_option = ProductOption.find_or_create_by!(name: opt[:name])

    unless category.product_options.exists?(product_option.id)
      CategoryProductOption.create!(category: category, product_option: product_option)
    end

    opt[:values].each do |val|
      ProductOptionValue.find_or_create_by!(product_option: product_option, value: val)
    end
  end

  # Add shared "Type" option to all categories
  type_option = ProductOption.find_or_create_by!(name: "Type")
  unless category.product_options.exists?(type_option.id)
    CategoryProductOption.create!(category: category, product_option: type_option)
  end
end

def create_product_with_variants(owner:, category:, name:, desc:, options:, image_url: nil)
  product = Product.create!(
    name: name,
    description: desc,
    owner: owner,
    category: category,
    image_url: image_url
  )

  add_category_options(category, options)

  option_records = options.map do |opt|
    product_option = ProductOption.find_by!(name: opt[:name])
    opt[:values].map { |val| ProductOptionValue.find_by!(product_option: product_option, value: val) }
  end

  combinations = option_records[0].product(*option_records[1..])

  combinations.each_with_index do |combo, i|
    variant = ProductVariant.create!(
      product: product,
      sku: "#{product.name.parameterize}-#{i}",
      price: rand(500..1500),
      stock_quantity: rand(10..50)
    )

    combo.each do |opt_val|
      VariantOptionValue.create!(
        product_variant: variant,
        product_option_value: opt_val
      )
    end
  end
end

# === Products ===
create_product_with_variants(
  owner: owners[0],
  category: iphone,
  name: "iPhone 15",
  desc: "Latest Apple iPhone with A17 chip",
  image_url: "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=500&h=500&fit=crop&crop=center",
  options: [
    { name: "Color", values: [ "Black", "White" ] },
    { name: "Storage", values: [ "128GB", "256GB" ] }
  ]
)

create_product_with_variants(
  owner: owners[0],
  category: macbook,
  name: "MacBook Pro 14\"",
  desc: "Apple Silicon laptop for pros",
  image_url: "https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=500&h=500&fit=crop&crop=center",
  options: [
    { name: "RAM", values: [ "16GB", "32GB" ] },
    { name: "Storage", values: [ "512GB", "1TB" ] }
  ]
)

create_product_with_variants(
  owner: owners[1],
  category: android,
  name: "Pixel 8",
  desc: "Android flagship phone from Google",
  image_url: "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500&h=500&fit=crop&crop=center",
  options: [
    { name: "Color", values: [ "Obsidian", "Hazel" ] },
    { name: "Storage", values: [ "128GB", "256GB" ] }
  ]
)

create_product_with_variants(
  owner: owners[1],
  category: windows,
  name: "Dell XPS 13",
  desc: "High-end Windows laptop",
  image_url: "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500&h=500&fit=crop&crop=center",
  options: [
    { name: "RAM", values: [ "8GB", "16GB" ] },
    { name: "Storage", values: [ "256GB", "512GB" ] }
  ]
)

create_product_with_variants(
  owner: owners[2],
  category: menswear,
  name: "Men's Classic Tee",
  desc: "Comfy cotton T-shirt for men",
  image_url: "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500&h=500&fit=crop&crop=center",
  options: [
    { name: "Color", values: [ "Black", "Gray" ] },
    { name: "Size", values: [ "M", "L", "XL" ] }
  ]
)

create_product_with_variants(
  owner: owners[3],
  category: womenswear,
  name: "Women's V-Neck Tee",
  desc: "Stylish T-shirt with v-neck cut",
  image_url: "https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=500&h=500&fit=crop&crop=center",
  options: [
    { name: "Color", values: [ "Red", "White" ] },
    { name: "Size", values: [ "S", "M", "L" ] }
  ]
)

puts "✅ Extra seed: categories, 4 owners, 6 products with shared options & variants"
