class ItemsController < ApplicationController
  def index
    @items = Item.order('created_at DESC').limit(5)
  end

  def new
    @item = Item.new
    @item_image = @item.item_images.build
    @parents = Category.where(ancestry: nil)
    respond_to do |format|
      format.html
      format.json do
        #親ボックスのidから子ボックスのidの配列を作成してインスタンス変数で定義
        if params[:parent_id].present?
          @children = Category.find(params[:parent_id]).children
        #子ボックスのidから孫ボックスのidの配列を作成してインスタンス変数で定義
        elsif params[:child_id].present?
          # binding.pry
          @grandchildren = Category.find(params[:child_id]).children
        end
      end
    end
  end
  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @item = Item.find(params[:id])
    @user = User.find(@item.user_id)
    #find_byでitemがあるかないかあったら@purchaseにいれる
    @purchase = Purchase.find_by(item_id: @item.id)
    @category = Category.find(388)
    @condition = Condition.find(params[:id])
    @shipping_cost = ShippingCost.find(params[:id])
    @area = Area.find(params[:id])
    @day = Day.find(params[:id])
  end

  def done
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :price, :category_id,:brand_name, :condition_id, :shipping_cost_id, :area_id, :day_id, item_images_attributes: {image: []})
  end
end
