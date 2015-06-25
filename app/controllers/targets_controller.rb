class TargetsController < ApplicationController

  def status
    targets = Target.includes(:appliance)
    ct = ConnectivityTester.new(targets)
    @results = ct.ping

    render stream: true
  end
end
