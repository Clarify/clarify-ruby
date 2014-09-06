require 'httparty'

module Clarify
  class Bundle

    include HTTParty
    base_uri "https://api.clarify.io/"
    format :json

    #for httparty debugging
    #debug_output
    
    def initialize(version = 1)
      @version = "v#{version}"
      @auth_key = ENV['CLARIFY_API_KEY']
    end

    def create(query = {})
      response = self.class.post("/#{@version}/bundles",
                                 query: query,
                                 headers: headers)
      build_response(response)
    end

    def find(bundle_id=nil, embed="")
      raise ArgumentError, "Missing bundle id" if bundle_id.nil?
      response = self.class.get("/#{@version}/bundles/#{bundle_id}?embed=#{embed}", headers: headers)
      build_response(response)
    end

    def find_all(args = {})
      response = self.class.get("/#{@version}/bundles", headers: headers)
      build_response(response)
    end

    def delete(bundle_id)
      response = self.class.delete("/#{@version}/bundles/#{bundle_id}", headers: headers)
      build_response(response)
    end

    def update(bundle_id, query = {})
      response = self.class.put("/#{@version}/bundles/#{bundle_id}",
                                body: query, headers: headers)
      build_response(response)
    end
    
    private

    def headers
      {"Authorization" => "Bearer #{@auth_key}"}
    end

    def build_response(response)
      if response.code != 204  #http code for no content
        body = response.parsed_response# => JSON.parse(response.parsed_response, symbolize_names: true)
      else
        body = "" 
      end
      Response.new(response.code, body)
    end
  end
end

