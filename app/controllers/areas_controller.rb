class AreasController < ApplicationController

  def index
    @region = Region.find(params[:region_id])
  end

  def create
    Region.find(params[:area][:region_id]).areas.create(name: params[:area][:name], other_names:params[:area][:other_names])
    @region = Region.find(params[:area][:region_id])
    render 'index'
  end

  def update
    @region = Area.find(params[:id]).region
    Area.find(params[:id]).update(name: params[:area][:name], other_names:params[:area][:other_names])
    render 'index'
  end

  def destroy
    @region = Area.find(params[:id]).region
    Area.find(params[:id]).destroy
    render 'index'
  end

end
