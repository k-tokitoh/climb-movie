class SearchController < ApplicationController
    
    def suggest_areas
        @region = Region.find(params[:region_id])
        records = Area.joins(rocks:{problems: :posts}).select('areas.id as area_id, posts.approved as approved')
        @posts_num_by_area = records.where(posts: {approved: 'OK'}).group_by{|record| record.area_id}.map{|k,v|[k,v.size]}.to_h
    end
    
    def suggest_problems
        @area = Area.find(params[:area_id])
        # それぞれの課題に紐づいた動画の数をハッシュとして用意しておく
        records = Problem.joins(:posts).select('problems.id as problem_id, posts.approved as approved')
        @posts_num_by_problem = records.where(posts: {approved: 'OK'}).group_by{|record| record.problem_id}.map{|k,v|[k,v.size]}.to_h 
    end
    
end
