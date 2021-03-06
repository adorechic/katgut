module Katgut
  class RulesController < ApplicationController
    def show
      @rule = Rule.active.find_by!(source: params[:id])
      redirect_to @rule.regular_destination
    rescue => e
      redirect_to Katgut.config.fall_back_path
    ensure
      after_redirection_callback
    end

    private

    def after_redirection_callback
      cb = Katgut.config.after_redirection_callback
      return unless cb

      instance_exec(request, params, @rule, &cb)
    end
  end
end
