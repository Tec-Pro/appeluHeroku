class Shift < ActiveRecord::Base
  belongs_to :user
  belongs_to :service

  before_create :set_active
  
  STATUS_EXPIRED = "expired"
  STATUS_ACTIVE = "active"
  STATUS_ERROR = "error"
  STATUS_RESERVED = "reserved"

  def set_active
  	self.status = STATUS_ACTIVE
  end
end
