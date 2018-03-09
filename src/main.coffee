game =
  shipname: "The Coriolian"
  location: 0
  fuel: 10
  fuelmax: 10
  range: 5

this_station = -> data.stations[game.location]

distance_to = (there) ->
  here = this_station()
  there = data.stations[there] unless there.name
  x1 = here.x
  x2 = there.x
  y1 = here.y
  y2 = there.y
  Math.round(Math.sqrt(Math.pow(x2-x1, 2) + Math.pow(y2-y1, 2))*100)/100
move_to = (there) ->
  game.fuel -= distance_to there
  game.location = there #ids only ree
  display()
refuel = ->
  game.fuel = game.fuelmax
  display()

display_ship = ->
  $("#yourship").html "
  #{game.shipname}, your ship <br />
  Fuel: #{ Math.round(game.fuel*100)/100}&#x2F;#{game.fuelmax} (max dist #{game.range})
  "

display_station = ->
  current_station = this_station()
  $("#thestation").html "
  Current station: #{current_station.name} <br />
  Location: #{current_station.x}x#{current_station.y}

  <button #{"disabled" unless "refuel" in current_station.cap} onclick='refuel()'> Refuel </button>

  "

display_stations = ->
  $("#stations").html("")
  j = 0
  for i in data.stations
    d = distance_to(i)
    disabled = if d>game.fuel or d>game.range then "disabled " else ""
    $("#stations").append("<li>#{i.x}x#{i.y} (#{d}ly):
      #{i.name} <button #{disabled}onclick='move_to(#{j})'>Go</button> </li>")
    j += 1

display = ->
  display_ship()
  display_station()
  display_stations()


$(document).ready ->
  console.log data
  display()
