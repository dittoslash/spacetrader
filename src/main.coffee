game =
  shipname: "The Coriolian"
  location: 0

this_station = -> data.stations[game.location]

distance_to = (there) ->
  here = this_station()
  there = data.stations[there] unless there.name
  x1 = here.x
  x2 = there.x
  y1 = here.y
  y2 = there.y
  Math.round(Math.sqrt(Math.pow(x2-x1, 2) + Math.pow(y2-y1, 2))*100)/100

display_ship = ->
  $("#yourship").html "
  #{game.shipname}, your ship
  "

display_station = ->
  current_station = this_station()
  $("#thestation").html "
  Current station: #{current_station.name} <br />
  Location: #{current_station.x}x#{current_station.y}
  "

display_stations = ->
  $("#stations").html("")
  for i in data.stations
    $("#stations").append("<li>#{i.x}x#{i.y} (#{distance_to(i)}ly): #{i.name}</li>")

display = ->
  display_ship()
  display_station()
  display_stations()


$(document).ready ->
  console.log data
  display()
