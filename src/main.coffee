game =
  shipname: "The Coriolian"
  location: 0

display_ship = ->
  $("#yourship").html "
  #{game.shipname}, your ship
  "

display_station = ->
  current_station = data.stations[game.location]
  $("#thestation").html "
  Current station: #{current_station.name} <br />
  Location: #{current_station.x}x#{current_station.y}
  "

display_stations = ->
  $("#stations").html("")
  for i in data.stations
    $("#stations").append("<li>#{i.x}x#{i.y}: #{i.name}</li>")

display = ->
  display_ship()
  display_station()
  display_stations()


$(document).ready ->
  console.log data
  display()
