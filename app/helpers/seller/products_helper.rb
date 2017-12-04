module Seller::ProductsHelper
  def edit_product(product, options = {})
    html_class = "btn btn-danger"
    html_class += " #{options[:html_class]}" unless options[:html_class].blank?

    link_to "<i class='fa'></i> 修改商品".html_safe, edit_seller_product_path, class: html_class, 'data-product-id': product.id
  end
end
