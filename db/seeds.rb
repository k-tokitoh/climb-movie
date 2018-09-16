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
    if Region.find_by(name: record['region']).present?
        Region.find_by(name: record['region']).areas.create(name: record['area'])
    end
    if Area.find_by(name: record['area']).present?
        Area.find_by(name: record['area']).rocks.create(name: record['rock'])
    end
    if Rock.find_by(name: record['rock']).present?
        Rock.find_by(name: record['rock']).problems.create(name: record['problem'], grade: record['grade'])
    end
end

# workbook = Spreadsheet.open("db/climbmania_db.xls") 
# worksheet = workbook.worksheet('sheet1')

# wb = RubyXL::Parser.parse "db/climbmania_db.xls"
# ws = workbook[0].extract_data({})
# seeds = worksheet.get_table(headers)[:table]


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
Rock.create(area_id: Area.find_by(name: '幕岩').id,         name: 'サンセットボルダー'        )
Rock.create(area_id: Area.find_by(name: '幕岩').id,         name: '貝殻岩'        )
Rock.create(area_id: Area.find_by(name: '小川山').id,       name: 'クジラ岩'        )
Rock.create(area_id: Area.find_by(name: '小川山').id,       name: 'ギガント'        )

Problem.create(name: '忍者返し', grade:'1級', rock_id: Rock.find_by(name: '忍者返しの岩').id )
Problem.create(name: 'クライマー返し', grade:'初段', rock_id: Rock.find_by(name: '忍者返しの岩').id )
Problem.create(name: 'エゴイスト', grade:'初段', rock_id: Rock.find_by(name: 'ロッキーボルダー').id )
Problem.create(name: '炎', grade:'初段', rock_id: Rock.find_by(name: 'ロッキーボルダー').id )
Problem.create(name: 'ファンタジスタ', grade:'二段', rock_id: Rock.find_by(name: 'サンセットボルダー').id )
Problem.create(name: 'サンセットダディ', grade:'1級', rock_id: Rock.find_by(name: 'サンセットボルダー').id )
Problem.create(name: '貴船', grade:'初段', rock_id: Rock.find_by(name: '貝殻岩').id )
Problem.create(name: 'ジャッキアップ', grade:'2級', rock_id: Rock.find_by(name: '貝殻岩').id )
Problem.create(name: 'エイハブ船長', grade:'1級', rock_id: Rock.find_by(name: 'クジラ岩').id )
Problem.create(name: '穴社長', grade:'二段', rock_id: Rock.find_by(name: 'クジラ岩').id )

Problem.find_by(name: '忍者返し').posts.create(video: 'QhMLI12ceqg')
Problem.find_by(name: '忍者返し').posts.create(video: 'N9GFwZ1e3Do')
Problem.find_by(name: 'クライマー返し').posts.create(video: 'ASXZWpC8MlU')
Problem.find_by(name: 'クライマー返し').posts.create(video: '5kBoIcRD4HU')
Problem.find_by(name: 'エゴイスト').posts.create(video: 'zx3Z2dFHinw')
Problem.find_by(name: 'エゴイスト').posts.create(video: 'qTjC-x5UT88')
Problem.find_by(name: '炎').posts.create(video: 'dP6vJOxtbAY')
Problem.find_by(name: '炎').posts.create(video: 'RgxCtrrEsc0')
Problem.find_by(name: 'ファンタジスタ').posts.create(video: 'wkH4X8r6YB4')
Problem.find_by(name: 'ファンタジスタ').posts.create(video: 'DMu-TSHSQQ8')
Problem.find_by(name: 'サンセットダディ').posts.create(video: 'hAweZHcwOp4')
Problem.find_by(name: 'サンセットダディ').posts.create(video: 'lrTrh1AHBQw')
Problem.find_by(name: '貴船').posts.create(video: 'oX31gzxL_Tg')
Problem.find_by(name: '貴船').posts.create(video: 'wLz9NhgXOP8')
Problem.find_by(name: 'ジャッキアップ').posts.create(video: 'dCzcnjIiw3E')
Problem.find_by(name: 'ジャッキアップ').posts.create(video: 'LBsGeDTKEjk')
Problem.find_by(name: 'エイハブ船長').posts.create(video: 'dY_rmawNv2k')
Problem.find_by(name: 'エイハブ船長').posts.create(video: 'eB_Y_E-JBY8')
Problem.find_by(name: '穴社長').posts.create(video: '7bD4lcdb7eU')
Problem.find_by(name: '穴社長').posts.create(video: 'ENT6A0BYtTo')





