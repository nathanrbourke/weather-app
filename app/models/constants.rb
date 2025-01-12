module Constants
  COMPASS_DIRECTIONS = {
    0..10 => 'N',
    11..33 => 'NNE',
    34..55 => 'NE',
    56..77 => 'ENE',
    78..100 => 'E',
    101..122 => 'ESE',
    123..145 => 'SE',
    146..167 => 'SSE',
    168..190 => 'S',
    191..212 => 'SSW',
    213..235 => 'SW',
    236..257 => 'WSW',
    258..280 => 'W',
    281..302 => 'WNW',
    303..325 => 'NW',
    326..347 => 'NNW',
    348..359 => 'N'
  }

  DAYS = %w[
    Monday
    Tuesday
    Wednesday
    Thursday
    Friday
    Saturday
    Sunday
  ]

  MONTHS = %w[
    January February March April May June
    July August September October November December
  ]
end
