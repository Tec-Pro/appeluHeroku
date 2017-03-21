class Business < ActiveRecord::Base
  belongs_to :user
  validates :name, presence: true
  validates :user, presence: true
  has_many :customerServiceDays
  has_many :services

  before_create :set_enable

  STATUS_ENABLE = "enabled"
  STATUS_DISABLE = "disabled"

  def set_enable
  	self.status = STATUS_ENABLE
  end	
end
	