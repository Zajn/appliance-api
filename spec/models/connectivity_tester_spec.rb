require 'spec_helper'
require 'rspec/mocks'
require 'socket'

describe ConnectivityTester, type: :model do
  let(:appliance) {Appliance.create! name: 'app1', customer: 'WhiteHat'}
  let(:target_1) { Target.create! address: '127.0.0.1', hostname: '1234-localhost',
    appliance: appliance }
  let(:target_2) { Target.create! address: '8.8.8.8', hostname: '1234-otherhost',
    appliance: appliance }

  describe '#ping' do

    around(:each) do |example|
      server = TCPServer.open(9999)
      example.run
      server.close
    end

    it 'sets reachable to true for a reachable host' do
      connection_tester = ConnectivityTester.new([target_1], '9999')
      connection_tester.ping
      expect(target_1.reachable).to be(true)
    end

    it 'sets reachable to false for a non-reachable host' do
      connection_tester = ConnectivityTester.new([target_2])
      connection_tester.ping
      expect(target_2.reachable).to be(false)
    end
  end
end
