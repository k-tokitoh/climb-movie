# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

User.create(name: ENV['ADMIN_NAME'], email:ENV['ADMIN_EMAIL'], password: ENV['ADMIN_PASSWORD'], admin: true)

CSV.foreach('db/climbmania_db.csv', headers: true, encoding: "Shift_JIS:UTF-8") do |record|     #CSVを１行ずつ読みこむ

    #regionレコードを作成（nilだとvalidationで弾かれ、レコードは作成されない。以下同様。）
    Region.create(name: record['region'])               

    region = Region.find_by(name: record['region'])
    if region.present? 
        region.areas.create(name: record['area'])       #regionレコードを作成
    end

    area = Area.find_by(name: record['area'])
    if area.present?
        area.rocks.create(name: record['rock'])         #areaレコードを作成
    end

    rock = Rock.find_by(name: record['rock'])
    if rock.present?
        rock.problems.create(name: record['problem'], grade: record['grade'].to_i)       #problemレコードを作成
    end
end




