class UserCheckNamelyField < SimpleDelegator
  def check?
    if namely_field_not_found? && namely_account_has_required_field?
      update(found_namely_field: true)
    end
    namely_field_not_found?
  end

  private

  def namely_field_not_found?
    !found_namely_field?
  end

  def namely_account_has_required_field?
    namely_connection.fields.all.detect do |field|
      field.name == required_namely_field
    end
  end

  def namely_connection
    user.namely_connection
  end
end
