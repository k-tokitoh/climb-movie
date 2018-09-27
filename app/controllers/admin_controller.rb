class AdminController < ApplicationController
    
    def index
        @regions = Region.all
    end
   
    def create_region
        @region = Region.create(name: params[:region][:name])
        redirect_to '/admin'
    end
   
    def edit_region
        Region.find(params[:id]).update(name: params[:region][:name])
        redirect_to '/admin' 
    end
    
    def destroy_region
        Region.find(params[:id]).destroy
        redirect_to '/admin' 
    end
    
    def show_areas
        @region = Region.find(params[:id])
        render 'areas'
    end
    
    def create_area
        # byebug
        Region.find(params[:area][:region_id]).areas.create(name: params[:area][:name])
        redirect_to '/admin'
    end
   
    def edit_area
        Area.find(params[:id]).update(name: params[:area][:name])
        redirect_to '/admin' 
    end
    
    def destroy_area
        Area.find(params[:id]).destroy
        redirect_to '/admin' 
    end
    
    def show_rocks
        @area = Area.find(params[:id])
        render 'rocks'
    end
    
end
