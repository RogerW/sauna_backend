class AddressesController < ApplicationController
  def search
    street_string = params[:street]
    city_string = params[:city]

    streets = Sauna.find_by_sql(['SELECT fstf_AddressObjects_SearchByName(?, NULL, ?) as addr', street_string, city_string])

    render json: Oj.dump(
      collection: streets
    )
  end

  def full_address
    street = Sauna.find_by_sql(['SELECT fsfn_addressobjects_treeactualname(?) as addr', params[:street_uuid]])

    render json: Oj.dump(
      collection: street
    )
  end
end
