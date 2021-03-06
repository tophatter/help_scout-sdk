# frozen_string_literal: true

module HelpScout
  class User < HelpScout::Base
    extend Getable
    extend Listable

    BASIC_ATTRIBUTES = %i[
      id
      first_name
      last_name
      email
      created_at
      updated_at
      role
      timezone
      type
      photoUrl
    ].freeze

    attr_reader(*BASIC_ATTRIBUTES)
    attr_reader :hrefs

    def initialize(params = {})
      BASIC_ATTRIBUTES.each do |attribute|
        next unless params[attribute]

        instance_variable_set("@#{attribute}", params[attribute])
      end

      @hrefs = HelpScout::Util.map_links(params[:_links])
    end
  end
end
