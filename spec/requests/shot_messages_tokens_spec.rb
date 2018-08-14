require 'rails_helper'

RSpec.describe "ShotMessagesTokens", type: :request do
  describe "GET /shot_messages_tokens" do
    it "works! (now write some real specs)" do
      get shot_messages_tokens_path
      expect(response).to have_http_status(200)
    end
  end
end
