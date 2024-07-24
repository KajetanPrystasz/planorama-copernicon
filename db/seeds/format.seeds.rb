p "Start format seeds"

Format.find_by_name('Panel').destroy if Format.find_by_name('Panel')
Format.find_by_name('Presentation').destroy if Format.find_by_name('Presentation')
Format.find_by_name('Workshop').destroy if Format.find_by_name('Workshop')
Format.find_by_name('Discussion').destroy if Format.find_by_name('Discussion')
Format.find_by_name('Interview').destroy if Format.find_by_name('Interview')
Format.find_by_name('Meetup').destroy if Format.find_by_name('Meetup')
Format.find_by_name('Other').destroy if Format.find_by_name('Other')

Format.create!(name: 'Prelekcja', position: 1) unless Format.find_by_name('Prelekcja')
Format.create!(name: 'Wykład konferencyjny', position: 2) unless Format.find_by_name('Wykład konferencyjny')
Format.create!(name: 'Konkurs', position: 3) unless Format.find_by_name('Konkurs')
Format.create!(name: 'Sesja RPG', position: 4) unless Format.find_by_name('Sesja RPG')
Format.create!(name: 'Larp', position: 5) unless Format.find_by_name('Larp')

p "End format seeds"
