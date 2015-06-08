RSpec.configure do |config|
  config.around :each, :js do |example|
    Headless.ly do
      example.run
    end
  end
end
