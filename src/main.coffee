game =
  shipname: "The Coriolian"
  location: 0
  fuel: 10
  fuelmax: 10
  range: 5
  cargo: ["Food"] #strings basically
  cargomax: 5

draw = null

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
ditch = (id) ->
  game.cargo.pop(id)
  display()

display_ship = ->
  $("#yourship").html "
  #{game.shipname}, your ship <br>
  Fuel: #{Math.round(game.fuel*100)/100}&#x2F;#{game.fuelmax} (max dist #{game.range}) <br>
  Cargo (#{game.cargo.length}/#{game.cargomax}):
  <ul id='cargo'> <ul/>
  "
  j = -1
  for i in game.cargo
    j += 1
    $("#cargo").append("<li>#{i} <button onclick='ditch(#{j})'>Ditch</button></li>")

display_station = ->
  current_station = this_station()
  $("#thestation").html "
  Current station: #{current_station.name} <br />
  Location: #{current_station.x}x#{current_station.y}

  <button #{"disabled" unless "R" in current_station.cap} onclick='refuel()'> Refuel </button>

  "

display_stations = ->
  draw.clear()
  j = 0

  us = this_station()
  usx = us.x*10+100
  usy = us.y*10+100

  range = draw.circle(game.range*20).center(usx, usy).attr({'fill-opacity': 0, stroke: '#00f'})
  fuel = draw.circle(game.fuel*20).center(usx, usy).attr({'fill-opacity': 0, stroke: '#0f0'})
  if game.range > game.fuel then range.attr {'stroke-opacity': 0.3}
  else fuel.attr {'stroke-opacity': 0.3}

  for i in data.stations
    d = distance_to(i)
    x = i.x*10+100
    y = i.y*10+100
    s = draw.circle(7).center(x, y)

    s.attr if j == game.location then {fill: "#15c"} else if d <= game.fuel and d <= game.range then {fill: '#1a1'} else {fill: '#111'}

    str = "#{i.cap} #{i.name} (#{d}ly)"
    draw.line(x, y, 250, y).attr {'stroke-opacity': 0.5, 'stroke-width': 1}
    draw.text(str).move(250, y).font('size', 10)

    s.station = j
    if j != game.location and d <= game.fuel and d <= game.range
      s.click ->
        move_to this.station
    j += 1

display = ->
  display_ship()
  display_station()
  display_stations()

$(document).ready ->
  draw = SVG('stations').size(500,500)
  display()
