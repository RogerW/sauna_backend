SELECT 
  reservations.id,
  reservations.id as reservation_id,
  reservations.user_id,
  reservations.aasm_state as state,
  lower(reservations.reserv_range) as start_date_time,
  upper(reservations.reserv_range) as end_date_time,
  reservations.guests_num, 
  saunas.id as sauna_id,
  saunas.name,
  saunas.full_address
FROM 
  public.reservations
  LEFT OUTER JOIN public.saunas ON saunas.id = reservations.sauna_id
  LEFT OUTER JOIN public.users_saunas ON users_saunas.sauna_id = saunas.id;