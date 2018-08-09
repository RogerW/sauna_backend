require 'json'

class CreateShopTemplate < ActiveRecord::Migration[5.1]
  def up
    create_table :shop_templates do |t|
      t.string :type_tmpl
      t.json :template
    end

    source = File.new("#{Rails.root}/db/sauna_template.json", 'r')
    template = ''

    while (line = source.gets)
      template << line
    end

    source.close

    # template = template.gsub(/[\n\s]/, '')
    template = JSON.parse(template)
    execute "INSERT INTO shop_templates(type_tmpl, template) VALUES('sauna', '#{template.to_json}'::json);"
    # end
  end

  def down
    drop_table :shop_templates
  end
end
