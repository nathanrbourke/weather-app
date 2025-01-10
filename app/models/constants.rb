module Constants
  COMPASS_DIRECTIONS = {
    1..11 => "N",
    12..34 => "NNE",
    35..56 => "NE",
    57..78 => "ENE",
    79..101 => "E",
    102..123 => "ESE",
    124..146 => "SE",
    147..168 => "SSE",
    169..191 => "S",
    192..213 => "SSW",
    214..236 => "SW",
    237..258 => "WSW",
    259..281 => "W",
    282..303 => "WNW",
    304..326 => "NW",
    327..348 => "NNW",
    349..360 => "N"
  }

  DAYS = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ]

  MONTHS = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ]
end