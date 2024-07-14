p "Start area seeds"

Area.find_by_name('1946 Project').destroy if Area.find_by_name('1946 Project')
Area.find_by_name('Anime').destroy if Area.find_by_name('Anime')
Area.find_by_name('Art').destroy if Area.find_by_name('Art')
Area.find_by_name('Childrens Program').destroy if Area.find_by_name('Childrens Program')
Area.find_by_name('Comics').destroy if Area.find_by_name('Comics')
Area.find_by_name('Costuming & Cosplay').destroy if Area.find_by_name('Costuming & Cosplay')
Area.find_by_name('Events').destroy if Area.find_by_name('Events')
Area.find_by_name('Fandom').destroy if Area.find_by_name('Fandom')
Area.find_by_name('Gaming Program').destroy if Area.find_by_name('Gaming Program')
Area.find_by_name('Literature').destroy if Area.find_by_name('Literature')
Area.find_by_name('Maker').destroy if Area.find_by_name('Maker')
Area.find_by_name('Media').destroy if Area.find_by_name('Media')
Area.find_by_name('Meetups').destroy if Area.find_by_name('Meetups')
Area.find_by_name('Music & Filk').destroy if Area.find_by_name('Music & Filk')
Area.find_by_name('Podcasting').destroy if Area.find_by_name('Podcasting')
Area.find_by_name('Polish SFF').destroy if Area.find_by_name('Polish SFF')
Area.find_by_name('Science & Technology').destroy if Area.find_by_name('Science & Technology')
Area.find_by_name('Society').destroy if Area.find_by_name('Society')
Area.find_by_name('Theater Program').destroy if Area.find_by_name('Theater Program')
Area.find_by_name('Virtual').destroy if Area.find_by_name('Virtual')
Area.find_by_name('Writing').destroy if Area.find_by_name('Writing')

Area.create!(name: 'Blok literacki', sort_order: 1) unless Area.find_by_name('Blok literacki')
Area.create!(name: 'Blok popkulturowy', sort_order: 2) unless Area.find_by_name('Blok popkulturowy')
Area.create!(name: 'Blok popularnonaukowy', sort_order: 3) unless Area.find_by_name('Blok popularnonaukowy')
Area.create!(name: 'Blok filmowy', sort_order: 4) unless Area.find_by_name('Blok filmowy')
Area.create!(name: 'Blok animacji', sort_order: 5) unless Area.find_by_name('Blok animacji')
Area.create!(name: 'Blok azjatycki', sort_order: 6) unless Area.find_by_name('Blok azjatycki')
Area.create!(name: 'Blok konkursowy', sort_order: 7) unless Area.find_by_name('Blok konkursowy')
Area.create!(name: 'Blok gier planszowych i karcianych', sort_order: 8) unless Area.find_by_name('Blok gier planszowych i karcianych')
Area.create!(name: 'Blok gier elektronicznych', sort_order: 9) unless Area.find_by_name('Blok gier elektronicznych')
Area.create!(name: 'Blok RPG', sort_order: 10) unless Area.find_by_name('Blok RPG')
Area.create!(name: 'Blok Sesji RPG', sort_order: 11) unless Area.find_by_name('Blok Sesji RPG')
Area.create!(name: 'Blok larpowy', sort_order: 12) unless Area.find_by_name('Blok larpowy')
Area.create!(name: 'Blok warsztatowy', sort_order: 13) unless Area.find_by_name('Blok warsztatowy')
Area.create!(name: 'Blok okołofestiwalowy', sort_order: 14) unless Area.find_by_name('Blok okołofestiwalowy')
Area.create!(name: 'Blok fandomowy', sort_order: 15) unless Area.find_by_name('Blok fandomowy')
Area.create!(name: 'Konferencja "CoperniConf 2024"', sort_order: 16) unless Area.find_by_name('Konferencja "CoperniConf 2024"')
Area.create!(name: 'Inne / nie wiem, gdzie zgłosić moją atrakcję', sort_order: 17) unless Area.find_by_name('Inne / nie wiem, gdzie zgłosić moją atrakcję')

p "End area seeds"
