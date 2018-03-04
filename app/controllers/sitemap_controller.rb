class SitemapController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    @saunas = Sauna.all

    url = []

    url.push 'https://cityprice.club/sauna/list'
    url.push 'https://cityprice.club/about'

    @saunas.each do |sauna|
      url.push "https://cityprice.club/sauna/description/#{sauna.id}"
    end

    out_map_string = '<?xml version="1.0" encoding="UTF-8"?><urlset xmlns="https://www.sitemaps.org/schemas/sitemap/0.9">'

    url.each do |u|
      out_map_string += "<url><loc>#{u}</loc></url>"
    end

    out_map_string += '</urlset>'
    render xml: out_map_string
  end
end
