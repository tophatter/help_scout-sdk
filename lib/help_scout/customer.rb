# frozen_string_literal: true

module HelpScout
  class Customer < HelpScout::Base
    extend Getable
    extend Listable

    BASIC_ATTRIBUTES = %i[
      first_name
      last_name
      photo_url
      job_title
      photo_type
      background
      location
      created_at
      updated_at
      organization
      gender
      age
      id
    ].freeze
    EMBEDDED_ATTRIBUTES = %i[
      addresses
      chats
      emails
      phones
      social_profiles
      websites
    ].freeze
    attr_reader(*(BASIC_ATTRIBUTES + EMBEDDED_ATTRIBUTES))
    attr_reader :hrefs

    def initialize(params = {})
      BASIC_ATTRIBUTES.each do |attribute|
        next unless params[attribute]

        instance_variable_set("@#{attribute}", params[attribute])
      end

      embedded_params = params.fetch(:_embedded, {})
      EMBEDDED_ATTRIBUTES.each do |attribute|
        next unless embedded_params[attribute]

        instance_variable_set("@#{attribute}", embedded_params[attribute])
      end

      @hrefs = HelpScout::Util.map_links(params[:_links])
    end

    def update_properties(body)
      properties_path = URI.parse(hrefs[:self]).path + '/properties'
      HelpScout.api.patch(properties_path, body)
      true
    end

    def self.list_properties()
      properties_path = URI.parse(HelpScout::API::BASE_URL).path + '/customer-properties'
      HelpScout.api.get(properties_path).embedded_list.map { |e| new e }
    end
  end
end
