class AddressesController < ApplicationController
  def search
    street_string = params[:street]
    city_string = params[:city]

    streets = Sauna.find_by_sql(['SELECT fstf_AddressObjects_SearchByName(?, NULL, ?) as addr', street_string, city_string])

    render json: Oj.dump(
      collection: streets
    )
  end

  def search_city
    city_string = params[:city]

    city_table =  Arel::Table.new(:addrobj)

    cities = Addrobj.select(
      city_table[:aoguid],
      city_table[:aoid],
      city_table[:formalname],
      city_table[:shortname]
    ).where(city_table[:formalname].matches("%#{city_string}%")
     .and(city_table[:shortname].in(['г.', 'мкр.', 'п.', 'волость.', 'г', 'мкр', 'п', 'волость'])))

    render json: Oj.dump(
      collection: cities
    )
  end

  def full_address
    street = Sauna.find_by_sql(['SELECT fsfn_addressobjects_treeactualname(?) as addr', params[:street_uuid]])

    render json: Oj.dump(
      collection: street
    )
  end
end
