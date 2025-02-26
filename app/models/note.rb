class Note
  include ActiveModel::Serialization
  attr_accessor :title, :text

  def attributes
    { "title" => nil, "text" => nil }
  end
end
