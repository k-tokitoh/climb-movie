class SearchController < ApplicationController
    
    def suggest_areas
        @region = Region.find(params[:region_id])
    end
    
    def suggest_problems
        @area = Area.find(params[:area_id])
        # @posts_num_by_problem = Problem.joins(:posts).where(id: @area)
    end
    
end
