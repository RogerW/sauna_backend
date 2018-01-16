class AddressesController < ApplicationController
  def search
    street_string = params[:street]
    city_string = params[:city]

    streets = Sauna.find_by_sql(['SELECT fstf_AddressObjects_SearchByName(?, NULL, ?) as addr', street_string, city_string])

    render json: Oj.dump(
      collection: streets
    )
  end
end
