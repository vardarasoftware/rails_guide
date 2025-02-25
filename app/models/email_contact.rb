class EmailContact
  include ActiveModel::API
  
  attr_accessor :name, :email, :message
  validates :name, :email, :message, presence: true
  
  def deliver
    if valid?
      puts "Email sent to #{email}"
    true
    else
      puts "Validation failed. Email not sent."
    false
    end
  end
end
