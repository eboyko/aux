# frozen_string_literal: true

require 'aux/carriers'

class CarrierableService
  include Aux::Carriers

  def general_success
    success
  end

  def success_with_code(code)
    success(code)
  end

  def success_with_payload(payload)
    success(payload)
  end

  def success_with_code_and_payload(code, payload)
    success(code, payload)
  end

  def general_failure
    failure
  end

  def failure_with_code(code)
    failure(code)
  end

  def failure_with_details(details)
    failure(details)
  end

  def failure_with_code_and_details(code, details)
    failure(code, details)
  end

  def failure_with_code_details_and_payload(code, details, payload)
    failure(code, details, payload)
  end
end
