# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

User.create(name: 'admin', email:'admin@climbmania.jp', password: 'yamashitayuji', admin: true)

CSV.foreach('db/climbmania_db.csv', headers: true, encoding: "Shift_JIS:UTF-8") do |record|
    Region.create(name: record['region'])  
    
    region = Region.find_by(name: record['region'])
    if region.present?
        region.areas.create(name: record['area'])
    end
    
    area = Area.find_by(name: record['area'])
    if area.present?
        area.rocks.create(name: record['rock'])
    end
    
    rock = Rock.find_by(name: record['rock'])
    if rock.present?
        rock.problems.create(name: record['problem'], grade: record['grade'])
    end
end




