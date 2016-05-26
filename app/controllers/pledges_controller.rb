class PledgesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_campaign, only: [:create]

  def new
    @pledge = Pledge.new
  end

  def create
    @pledge = Pledge.new pledge_params
    @pledge.campaign = @campaign
    @pledge.user = current_user
    @pledge.save
    redirect_to campaign_path(@campaign), notice: "Thank you for your pledge!"
  end

  private
  def pledge_params
    params.require(:pledge).permit(:amount)
  end

  def find_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end
end
