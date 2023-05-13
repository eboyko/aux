# frozen_string_literal: true

require 'active_support'
require 'active_model/validations/validates'
require 'aux/validations/errors'

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
