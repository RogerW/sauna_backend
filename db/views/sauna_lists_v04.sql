SELECT saunas.id,
    max(billings.cost_cents) AS max_cost_cents,
    min(billings.cost_cents) AS min_cost_cents,
    saunas.name,
    saunas.logotype_file_name,
    saunas.logotype_content_type,
    saunas.logotype_file_size,
    saunas.logotype_updated_at,
    saunas.rating,
    cities.name AS city,
    countries.name AS country,
    city_areas.name as city_area,
    addresses.street,
    addresses.house,
    addresses.lat,
    addresses.lon,
    addresses.notes
   FROM billings
     JOIN saunas ON saunas.id = billings.sauna_id
     JOIN addresses ON addresses.id = saunas.address_id
     JOIN city_areas ON city_areas.id = addresses.city_area_id
     JOIN cities ON cities.id = city_areas.city_id
     JOIN countries ON countries.id = cities.country_id
     
  GROUP BY saunas.id, cities.name, city_areas.name, countries.name, addresses.street, addresses.house, addresses.lat, addresses.lon, addresses.notes
  ORDER BY saunas.name;