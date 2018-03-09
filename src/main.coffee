game =
  location: 0

display_stations: ->
  $("#stations").html("")
  for i in data.stations
    $("#stations").append("#{i.x}x#{i.y}: #{i.name}")

display: ->
  display_stations()
