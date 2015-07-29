class Profile
  delegate :[], to: :namely_profile
  delegate :update, to: :namely_profile

  def initialize(namely_profile)
    @namely_profile = namely_profile
  end

  def name
    "#{namely_profile[:first_name]} #{namely_profile[:last_name]}"
  end

  private

  attr_reader :namely_profile
end
