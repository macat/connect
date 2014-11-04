class SessionBackdoor
  def initialize(app)
    @app = app
  end

  def call(env)
    sign_in(env)
    app.call(env)
  end

  private

  attr_reader :app

  def sign_in(env)
    params = Rack::Utils.parse_query(env["QUERY_STRING"])
    user_id = params["as"]
    if user_id.present?
      env["rack.session"][:current_user_id] = user_id
    end
  end
end
