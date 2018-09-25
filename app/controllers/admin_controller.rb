class AdminController < ApplicationController
    
    def index
        @regions = Region.all
    end
    
end
