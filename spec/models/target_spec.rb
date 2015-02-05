require 'spec_helper'

describe Target, :type => :model do
  let(:appliance) {Appliance.create! name: 'app1', customer: 'WhiteHat'}

  describe "#address" do
    it "validates IP addresses" do
      target = Target.new hostname: 'foo', address: '8.8.8.8', appliance: appliance
      expect(target.valid?).to be(true)
    end

    it "fails bad IP addresses" do
      target = Target.new hostname: 'foo', address: '888.888.888.888', appliance: appliance
      expect(target.valid?).to be(false)
    end
  end
end
