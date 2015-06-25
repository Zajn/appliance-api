class TargetsController < ApplicationController

  def status
    @appliances = Appliance.includes(:targets)
    targets = @appliances.flat_map(&:targets)
    ct = ConnectivityTester.new(targets)
    ct.ping

    # TODO: Separate the rest of this out into a chart creation class
    count = targets.count
    reachable = targets.select(&:reachable).count
    unreachable = targets.count - reachable
    chartjs_data = [
      { value: unreachable, color: '#F7464A', highlight: '#FF5A5E', label: 'Offline' },
      { value: reachable, color: '#46BFBD', highlight: '#5AD3D1', label: 'Online ' }
    ]

    @chart_data = { count: count, reachable: reachable,
                   unreachable: unreachable, chartjs_data: chartjs_data }
  end
end
