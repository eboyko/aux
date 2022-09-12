# frozen_string_literal: true

require 'aux/validations/errors'

module Aux
  # Describes enhancement of {ActiveModel::Validations}
  module Validations
    extend ActiveSupport::Concern
    include ActiveModel::Validations

    # @return [Aux::Validations::Errors]
    def errors
      @errors ||= Aux::Validations::Errors.new(self)
    end
  end
end
