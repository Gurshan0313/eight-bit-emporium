require 'csv'
require 'faker'

puts "🗑️  Clearing data..."
OrderItem.destroy_all
Order.destroy_all
Product.destroy_all
Category.destroy_all
Page.destroy_all
Province.destroy_all

# ============================================================
# PROVINCES WITH CORRECT CANADIAN TAX RATES (Feature 3.2.3)
# ============================================================
puts "🍁 Seeding provinces..."

provinces = [
  { name: "Alberta",                   abbreviation: "AB", gst: 0.05, pst: 0.00, hst: 0.00 },
  { name: "British Columbia",          abbreviation: "BC", gst: 0.05, pst: 0.07, hst: 0.00 },
  { name: "Manitoba",                  abbreviation: "MB", gst: 0.05, pst: 0.07, hst: 0.00 },
  { name: "New Brunswick",             abbreviation: "NB", gst: 0.00, pst: 0.00, hst: 0.15 },
  { name: "Newfoundland and Labrador", abbreviation: "NL", gst: 0.00, pst: 0.00, hst: 0.15 },
  { name: "Northwest Territories",     abbreviation: "NT", gst: 0.05, pst: 0.00, hst: 0.00 },
  { name: "Nova Scotia",               abbreviation: "NS", gst: 0.00, pst: 0.00, hst: 0.15 },
  { name: "Nunavut",                   abbreviation: "NU", gst: 0.05, pst: 0.00, hst: 0.00 },
  { name: "Ontario",                   abbreviation: "ON", gst: 0.00, pst: 0.00, hst: 0.13 },
  { name: "Prince Edward Island",      abbreviation: "PE", gst: 0.00, pst: 0.00, hst: 0.15 },
  { name: "Quebec",                    abbreviation: "QC", gst: 0.05, pst: 0.09975, hst: 0.00 },
  { name: "Saskatchewan",              abbreviation: "SK", gst: 0.05, pst: 0.06, hst: 0.00 },
  { name: "Yukon",                     abbreviation: "YT", gst: 0.05, pst: 0.00, hst: 0.00 },
]

provinces.each { |p| Province.create!(p) }
puts "  ✅ #{Province.count} provinces seeded"

# ============================================================
# DATA SOURCE 1: Games CSV
# ============================================================
puts "📂 Seeding from games CSV..."

category_map = {}

CSV.foreach(Rails.root.join('db', 'seeds_data', 'games.csv'), headers: true) do |row|
  cat_name = row['category'].strip
  unless category_map[cat_name]
    category_map[cat_name] = Category.find_or_create_by!(name: cat_name) do |c|
      c.description = "Browse our curated collection of #{cat_name}. All items tested by our staff."
    end
  end

  Product.create!(
    name: row['product_name'].strip,
    description: row['description'].strip,
    condition: row['condition'].strip,
    stock_quantity: row['stock'].to_i,
    price: row['price'].to_f,
    on_sale: false,
    category: category_map[cat_name]
  )
end

puts "  ✅ Games CSV done: #{Product.count} products"

# ============================================================
# DATA SOURCE 2: Consoles CSV
# ============================================================
puts "🕹️  Seeding from consoles CSV..."

CSV.foreach(Rails.root.join('db', 'seeds_data', 'consoles.csv'), headers: true) do |row|
  cat_name = row['category'].strip
  category = category_map[cat_name] ||= Category.find_or_create_by!(name: cat_name) do |c|
    c.description = "Browse our curated collection of #{cat_name}. All items tested by our staff."
  end

  Product.create!(
    name: "#{row['name']} (#{row['year_released']})",
    description: row['description'].strip,
    condition: row['condition'].strip,
    stock_quantity: row['stock'].to_i,
    price: row['price'].to_f,
    on_sale: false,
    category: category
  )
end

puts "  ✅ Consoles CSV done: #{Product.count} products total"

# Put a few products on sale
Product.order("RANDOM()").limit(8).update_all(on_sale: true)
Product.where(on_sale: true).each { |p| p.update!(sale_price: (p.price * 0.8).round(2)) }

# ============================================================
# PAGES (About + Contact)
# ============================================================
Page.create!(
  title: "About Us",
  slug: "about",
  content: "8-Bit Emporium has been Winnipeg's premier retro gaming destination since 2016. Located in the Exchange District, our team of passionate gaming enthusiasts carefully authenticates, tests, and rates every item in our inventory. We specialize in classic video game cartridges, consoles, accessories, and collectibles spanning the Atari era through the early 2000s."
)

Page.create!(
  title: "Contact Us",
  slug: "contact",
  content: "Have a question about an item or want to sell us your collection? We'd love to hear from you!\n\nVisit us at our Exchange District location in Winnipeg, Manitoba.\n\nEmail: info@8bitemporium.ca\nPhone: (204) 555-0142\nHours: Monday–Saturday 10am–6pm, Sunday 12pm–5pm"
)

puts "  ✅ Pages seeded"

puts ""
puts "✅ Seeding complete!"
puts "   Provinces: #{Province.count}"
puts "   Categories: #{Category.count}"
puts "   Products:   #{Product.count}"
puts "   Pages:      #{Page.count}"

# Create admin user only if it doesn't already exist (idempotent)
AdminUser.find_or_create_by!(email: 'admin@example.com') do |admin|
  admin.password = 'password'
  admin.password_confirmation = 'password'
end