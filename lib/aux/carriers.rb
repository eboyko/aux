# frozen_string_literal: true

require 'aux/carriers/success'
require 'aux/carriers/failure'

module Aux
  module Carriers
    private

    # @overload success
    #   @return [Success]
    # @overload success(code)
    #   @param code [Symbol]
    #   @return [Success]
    # @overload success(payload)
    #   @param payload [Object]
    #   @return [Success]
    # @overload success(code, payload)
    #   @param code [Symbol]
    #   @param payload [Object]
    #   @return [Success]
    def success(*arguments)
      case arguments
      in [Symbol] | [Symbol, Object]
        Success.new(*arguments)
      in [Object]
        Success.new(:ok, *arguments)
      else
        Success.new(:ok)
      end
    end

    # @overload failure
    #   @return [Failure]
    # @overload failure(code)
    #   @param code [Symbol]
    #   @return [Failure]
    # @overload failure(details)
    #   @param details [Object]
    #   @return [Failure]
    # @overload failure(code, details)
    #   @param code [Symbol]
    #   @param details [Object]
    #   @return [Failure]
    # @overload failure(code, details, payload)
    #   @param code [Symbol]
    #   @param details [Object]
    #   @param payload [Object]
    #   @return [Failure]
    def failure(*arguments)
      case arguments
      in [Symbol] | [Symbol, Object] | [Symbol, Object, Object]
        Failure.new(*arguments)
      else
        Failure.new(:internal_server_error, *arguments)
      end
    end
  end
end
