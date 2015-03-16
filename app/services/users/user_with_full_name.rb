module Users
  class UserWithFullName < SimpleDelegator
    def full_name
      [first_name, last_name].compact.join(" ")
    end
  end
end
