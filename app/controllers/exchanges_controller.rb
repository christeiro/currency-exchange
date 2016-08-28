class ExchangesController < ApplicationController
  before_action :authenticate_user!

  def index
    @exchange = Exchange.new
    @currency_exchanges = current_user.exchanges
    @currencies = Currency.all
  end

  def create
    @exchange = current_user.exchanges.build(set_params)
    @exchange.save
    respond_to do |format|
      format.js
    end
  end

  def destroy
    binding.pry
    @exchange = curren_user.exchange.find(params[:id])
    # @comment = @moment.comments.find(params[:id])
    # if @comment.user.id = current_user.id
    #   @comment.delete
    #   respond_to do |format|
    #     format.html { redirect_to root_path }
    #     format.js
    #   end
    # end
  end

  private

  def set_params
    params.require(:exchange).permit(:base_currency_id, :target_currency_id, :period, :amount)
  end

end