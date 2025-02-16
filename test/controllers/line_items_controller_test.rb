require "test_helper"

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_item = line_items(:one)
  end

  test "should get index" do
    get line_items_url
    assert_response :success
  end

  test "should get new" do
    get new_line_item_url
    assert_response :success
  end

  test "should create line_item" do
    assert_difference("LineItem.count") do
      post line_items_url, params: { product_id: products(:one).id }
    end

    follow_redirect!

    assert_select "h2", "Your Donut Cart"
    assert_select "td", "1"
    assert_select "td", "ChocoDonut"
  end

  test "should show line_item" do
    get line_item_url(@line_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_line_item_url(@line_item)
    assert_response :success
  end

  test "should update line_item" do
    patch line_item_url(@line_item),
      params: { line_item: { product_id: @line_item.product_id } }
    assert_redirected_to line_item_url(@line_item)
  end

  test "should destroy line_item" do
    cart = @line_item.cart  # need to capture cart before deletion

    assert_difference("LineItem.count", -1) do
      delete line_item_url(@line_item)
    end

    assert_redirected_to cart_url(cart)
  end

  test "should create line_item with unique product" do
    assert_difference("LineItem.count") do
      post line_items_url, params: { product_id: products(:one).id } # ChocoDonut
    end

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.count

    assert_difference("LineItem.count") do
      post line_items_url, params: { product_id: products(:two).id } # SugarDonut
    end

    assert_equal 2, cart.line_items.reload.count
  end

  test "should combine dublicate items in cart" do
    post line_items_url, params: { product_id: products(:one).id }
    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.first.quantity

    post line_items_url, params: { product_id: products(:one).id }

    assert_equal 1, cart.line_items.count
    assert_equal 2, cart.line_items.first.reload.quantity
  end
end
