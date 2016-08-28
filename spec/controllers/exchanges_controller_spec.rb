require 'rails_helper'

describe ExchangesController do
  describe "GET index" do
    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end

    it "sets @exchange" do
      user = Fabricate(:user)
      sign_in(user)
      get :index
      expect(assigns(:exchange)).to be_a_new(Exchange)
    end

    it "sets @currencies" do
      user = Fabricate(:user)
      eur_currency = Fabricate(:currency)
      usd_currency = Fabricate(:currency, code: Money::Currency.new('USD').iso_code )
      sign_in(user)
      get :index
      expect(assigns(:currencies)).to match_array([eur_currency, usd_currency])
    end
  end
end