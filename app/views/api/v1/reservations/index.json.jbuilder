json.data @reservations do |reservation|
  json.partial! "api/v1/reservations/reservation", reservation:
end
