class Category < ApplicationRecord
  after_create :add_default_type_option


  has_many :products, dependent: :nullify

  has_many :category_product_options, dependent: :destroy
  has_many :product_options, through: :category_product_options
  has_many :subcategories, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  belongs_to :parent, class_name: "Category", optional: true

  validates :name, presence: true

  # Refractor due to N+1 problem
  def self.recursive_tree
    all_categories = Category.all
    grouped = all_categories.group_by(&:parent_id)

    roots = grouped[nil] || []
    roots.map { |root| build_tree root, grouped }
  end

  def all_product_options
    # Get all product options for this category and its subcategories
    sql = <<-SQL
        WITH RECURSIVE subcategories AS (
          SELECT id
          FROM categories
          WHERE id = #{self.id}
        UNION ALL
          SELECT c.id
          FROM categories c
          INNER JOIN subcategories s ON c.parent_id = s.id
        )
        SELECT DISTINCT po.id, po.name
        FROM subcategories s
        JOIN category_product_options cpo ON s.id = cpo.category_id
        JOIN product_options po ON po.id = cpo.product_option_id;
    SQL
    # Execute the SQL query to get all product options
    ProductOption.find_by_sql(sql)
  end

  def all_descendant_ids
    children = Category.where(parent_id: id)
    children_ids = children.pluck(:id)
    children_ids + children.flat_map(&:all_descendant_ids)
  end



  private
  def self.build_tree(curr_category, grouped)
    {
      id: curr_category.id,
      name: curr_category.name,
      description: curr_category.description,
      subcategory: (grouped[curr_category.id] || []).map { |subcategory| build_tree subcategory, grouped },
    }
  end

  def add_default_type_option
    default_option = ProductOption.find_or_create_by!(name: "Type")
    CategoryProductOption.find_or_create_by!(category: self, product_option: default_option)
  end

end
