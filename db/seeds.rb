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

Area.create(region_id: Region.find_by(name: '関東').id,     name: '御岳'    )
Area.create(region_id: Region.find_by(name: '関東').id,     name: '幕岩'    )
Area.create(region_id: Region.find_by(name: '甲信').id,     name: '小川山'  )

Rock.create(area_id: Area.find_by(name: '御岳').id,         name: '忍者返しの岩'        )
Rock.create(area_id: Area.find_by(name: '御岳').id,         name: 'ロッキーボルダー'        )
Rock.create(area_id: Area.find_by(name: '幕岩').id,         name: ''        )
Rock.create(area_id: Area.find_by(name: '幕岩').id,         name: ''        )
Rock.create(area_id: Area.find_by(name: '小川山').id,       name: ''        )
Rock.create(area_id: Area.find_by(name: '小川山').id,       name: ''        )

Problem.create(name: '忍者返し', rock_id: Area.find_by(name: '忍者返しの岩').id )
Problem.create(name: 'クライマー返し', rock_id: Area.find_by(name: '忍者返しの岩').id )
Problem.create(name: 'もぐライダー', rock_id: Area.find_by(name: 'ロッキーボルダー').id )
