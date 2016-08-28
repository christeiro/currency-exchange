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

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end

    it "creates the exchange it" do
      user = Fabricate(:user)
      eur_currency = Fabricate(:currency)
      usd_currency = Fabricate(:currency, code: Money::Currency.new('USD').iso_code )
      sign_in(user)
      post :create, params: { exchange: { base_currency_id: eur_currency.id, target_currency_id: usd_currency.id, amount: 100, period: 1 } }
      expect(Exchange.count).to eq(1)
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, params: { id: 1 } }
    end

    it "deletes the record" do
      user = Fabricate(:user)
      sign_in(user)
      eur_currency = Fabricate(:currency)
      usd_currency = Fabricate(:currency, code: Money::Currency.new('USD').iso_code )
      exchange = Exchange.create(amount: 100, period: 1, base_currency: eur_currency, target_currency: usd_currency, user: user)
      delete :destroy, id: exchange.id
      expect(Exchange.count).to eq(0)
    end

  end
end