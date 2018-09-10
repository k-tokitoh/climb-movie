# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Region.create(name: '北海道')
Region.create(name: '東北')
Region.create(name: '関東')
Region.create(name: '甲信')
Region.create(name: '東海')
Region.create(name: '関西')
Region.create(name: '中国')
Region.create(name: '四国')
Region.create(name: '九州')

Area.create(name: '塩原', region_id: Region.find_by(name: '関東').id )
Area.create(name: '御岳', region_id: Region.find_by(name: '関東').id )
Area.create(name: '天皇岩', region_id: Region.find_by(name: '関東').id )
Area.create(name: '幕岩', region_id: Region.find_by(name: '関東').id )
Area.create(name: '小川山', region_id: Region.find_by(name: '甲信').id )
Area.create(name: '瑞牆山', region_id: Region.find_by(name: '甲信').id )
