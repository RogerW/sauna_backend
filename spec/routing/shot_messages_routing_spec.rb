require "rails_helper"

RSpec.describe ShotMessagesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/shot_messages").to route_to("shot_messages#index")
    end


    it "routes to #show" do
      expect(:get => "/shot_messages/1").to route_to("shot_messages#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/shot_messages").to route_to("shot_messages#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/shot_messages/1").to route_to("shot_messages#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/shot_messages/1").to route_to("shot_messages#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/shot_messages/1").to route_to("shot_messages#destroy", :id => "1")
    end

  end
end
