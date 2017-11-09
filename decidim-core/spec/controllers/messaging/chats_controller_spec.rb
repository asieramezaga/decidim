# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe Messaging::ChatsController, type: :controller do
    routes { Decidim::Core::Engine.routes }

    let(:organization) { create(:organization) }
    let(:user) { create :user, :confirmed, organization: organization }

    let(:chat) do
      Messaging::Chat.start!(
        originator: user,
        interlocutors: [create(:user)],
        body: "Hi!"
      )
    end

    before do
      request.env["decidim.current_organization"] = organization
      sign_in user
    end

    describe "PUT update" do
      context "when invalid" do
        it "renders an error message" do
          put :update, format: :js, params: { id: chat.id, message: { body: "A" * 1001 } }

          expect(response.body).to include("Message not sent")
        end
      end
    end
  end
end