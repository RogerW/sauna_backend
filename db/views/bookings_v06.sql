SELECT 
  reservations.id,
  to_char(lower(reservations.reserv_range), 'YYYY-MM-DD HH24:MI:ss') as start_date_time,
  to_char(upper(reservations.reserv_range), 'YYYY-MM-DD HH24:MI:ss') as end_date_time,
  reservations.guests_num, 
  reservations.status,
  contacts.id as contact_id,
  contacts.first_name, 
  contacts.middle_name, 
  contacts.last_name, 
  contacts.phone, 
  contacts.created_at, 
  contacts.updated_at,   
  users_saunas.user_id,
  saunas.id as sauna_id
FROM 
  public.reservations
  LEFT OUTER JOIN public.saunas ON saunas.id = reservations.sauna_id
  LEFT OUTER JOIN public.users_saunas ON users_saunas.sauna_id = saunas.id
  LEFT OUTER JOIN public.contacts ON reservations.contact_id = contacts.id
