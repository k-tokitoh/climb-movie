class RocksController < ApplicationController

  def index
    @area = Area.find(params[:area_id])
  end

  def create
    Area.find(params[:rock][:area_id]).rocks.create(name: params[:rock][:name], other_names: params[:rock][:other_names])
    @area = Area.find(params[:rock][:area_id])
    render 'index'
  end

  def update
    @area = Rock.find(params[:id]).area
    Rock.find(params[:id]).update(name: params[:rock][:name], other_names: params[:rock][:other_names])
    render 'index'
  end

  def destroy
    @area = Rock.find(params[:id]).area
    Rock.find(params[:id]).destroy
    render 'index'
  end

end
