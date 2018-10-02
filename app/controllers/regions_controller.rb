class RegionsController < ApplicationController

    def index
        @regions = Region.all 
    end

    def create
        Region.create(name: params[:region][:name])
        redirect_to '/admin'
    end

    def update
        Region.find(params[:id]).update(name: params[:region][:name])
        redirect_to '/admin'
    end

    def destroy
        Region.find(params[:id]).destroy
        redirect_to '/admin'
    end
    
end
