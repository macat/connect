class NamelyImporter
  def self.import(*args)
    new(*args).import
  end

  def initialize(
    namely_connection:,
    attribute_mapper:,
    duplicate_filter: NamelyDuplicateFilter
  )
    @namely_connection = namely_connection
    @attribute_mapper = attribute_mapper
    @duplicate_filter = duplicate_filter
  end

  def import(recent_hires)
    result = ImportResult.new(attribute_mapper)
    unique_recent_hires(recent_hires).inject(result) do |status, recent_hire|
      status[recent_hire] = try_importing(attribute_mapper.call(recent_hire))
      status
    end
  end

  private

  attr_reader :namely_connection, :attribute_mapper, :duplicate_filter

  def try_importing(attrs)
    if valid_attributes?(attrs)
      begin
        namely_profiles.create!(attrs)
        I18n.t("status.success")
      rescue Namely::FailedRequestError => e
        I18n.t("status.namely_error", message: e.message)
      end
    else
      I18n.t("status.missing_required_field")
    end
  end

  def unique_recent_hires(recent_hires)
    duplicate_filter.filter(
      recent_hires,
      namely_connection: namely_connection,
      attribute_mapper: attribute_mapper,
    )
  end

  def namely_profiles
    namely_connection.profiles
  end

  def valid_attributes?(attrs)
    attrs[:email].present?
  end
end
