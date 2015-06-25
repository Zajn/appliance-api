class Target < ActiveRecord::Base
  belongs_to :appliance

  validates :appliance_id, presence:   true

  validates :hostname,     presence:   true,
                           uniqueness: true

  validates :address,      presence:   true,
                           format:     { with: Resolv::IPv4::Regex }

  attr_accessor :reachable

  def connectivity_status
    reachable ? 'Reachable' : 'Unreachable'
  end
end
