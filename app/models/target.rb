class Target < ActiveRecord::Base
  belongs_to :appliance

  validates :appliance_id, presence:   true

  validates :hostname,     presence:   true,
                           uniqueness: true

  validates :address,      presence:   true,
                           format:     { with: Resolv::IPv4::Regex }

  attr_accessor :reachable

  # Assume these web apps are running on default rails port, 3000
  PORT_NUMBER = 3000

  def connectivity_status
    reachable ? 'Online' : 'Offline'
  end
end
