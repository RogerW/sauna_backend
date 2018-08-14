require 'rails_helper'

RSpec.describe "ShotMessages", type: :request do
  describe "GET /shot_messages" do
    it "works! (now write some real specs)" do
      get shot_messages_path
      expect(response).to have_http_status(200)
    end
  end
end
