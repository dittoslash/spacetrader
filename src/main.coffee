game =
  shipname: "The Coriolian"
  location: 0
  fuel: 10
  fuelmax: 10
  range: 5
  cargo: [] #strings basically
  cargomax: 8
  cr: 200


draw = null

this_station = -> data.stations[game.location]

rnd = (min, max, dp=0) -> #Generate a random integer between min and max with dp decimal points.
  dec = 1
  dec = Math.pow(10, dp) unless dp == 0
  min + Math.floor(Math.random() * max)
distance_to = (there) -> #Calculate the distance to a station. Accepts station object or ID.
  here = this_station()
  there = data.stations[there] unless there.name
  x1 = here.x
  x2 = there.x
  y1 = here.y
  y2 = there.y
  Math.round(Math.sqrt(Math.pow(x2-x1, 2) + Math.pow(y2-y1, 2))*100)/100
move_to = (there) -> #Move to a station and consumes fuel. Accepts station ID.
  game.fuel -= distance_to there
  game.location = there #ids only ree
  display()
refuel = -> #Refuels ship (currently for free.)
  game.fuel = game.fuelmax
  display()
ditch = (cn) -> #Ditches cargo. Accepts name of commodity.
  game.cargo.pop(game.cargo.indexOf(cn))
  display()
buy = (cn) -> #Buys cargo. Accepts name of commodity.
  game.cr -= this_station().commv[cn]
  game.cargo.push(cn)
  display()
sell = (cn) -> #Sells cargo. Accepts name of commodity.
  game.cargo.pop(game.cargo.indexOf(cn))
  game.cr += this_station().commv[cn]
  display()


gen_comv = -> #Generate commodity values.
  for st in data.stations
    for cn in Object.keys(data.commodities)
      cv = data.commodities[cn]
      range = cv/5 #e.g. 25cv = +- 5
      st.commv[cn] = rnd(cv-range, range*2)
trade_gui = -> #Generate the trading GUI.
  b = "<ul>"
  for cn in Object.keys(this_station().commv)
    cv = this_station().commv[cn]
    b += "<li> #{cn}: <span class='#{if cv < data.commodities[cn] then "goodprice" else if cv > data.commodities[cn] then "badprice" else ""}'>#{cv}cr</span>
    <button #{if cv > game.cr or game.cargo.length == game.cargomax then "disabled " else ""}onclick='buy(\"#{cn}\")'>Buy 1</button>
    <button #{unless cn in game.cargo then "disabled " else ""}onclick='sell(\"#{cn}\")'>Sell 1</button></li>"
  b += "</ul>"

display_ship = ->
  $("#yourshiptitle").html "Your Ship, #{game.shipname}"
  $("#yourship").html "
  Balance: #{game.cr}cr <br>
  Fuel: #{Math.round(game.fuel*100)/100}&#x2F;#{game.fuelmax} (max dist #{game.range}) <br>
  Cargo (#{game.cargo.length}/#{game.cargomax}):
  <ul id='cargo'> <ul/>
  "
  cargo_count = {}
  for i in game.cargo
    if cargo_count[i] then cargo_count[i] += 1
    else cargo_count[i] = 1
  for c in Object.keys(cargo_count)
    v = cargo_count[c]
    $("#cargo").append("<li>#{v} #{c} <button onclick='ditch(\"#{c}\")'>Ditch</button></li>")
display_station = ->
  current_station = this_station()
  $("#thestation").html "
  Current station: #{current_station.name} #{current_station.x}x#{current_station.y}<br />
  <button #{unless "R" in current_station.cap then "disabled " else ""} onclick='refuel()'> Refuel </button>
  #{trade_gui()}
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
  gen_comv()
  draw = SVG('stations').size(500,500)
  display()
