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
  end
end