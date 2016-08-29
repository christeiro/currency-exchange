class ExchangesController < ApplicationController
  before_action :authenticate_user!

  def index
    @exchange = Exchange.new
    @currency_exchanges = current_user.exchanges
    @currencies = Currency.all
  end

  def create
    @exchange = current_user.exchanges.build(set_params)
    if @exchange.save
      create_background_job(@exchange)
    end
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
    @exchange = Exchange.find(params[:id])
    predicted_rates
    unless @predicted_rates
      flash[:notice] = "Your currency exchange is being calculated, please check back shortly"
    end
  end

  def update
    @exchange = Exchange.find(params[:id])
    @exchange.update_attributes(set_params)
    binding.pry
    if @exchange.save
      create_background_job(@exchange)
      redirect_to exchange_path(@exchange)
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
    job = BackgroundJob.create(period: exchange.period, base_currency_id: exchange.base_currency_id, exchange: exchange)
    BackgroundJobWorker.perform_async(job.id)
  end

  def predicted_rates
    @predicted_rates = ExchangeService.new(@exchange).perform
  end

  def currencies
    @currencies = Currency.all
  end
end
