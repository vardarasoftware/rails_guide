class PersonTwo
  include ActiveModel::Dirty

  attr_reader :first_name, :last_name
  define_attribute_methods :first_name, :last_name

  def initialize
    @first_name = nil
    @last_name = nil
  end

  def first_name=(value)
    first_name_will_change! unless value == @first_name
    @first_name = value
  end

  def last_name=(value)
    last_name_will_change! unless value == @last_name
    @last_name = value
  end

  def save
    # Persist data - clears dirty data and moves `changes` to `previous_changes`.
    changes_applied
  end

  def reload!
    # Clears all dirty data: current changes and previous changes.
    clear_changes_information
  end

  def rollback!
    # Restores all previous data of the provided attributes.
    restore_attributes
  end
end
