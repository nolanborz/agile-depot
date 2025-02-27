class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: %i[ create destroy ]
  before_action :set_line_item, only: %i[ show edit update destroy decrease_quantity ]

  # GET /line_items or /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1 or /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items or /line_items.json
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product)
    @current_item = @line_item

    respond_to do |format|
      if @line_item.save
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace("cart",
              partial: "layouts/cart",
              locals: { cart: @cart, current_item: @current_item })
          ]
        }
        format.html { redirect_to store_index_url }
        format.json { render :show,
          status: :created, location: @line_item }
      else
        format.html { render :new,
          status: :unprocessable_entity }

          format.json { render json: @line_item.errors,
            status: :unprocessable_entity }
      end
    end
  end
  # PATCH/PUT /line_items/1 or /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: "Line item was successfully updated." }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1 or /line_items/1.json
  def destroy
    cart = @line_item.cart
    @line_item.destroy!

    respond_to do |format|
      format.turbo_stream do
        if cart.line_items.empty?
          render turbo_stream: turbo_stream.replace("cart", partial: "layouts/cart", locals: { cart: cart })
        else
          render turbo_stream: [
            turbo_stream.remove(@line_item),
            turbo_stream.replace("cart", partial: "layouts/cart", locals: { cart: cart })
          ]
        end
      end
      format.html { redirect_to line_items_path, notice: "Line item was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  def set_line_item
    @line_item = LineItem.find(params[:id])
  end

  def decrease_quantity
    if @line_item.quantity > 1
      @line_item.quantity -= 1
      @line_item.save

      respond_to do |format|
        cart = @line_item.cart
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("cart",
            partial: "layouts/cart",
            locals: { cart: cart })
        end
        format.html { redirect_to store_index_url }
        format.json { render :show, status: :ok, location: @line_item }
      end
    else
      destroy
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.


    # Only allow a list of trusted parameters through.
    def line_item_params
      params.require(:line_item).permit(:product_id)
    end
  # ...
end
