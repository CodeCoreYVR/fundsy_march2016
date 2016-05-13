class CampaignsController < ApplicationController
  before_action :find_campaign, only: [:show, :edit, :update, :destroy]

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = Campaign.new(campaign_params)
    if @campaign.save
      redirect_to campaign_path(@campaign), notice: "Campaign created!"
    else
      flash[:alert] = "Problem!"
      render :new
    end
  end

  def show
  end

  def index
    @campaigns = Campaign.order(:created_at)
    respond_to do |format|
      format.json { render json: @campaigns.to_json }
      format.html { render }
    end
  end

  def edit
  end

  def update
    if @campaign.update campaign_params
      redirect_to campaign_path(@campaign), notice: "Updated!"
    else
      render :edit
    end
  end

  def destroy
    @campaign.destroy
    redirect_to campaigns_path, notice: "Deleted!"
  end

  private

  def find_campaign
    @campaign = Campaign.find params[:id]
  end

  def campaign_params
    params.require(:campaign).permit(:title, :body, :goal, :end_date, :address)
  end
end
