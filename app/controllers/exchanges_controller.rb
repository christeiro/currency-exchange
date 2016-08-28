class ExchangesController < ApplicationController
  before_action :authenticate_user!

  def index
    @exchange = Exchange.new
    @currency_exchanges = current_user.exchanges
  end
end