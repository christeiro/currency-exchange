class ExchangesController < ApplicationController
  before_action :authenticate_user!

  def index
    @exchange = Exchange.new
    @currency_exchanges = current_user.exchanges
    @currencies = Currency.all
  end

  def create
    @exchange = current_user.exchanges.build(set_params.merge(request_date: Date.today))
    create_background_job(@exchange) if @exchange.save
    respond_to do |format|
      format.js
      format.html { redirect_to exchanges_path }
    end
  end

  def destroy
    @exchange = current_user.exchanges.find(params[:id])
    @exchange.destroy
    respond_to do |format|
      format.js
      format.html { redirect_to exchanges_path }
    end
  end

  def show
    currencies
    @exchange = Exchange.find_by_id(params[:id])
    if @exchange
      predicted_rates
      unless @predicted_rates
        flash[:notice] = 'Your currency exchange is being calculated,
        please check back shortly'
      end
    else
      flash[:notice] = 'The item does not exist anymore!'
      redirect_to exchanges_path
    end
  end

  def update
    @exchange = Exchange.find(params[:id])
    @exchange.update_attributes(set_params.merge(completed: 0, request_date: Date.today))
    if @exchange.save
      create_background_job(@exchange)
      flash[:success] = 'Currency Rate updated'
      redirect_to exchanges_path
    else
      currencies
      render :show
    end
  end

  private

  def set_params
    params.require(:exchange).permit(:base_currency_id, :target_currency_id, :period, :amount)
  end

  def create_background_job(exchange)
    ExchangeWorker.perform_async(exchange.id)
  end

  def predicted_rates
    @predicted_rates = ExchangeService.new(@exchange).perform
  end

  def currencies
    @currencies = Currency.all
  end
end
