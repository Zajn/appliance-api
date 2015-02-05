require 'spec_helper'

describe Appliance, :type => :model do
  describe "#new" do
    it "validates unique appliance names" do
      Appliance.create name: 'app1', customer: 'WhiteHat'
      appliance = Appliance.new name: 'app1', customer: 'WhiteHat'
      expect(appliance.save).to be(false)
    end
  end
end
