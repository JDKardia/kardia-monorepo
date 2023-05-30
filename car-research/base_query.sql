SELECT
    c.make
  , c.model
  , GROUP_CONCAT(DISTINCT c.year) as years
  , GROUP_CONCAT(DISTINCT style ) AS styles
  , min_cargo AS minc
  , max_cargo AS maxc
  , fuel_type AS ft
  , city_gas_cost_per_100_miles as c100
  , hwy_gas_cost_per_100_miles as h100
  , city_mpg AS cmpg
  , hwy_mpg AS hmpg
  , city_range AS crng
  , hwy_range AS hrng
  , heated_seats AS hseats
  , wheelbase AS whlbse
  , round(min(min_used),0) as min_used
  , round(max(max_used),0) as max_used
  , round(avg(avg_used),0) as avg_used
  , round(sum(calc_from),0) as calc_from
  , round(MIN(five_year_cost_to_own), 0) AS min_fytco
  , round(MAX(five_year_cost_to_own), 0) AS max_fytco
  , round(AVG(five_year_cost_to_own), 0) AS avg_fytco
  , round(MIN(base_msrp), 0) AS min_msrp
  , round(MAX(base_msrp), 0) AS max_msrp
  , round(AVG(base_msrp), 0) AS avg_msrp
  , GROUP_CONCAT(DISTINCT seats) as seats
FROM cars c
  left join (
    SELECT
        listings.make
      , listings.model
      , listings.year
      , round(MIN(listings.price), 0) AS min_used
      , round(MAX(listings.price), 0) AS max_used
      , round(AVG(listings.price), 0) AS avg_used
      , COUNT(distinct listings.vin) AS calc_from 
    FROM listings
    GROUP BY
        listings.make
      , listings.model
      , listings.year
  ) l on
    c.make = l.make
    and c.model = l.model
    and c.year = l.year
WHERE
    max_cargo IS NOT NULL
    -- requirements
    AND sunroof IN ('standard', 'optional')
    AND max_cargo > 50
    AND (category like '%SUV%' OR category like '%Wagon%')
    and c.year >=  2018
    -- whittling down results
    AND (
      (
        c.make NOT IN (
          'aston-martin', 'bentley', 'buick', 'cadillac'
        , 'chevrolet', 'chrysler', 'dodge', 'ferrari'
        , 'ford', 'gmc', 'jaguar', 'karma', 'lamborghini'
        , 'lincoln', 'lotus', 'lucid', 'maserati'
        , 'mclaren', 'ram', 'rolls-royce', 'scion'
        , 'smart', 'tesla', 'volvo'
        )
        AND c.model NOT LIKE '%niro%'
        AND c.model NOT LIKE '%v60%'
        AND style NOT LIKE '%T8%'
        AND premium_sound IN ('standard', 'optional') 
      )
      OR
      (
        c.make = 'volkswagen'
        AND (category like '%SUV%' OR category like '%Wagon%')
        and style like '%premium%' -- all vw premium models have premium sound
      )
    )
GROUP BY
    c.make
  , c.model
  /* , c.year */
  /* , l.min_used */
  /* , l.max_used */
  /* , l.avg_used */
  /* , l.calc_from */ 
  , min_cargo
  , max_cargo
  , city_gas_cost_per_100_miles
  , hwy_gas_cost_per_100_miles
  , city_mpg
  , hwy_mpg
  , city_range
  , hwy_range
  , heated_seats
  , premium_sound
  , bluetooth
  , sunroof
  , fuel_type
  , wheelbase
ORDER BY max_cargo DESC;
