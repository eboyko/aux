# frozen_string_literal: true

require 'active_model'
require 'active_support'
require 'aux/validations/error'
require 'aux/validations/errors'
require 'aux/validations/error_handler'

module Aux
  # Describes enhancement of {::ActiveModel::Validations}
  module Validations
    extend ActiveSupport::Concern
    include ActiveModel::Validations

    # @return [Aux::Validations::Errors]
    def errors
      @errors ||= Aux::Validations::Errors.new(self)
    end
  end
end
