# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

country = Country.create(name: 'Россия')
city = City.create(country: country, name: 'Оренбург')
address = Address.create(street: 'Пролетарская ул', house: '1', city: city)

sauna = Sauna.create(city: city, address: address, name: 'ParParPar')
SaunaDescription.create(sauna: sauna, description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque eget cursus est. Cras in aliquet lorem. Quisque tempus tincidunt neque, vel placerat ipsum placerat quis. Etiam bibendum, dui non tristique pharetra, dolor eros ornare velit, id auctor eros metus in arcu. Curabitur neque ante, suscipit luctus ultricies dictum, fermentum at justo. Ut auctor porttitor semper. Phasellus volutpat mattis egestas. Praesent interdum, augue id tincidunt rhoncus, nibh libero tristique turpis, quis venenatis tellus ex et ipsum. Donec euismod dolor eget tempus scelerisque. Aliquam luctus nibh sed erat tempor blandit. Ut interdum lacinia molestie. Nullam aliquet lobortis semper.')

Billing.create(cost_cents: 100_000, start_time: 0, end_time: 6, sauna: sauna)
Billing.create(cost_cents: 200_000, start_time: 6, end_time: 22, sauna: sauna)
Billing.create(cost_cents: 150_000, start_time: 22, end_time: 24, sauna: sauna)

Contact.create(first_name: 'Ivan', last_name: 'Drago', user_id: 1)

User.create(email: 'stanislav.vorobev@cityprice.club', password: 'changeme123!', confirmed_at: Time.now)
