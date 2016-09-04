require 'rails_helper'
require 'linear_regression'

describe LinearRegression do
  describe "#predict" do
    it "returns the predicted number" do
      regression = LinearRegression.new([1,2,3,4,5])
      expect(regression.predict(6)).to eq(6.0)
    end
    it "with empty input returns Float" do
      regression = LinearRegression.new([])
      expect(regression.predict(6)).to be_kind_of(Float)
    end
  end
end