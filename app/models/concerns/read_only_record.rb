module ReadOnlyRecord
  extend ActiveSupport::Concern

  included do
    attr_readonly(*column_names)  # Required to block update_attribute and update_column
  end

  def readonly?
    true
  end

  def destroy
    raise ActiveRecord::ReadOnlyRecord
  end

  def delete
    raise ActiveRecord::ReadOnlyRecord
  end
end
