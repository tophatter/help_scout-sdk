# frozen_string_literal: true

module HelpScout
  module Listable
    def list(id: HelpScout.default_mailbox, query:)
      HelpScout.api.get(list_path(id), query).embedded_list.map { |e| new e }
    end

    def list_path(_)
      base_path
    end
  end
end
