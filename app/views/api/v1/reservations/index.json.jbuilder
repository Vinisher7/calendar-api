json.data @reservation do |reservation|
  json.partial "api/v1/reservation/reservation", reservation:
end
