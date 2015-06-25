# A simple connection tester.
class ConnectivityTester
  include ActiveModel::Model

  attr_accessor :targets

  def initialize(targets)
    self.targets = targets
  end

  # Uses `targets` attribute and tries to open a TCP connection on each Target
  # on port 3000. If successful, the Target's `reachable` attribute
  # is set to true; otherwise set `reachable` to false.
  # @returns [Array<Target>]          Targets with `reachable` attrs updated
  def ping
    results = []
    EM.run do

      foreach = proc do |target, iter|
        resp = EM::Protocols::TcpConnectTester.test(target[:address],
                                                    Target::PORT_NUMBER)
        resp.callback do |_|
          resp.close_connection

          target.reachable = true
          iter.return(target)
        end

        resp.errback do |_|
          # TcpConnectTester doesn't close connection on failed connection
          resp.close_connection

          target.reachable = false
          iter.return(target)
        end

        # Assume all Targets that are online will respond quickly
        resp.timeout(0.5)
      end

      after = proc do |result|
        results = result
        EM.stop_event_loop
      end

      # Concurrency value of 160 seemed to be the limit for my machine
      # before too many file descriptors were opened. OSX defaults to
      # a max of 256 open file descriptors.
      EM::Iterator.new(self.targets, 160).map(foreach, after)
    end

    results
  end
end
