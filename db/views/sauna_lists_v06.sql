SELECT saunas.id,
    max(billings.cost_cents) AS max_cost_cents,
    min(billings.cost_cents) AS min_cost_cents,
    saunas.name,
    saunas.logotype_file_name,
    saunas.logotype_content_type,
    saunas.logotype_file_size,
    saunas.logotype_updated_at,
    saunas.rating,
    saunas.full_address,
    saunas.city_uuid,
    saunas.street_uuid,
    saunas.note,
    saunas.lon,
    saunas.lat
   FROM billings
     JOIN saunas ON saunas.id = billings.sauna_id
     
  GROUP BY saunas.id
  ORDER BY saunas.name;