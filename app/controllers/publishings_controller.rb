class PublishingsController < ApplicationController
  before_action :authenticate_user!

  def update
    campaign = current_user.campaigns.find(params[:campaign_id])
    campaign.publish!
    redirect_to campaign_path(campaign), notice: "Campaign has been published!"
  end
end
