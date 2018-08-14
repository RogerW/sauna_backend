require "rails_helper"

RSpec.describe ShotMessagesTokensController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/shot_messages_tokens").to route_to("shot_messages_tokens#index")
    end


    it "routes to #show" do
      expect(:get => "/shot_messages_tokens/1").to route_to("shot_messages_tokens#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/shot_messages_tokens").to route_to("shot_messages_tokens#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/shot_messages_tokens/1").to route_to("shot_messages_tokens#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/shot_messages_tokens/1").to route_to("shot_messages_tokens#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/shot_messages_tokens/1").to route_to("shot_messages_tokens#destroy", :id => "1")
    end

  end
end
