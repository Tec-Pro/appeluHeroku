require 'bcrypt'

class User < ActiveRecord::Base
	include BCrypt

	validates :email, presence: true, email: true, uniqueness: true
	
	has_many :tokens
	has_many :businesses
	has_many :shifts


	before_create :set_enable

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

	def set_enable
		self.enable = true
	end	

	def self.from_omniauth(data)
		#Recibir hash de datos
		# { provider: 'google', uid: '12345', info: { email: 'uriel...', name: 'Uriel' }  }

		User.where(provider: data[:provider], uid: data[:uid]).first_or_create do |user|
			user.email = data[:info][:email]
		end

	end
end
