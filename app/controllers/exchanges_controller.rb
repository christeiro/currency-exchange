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

  private

  def set_params
    params.require(:exchange).permit(:base_currency_id, :target_currency_id, :period, :amount)
  end

  def create_background_job(exchange)
    job = BackgroundJob.create(period: exchange.period, base_currency_id: exchange.base_currency_id, target_currency_id: exchange.target_currency_id, exchange: exchange)
    BackgroundJobWorker.perform_async(job)
  end
end
