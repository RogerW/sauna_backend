SELECT
	"saunas"."id" AS id, 
	MAX("billings"."cost_cents") AS max_cost_cents, 
	MIN("billings"."cost_cents") AS min_cost_cents, 
	"saunas"."name" AS name, 
	"saunas"."logo" AS logo, 
	"saunas"."rating" AS rating, 
	"cities"."name" AS city, 
	"countries"."name" AS country, 
	"addresses"."street" AS street, 
	"addresses"."house" AS house, 
	"addresses"."lat" AS lat, 
	"addresses"."lon" AS lon, 
	"addresses"."notes" AS notes
FROM "billings" 
INNER JOIN "saunas" ON "saunas"."id" = "billings"."sauna_id" 
INNER JOIN "cities" ON "cities"."id" = "saunas"."city_id" 
INNER JOIN "countries" ON "countries"."id" = "cities"."country_id" 
INNER JOIN "addresses" ON "addresses"."id" = "saunas"."address_id" 
GROUP BY 
  "saunas"."id", 
  "cities"."name", 
  "countries"."name", 
  "addresses"."street", 
  "addresses"."house", 
  "addresses"."lat", 
  "addresses"."lon", 
  "addresses"."notes" 
ORDER BY "saunas"."name" ASC