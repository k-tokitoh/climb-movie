class SearchController < ApplicationController
    
    def suggest_areas
        @region = Region.find(params[:region_id])
    end
    
    def suggest_problems
        @area = Area.find(params[:area_id])
    end
    
end
