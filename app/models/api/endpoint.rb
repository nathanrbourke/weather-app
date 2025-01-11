module Api
  class Endpoint
    def initialize(api, method, route, query)
      @api = api
      @method = method
      @route = route
      @query = query
    end

    def call
      @api.send(@method.downcase, @route, query: @query)
    end
  end
end
