require 'rails_helper'

module Katgut
  describe RulesController do
    describe "GET /katgut/:id" do
      context "the destination url begin with '/'" do
        let!(:rule) { create(:rule, destination: "/katgut_success.html") }

        it "interprets the destination as a same origin path and redirects to the path" do
          get "/katgut/#{rule.source}"
          expect(response).to redirect_to(rule.destination)
        end
      end

      context "the destination url begin with scheme specification" do
        let!(:rule) { create(:rule, destination: "https://httpbin.org/") }

        it "interprets the destination as a FQDN and redirects to the url" do
          get "/katgut/#{rule.source}"
          expect(response).to redirect_to(rule.destination)
        end
      end

      context "the destination url begin without scheme specification" do
        let!(:rule) { create(:rule, destination: "httpbin.org/") }

        it "assumes that the scheme is http" do
          get "/katgut/#{rule.source}"
          expect(response).to redirect_to("http://#{rule.destination}")
        end
      end

      context "the source url is not found" do
        it "redirects to the fall back path" do
          get "/katgut/not-existing-source-keyword"
          expect(response).to redirect_to(Katgut.config.fall_back_path)
        end
      end

      context "appropriate rule exists, but not activated" do
        let!(:rule) { create(:rule, destination: "https://httpbin.org/", active: false) }

        it "redirects to the fall back path" do
          get "/katgut/#{rule.source}"
          expect(response).to redirect_to(Katgut.config.fall_back_path)
        end
      end
    end
  end
end
