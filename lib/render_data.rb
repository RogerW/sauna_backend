module RenderData

  def RenderData.render_data(data, *payload)
    Oj.dump(collection: (data))
  end

end