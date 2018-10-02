class ProblemsController < ApplicationController

    def index
        @rock = Rock.find(params[:rock_id])
    end

    def create
        Rock.find(params[:problem][:rock_id]).problems.create(name: params[:problem][:name], grade: params[:problem][:grade].to_i)
        @rock = Rock.find(params[:problem][:rock_id])
        render 'index'
    end

    def update
        @rock = Problem.find(params[:id]).rock
        Problem.find(params[:id]).update(name: params[:problem][:name], grade: params[:problem][:grade].to_i)
        render 'index'
    end

    def destroy
        @rock = Problem.find(params[:id]).rock
        Problem.find(params[:id]).destroy
        render 'index'
    end


end
