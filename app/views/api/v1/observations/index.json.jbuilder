json.data @observations do |observation|
  json.partial! "api/v1/observations/observation", observation:
end