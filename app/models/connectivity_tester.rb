# A simple TCP connection tester.
class ConnectivityTester
  include ActiveModel::Model

  attr_accessor :targets, :results, :port

  # Assume these web apps are running on default rails port, 3000
  DEFAULT_PORT_NUMBER = 3000

  def initialize(targets, custom_port=nil)
    self.targets = targets
    self.port = custom_port || DEFAULT_PORT_NUMBER
  end

  # Uses `targets` attribute and tries to open a TCP connection on each Target
  # on the port specified in the initializer, or port 3000 by default.
  # If successful, the Target's `reachable` attribute is set to true;
  # otherwise `reachable` is set to false;
  # @returns [Array<Target>]          Targets with `reachable` attrs updated
  def ping
    EM.run do
      # Using numbers over 800 for the concurrency value seems to crash
      # the ruby interpreter eventually. 800 so far has been the best value
      # to use for a good combination of stability and speed in my testing.
      EM::Iterator.new(self.targets, 800).map(foreach, after)
    end

    @results
  end

  private

  # Returns a Proc that creates a TCP connection to a Target using
  # EM::Protocols::TcpConnectTester.test. The request will timeout
  # if no response is received in 500ms, and set the Target's reachable
  # attribute to false. If a response is received, the Target's reachable
  # attribute is set to true.
  def foreach
    proc do |target, iter|
      resp = EM::Protocols::TcpConnectTester.test(target[:address], @port)
      resp.callback do |_|
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
  end

  # Returns a Proc that sets the current ConnectivityTester's results
  # attribute to the results from the `foreach` method above.
  # The EventMachine event loop is also stopped here.
  def after
    proc do |result|
      @results = result
      EM.stop_event_loop
    end
  end
end
