# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

address = Sauna.connection.select_all("select fsfn_AddressObjects_TreeActualName('9764a4dd-c5cf-4c1b-802d-6ecafa9d9fb7') as full_address").first

user = User.create(email: 'stanislav.vorobev@cityprice.club', password: 'changeme123!', confirmed_at: Time.now)

sauna = Sauna.create(full_address: address['full_address'] + ', 10', name: 'ParParPar', street_uuid: '9764a4dd-c5cf-4c1b-802d-6ecafa9d9fb7', house: '10', city_uuid: 'dce97bff-deb2-4fd9-9aec-4f4327bbf89b')

user.saunas << sauna

sauna.create_sauna_description(description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque eget cursus est. Cras in aliquet lorem. Quisque tempus tincidunt neque, vel placerat ipsum placerat quis. Etiam bibendum, dui non tristique pharetra, dolor eros ornare velit, id auctor eros metus in arcu. Curabitur neque ante, suscipit luctus ultricies dictum, fermentum at justo. Ut auctor porttitor semper. Phasellus volutpat mattis egestas. Praesent interdum, augue id tincidunt rhoncus, nibh libero tristique turpis, quis venenatis tellus ex et ipsum. Donec euismod dolor eget tempus scelerisque. Aliquam luctus nibh sed erat tempor blandit. Ut interdum lacinia molestie. Nullam aliquet lobortis semper.')

sauna.billings.create(cost_cents: 100_000, start_time: 0, end_time: 6)
sauna.billings.create(cost_cents: 200_000, start_time: 6, end_time: 22)
sauna.billings.create(cost_cents: 150_000, start_time: 22, end_time: 24)

# UsersSauna.create(user_id: user.id, sauna_id: sauna.id)
