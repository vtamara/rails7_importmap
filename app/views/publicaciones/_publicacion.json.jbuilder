json.extract! publicacion, :id, :titulo, :contenido, :created_at, :updated_at
json.url publicacion_url(publicacion, format: :json)
