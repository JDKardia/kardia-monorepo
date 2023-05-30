CREATE TABLE cars AS
SELECT
  *
FROM
  (
    SELECT
      make,
      model,
      year,
      style,
      category,
      "mincargo(ft^3)" AS min_cargo,
      "maxcargo(ft^3)" AS max_cargo,
      fueltype AS fuel_type,
      city_mpg AS city_mpg,
      "per_100_city($)" AS city_gas_cost_per_100_miles,
      hwy_mpg AS hwy_mpg,
      "per_100_hwy($)" AS hwy_gas_cost_per_100_miles,
      city_range AS city_range,
      hwy_range AS hwy_range,
      "wheelbase(in)" AS wheelbase,
      "seats" AS seats,
      premiumsound AS premium_sound,
      bluetooth AS bluetooth,
      heatedseats AS heated_seats,
      cooledseats AS cooled_seats,
      sunroof AS sunroof,
      "5yrTCO($)" AS five_year_cost_to_own,
      "BaseMSRP($)" AS base_msrp
    FROM
      (
        SELECT
          id,
          make,
          model,
          year,
          CAST("numberOfSeats" AS decimal) AS "seats",
          CAST("wheelbase" AS decimal) AS "wheelbase(in)",
          cast("mincargospace" AS decimal) AS "mincargo(ft^3)",
          cast("maxcargospace" AS decimal) AS "maxcargo(ft^3)",
          CAST("tcoPrice" AS decimal) AS "5yrTCO($)",
          CAST("baseMSRP" AS decimal) AS "BaseMSRP($)"
        FROM
          (
            SELECT
              *,
              INSTR(style_name, 'dr ') AS "doorPos",
              INSTR(style_name, '(') AS "parenPos",
              INSTR(style_name, 'AWD') AS "awdPos",
              INSTR(style_name, '4WD') AS "4wdPos",
              INSTR(style_name, 'with') AS "withPos",
              INSTR(
                specifications ->> "fuelEconomy",
                '/'
              ) AS "economySlashPos",
              INSTR(fuel_economy ->> "range", '/') AS "rangeslashpos",
              price ->> "baseMSRP" AS "baseMSRP",
              dimensions ->> "wheelbase" AS "wheelbase",
              dimensions ->> "cargoSpace" AS "cargoSpace",
              dimensions ->> "numberOfSeats" AS "numberOfSeats",
              dimensions ->> "frontShoulderRoom" AS "frontShoulderRoom",
              dimensions ->> "rearShoulderRoom" AS "rearShoulderRoom",
              dimensions ->> "rearHeadRoom" AS "rearHeadRoom",
              dimensions ->> "cargoSpace" AS "mincargoSpace",
              spec_list -> "standard" -> "Measurements" -> "Maximum cargo capacity" ->> "Maximum cargo capacity" AS "maxcargospace",
              dimensions ->> "frontHeadRoom" AS "frontHeadRoom",
              dimensions ->> "length" AS "length",
              dimensions ->> "bedLength" AS "bedLength",
              dimensions ->> "groundClearance" AS "groundClearance",
              dimensions ->> "frontLegRoom" AS "frontLegRoom",
              dimensions ->> "rearLegRoom" AS "rearLegRoom",
              dimensions ->> "numberOfSeats" AS "numberOfSeats",
              dimensions ->> "wheelbase" AS "wheelbase",
              dimensions ->> "overallWidthWithoutMirrors" AS "overallWidthWithoutMirrors",
              dimensions ->> "curbWeight" AS "curbWeight",
              dimensions ->> "overallWidthWithMirrors" AS "overallWidthWithMirrors",
              dimensions ->> "height" AS "height",
              exterior ->> "wheelDiameter" AS "wheelDiameter",
              exterior ->> "wheelTireSize" AS "wheelTireSize",
              exterior ->> "runFlatTires" AS "runFlatTires",
              exterior ->> "sunroof" AS "sunroof",
              exterior ->> "wheelType" AS "wheelType",
              exterior ->> "allSeasonTires" AS "allSeasonTires",
              exterior ->> "wheelWidth" AS "wheelWidth",
              exterior ->> "powerGlassSunroof" AS "powerGlassSunroof",
              exterior ->> "tireSize" AS "tireSize",
              interior ->> "hdRadio" AS "hdRadio",
              interior ->> "destinationDownload" AS "destinationDownload",
              interior ->> "upholstery" AS "upholstery",
              interior ->> "cooledVentilatedSeats" AS "cooledVentilatedSeats",
              interior ->> "parkingAssistance" AS "parkingAssistance",
              interior ->> "builtInHardDrive" AS "builtInHardDrive",
              interior ->> "destinationGuidance" AS "destinationGuidance",
              interior ->> "powerSeats" AS "powerSeats",
              interior ->> "aCWithClimateControl" AS "aCWithClimateControl",
              interior ->> "navigation" AS "navigation",
              interior ->> "roadsideAssistance" AS "roadsideAssistance",
              interior ->> "satelliteRadio" AS "satelliteRadio",
              interior ->> "keylessIgnition" AS "keylessIgnition",
              interior ->> "handFreeCalling" AS "handFreeCalling",
              interior ->> "heatedCooledSeats" AS "heatedCooledSeats",
              interior ->> "rearSeatDvd" AS "rearSeatDvd",
              interior ->> "premiumSoundSystem" AS "premiumSoundSystem",
              interior ->> "conciergeService" AS "conciergeService",
              interior ->> "heatedSeats" AS "heatedSeats",
              interior ->> "iPod" AS "iPod",
              interior ->> "bluetooth" AS "bluetooth",
              interior ->> "cruiseControl" AS "cruiseControl",
              interior ->> "adaptiveCruiseControl" AS "adaptiveCruiseControl",
              interior ->> "foldingRearSeats" AS "foldingRearSeats",
              interior ->> "seatingCapacity" AS "seatingCapacity",
              safety ->> "vehicleAlarmNotification" AS "vehicleAlarmNotification",
              safety ->> "emergencyService" AS "emergencyService",
              safety ->> "stolenVehicleTrackingAssistance" AS "stolenVehicleTrackingAssistance",
              safety ->> "antiTheftSystem" AS "antiTheftSystem",
              safety ->> "airbagDeploymentNotification" AS "airbagDeploymentNotification",
              safety ->> "stabilityControl" AS "stabilityControl",
              safety ->> "antiLockBrakes" AS "antiLockBrakes",
              safety ->> "sideCurtainAirbags" AS "sideCurtainAirbags",
              safety ->> "childSeatAnchors" AS "childSeatAnchors",
              safety ->> "tractionControl" AS "tractionControl",
              warranty ->> "freeMaintenance" AS "freeMaintenance",
              warranty ->> "drivetrain" AS "drivetrain",
              warranty ->> "basic" AS "basic",
              specifications ->> "transmission" AS "transmission",
              specifications ->> "fuelEconomy" AS "fuelEconomy",
              specifications ->> "engineTorque" AS "engineTorque",
              specifications ->> "fuelType" AS "fuelType",
              specifications ->> "fuelCapacity" AS "fuelCapacity",
              specifications ->> "engineDisplacement" AS "engineDisplacement",
              specifications ->> "enginePower" AS "enginePower",
              specifications ->> "driveTrain" AS "driveTrain",
              specifications ->> "engineCylinderCount" AS "engineCylinderCount",
              color_features -> "0" ->> "title" AS "exterior_color_0",
              color_features -> "1" ->> "title" AS "exterior_color_1",
              color_features -> "2" ->> "title" AS "exterior_color_2",
              color_features -> "3" ->> "title" AS "exterior_color_3",
              color_features -> "4" ->> "title" AS "exterior_color_4",
              color_features -> "5" ->> "title" AS "exterior_color_5",
              color_features -> "6" ->> "title" AS "exterior_color_6",
              color_features -> "7" ->> "title" AS "exterior_color_7",
              color_features -> "8" ->> "title" AS "exterior_color_8",
              color_features -> "9" ->> "title" AS "exterior_color_9",
              color_features -> "10" ->> "title" AS "exterior_color_10",
              color_features -> "11" ->> "title" AS "exterior_color_11",
              color_features -> "12" ->> "title" AS "exterior_color_12",
              color_features -> "13" ->> "title" AS "exterior_color_13",
              color_features -> "14" ->> "title" AS "exterior_color_14",
              color_features -> "15" ->> "title" AS "exterior_color_15",
              color_features -> "16" ->> "title" AS "exterior_color_16",
              color_features -> "17" ->> "title" AS "exterior_color_17",
              color_features -> "18" ->> "title" AS "exterior_color_18",
              color_features -> "19" ->> "title" AS "exterior_color_19",
              color_features -> "20" ->> "title" AS "exterior_color_20",
              color_features -> "21" ->> "title" AS "exterior_color_21",
              color_features -> "22" ->> "title" AS "exterior_color_22",
              color_features -> "23" ->> "title" AS "exterior_color_23",
              color_features -> "24" ->> "title" AS "exterior_color_24",
              five_year_tco ->> "tcoPrice" AS "tcoPrice",
              fuel_economy ->> "range" AS "range",
              exterior ->> "sunroof" AS "sunroof",
              interior ->> "bluetooth" AS "bluetooth",
              interior ->> "heatedSeats" AS "heatedSeats",
              spec_list LIKE '%Premium Sound%' AS "premiumSoundOption",
              interior ->> "premiumSoundSystem" AS "premiumSoundSystem",
              interior ->> "cooledVentilatedSeats" AS "cooledVentilatedSeats"
            FROM cars_dump
          ) AS base
      ) AS deets
      INNER JOIN (
        SELECT
          id,
          fueltype,
          city_range,
          hwy_range,
          city_mpg,
          hwy_mpg,
          CASE fueltype WHEN 'premium' THEN SUBSTR(
            premium_gas_constant * (1.0 / city_mpg),
            0,
            6
          ) WHEN 'regular' THEN SUBSTR(
            regular_gas_constant * (1.0 / city_mpg),
            0,
            6
          ) END AS "per_100_city($)",
          CASE fueltype WHEN 'premium' THEN SUBSTR(
            premium_gas_constant * (1.0 / hwy_mpg),
            0,
            6
          ) WHEN 'regular' THEN SUBSTR(
            regular_gas_constant * (1.0 / hwy_mpg),
            0,
            6
          ) END AS "per_100_hwy($)"
        FROM
          (
            SELECT
              id,
              CAST(
                SUBSTR(
                  fueleconomy, 1, economyslashpos - 1
                ) AS decimal
              ) AS city_mpg,
              CAST(
                SUBSTR(fueleconomy, economyslashpos + 1) AS decimal
              ) AS hwy_mpg,
              CAST(
                SUBSTR(range, 1, rangeslashpos - 1) AS decimal
              ) AS city_range,
              CAST(
                SUBSTR(range, rangeslashpos + 1) AS decimal
              ) AS hwy_range,
              CASE fueltype WHEN 'premium unleaded (required)' THEN 'premium' WHEN 'premium unleaded (recommended)' THEN 'premium' WHEN 'flex-fuel (premium unleaded recommended/e85)' THEN 'premium' WHEN 'flex-fuel (unleaded/e85)' THEN 'regular' WHEN 'regular unleaded' THEN 'regular' ELSE fueltype END AS fueltype,
              (5.15 * 100.0) AS premium_gas_constant,
              (4.28 * 100.0) AS regular_gas_constant
            FROM
              (
                SELECT
                  *,
                  INSTR(style_name, 'dr ') AS "doorPos",
                  INSTR(style_name, '(') AS "parenPos",
                  INSTR(style_name, 'AWD') AS "awdPos",
                  INSTR(style_name, '4WD') AS "4wdPos",
                  INSTR(style_name, 'with') AS "withPos",
                  INSTR(
                    specifications ->> "fuelEconomy",
                    '/'
                  ) AS "economySlashPos",
                  INSTR(fuel_economy ->> "range", '/') AS "rangeslashpos",
                  price ->> "baseMSRP" AS "baseMSRP",
                  dimensions ->> "wheelbase" AS "wheelbase",
                  dimensions ->> "cargoSpace" AS "cargoSpace",
                  dimensions ->> "numberOfSeats" AS "numberOfSeats",
                  dimensions ->> "frontShoulderRoom" AS "frontShoulderRoom",
                  dimensions ->> "rearShoulderRoom" AS "rearShoulderRoom",
                  dimensions ->> "rearHeadRoom" AS "rearHeadRoom",
                  dimensions ->> "cargoSpace" AS "mincargoSpace",
                  spec_list -> "standard" -> "Measurements" -> "Maximum cargo capacity" ->> "Maximum cargo capacity" AS "maxcargospace",
                  dimensions ->> "frontHeadRoom" AS "frontHeadRoom",
                  dimensions ->> "length" AS "length",
                  dimensions ->> "bedLength" AS "bedLength",
                  dimensions ->> "groundClearance" AS "groundClearance",
                  dimensions ->> "frontLegRoom" AS "frontLegRoom",
                  dimensions ->> "rearLegRoom" AS "rearLegRoom",
                  dimensions ->> "numberOfSeats" AS "numberOfSeats",
                  dimensions ->> "wheelbase" AS "wheelbase",
                  dimensions ->> "overallWidthWithoutMirrors" AS "overallWidthWithoutMirrors",
                  dimensions ->> "curbWeight" AS "curbWeight",
                  dimensions ->> "overallWidthWithMirrors" AS "overallWidthWithMirrors",
                  dimensions ->> "height" AS "height",
                  exterior ->> "wheelDiameter" AS "wheelDiameter",
                  exterior ->> "wheelTireSize" AS "wheelTireSize",
                  exterior ->> "runFlatTires" AS "runFlatTires",
                  exterior ->> "sunroof" AS "sunroof",
                  exterior ->> "wheelType" AS "wheelType",
                  exterior ->> "allSeasonTires" AS "allSeasonTires",
                  exterior ->> "wheelWidth" AS "wheelWidth",
                  exterior ->> "powerGlassSunroof" AS "powerGlassSunroof",
                  exterior ->> "tireSize" AS "tireSize",
                  interior ->> "hdRadio" AS "hdRadio",
                  interior ->> "destinationDownload" AS "destinationDownload",
                  interior ->> "upholstery" AS "upholstery",
                  interior ->> "cooledVentilatedSeats" AS "cooledVentilatedSeats",
                  interior ->> "parkingAssistance" AS "parkingAssistance",
                  interior ->> "builtInHardDrive" AS "builtInHardDrive",
                  interior ->> "destinationGuidance" AS "destinationGuidance",
                  interior ->> "powerSeats" AS "powerSeats",
                  interior ->> "aCWithClimateControl" AS "aCWithClimateControl",
                  interior ->> "navigation" AS "navigation",
                  interior ->> "roadsideAssistance" AS "roadsideAssistance",
                  interior ->> "satelliteRadio" AS "satelliteRadio",
                  interior ->> "keylessIgnition" AS "keylessIgnition",
                  interior ->> "handFreeCalling" AS "handFreeCalling",
                  interior ->> "heatedCooledSeats" AS "heatedCooledSeats",
                  interior ->> "rearSeatDvd" AS "rearSeatDvd",
                  interior ->> "premiumSoundSystem" AS "premiumSoundSystem",
                  interior ->> "conciergeService" AS "conciergeService",
                  interior ->> "heatedSeats" AS "heatedSeats",
                  interior ->> "iPod" AS "iPod",
                  interior ->> "bluetooth" AS "bluetooth",
                  interior ->> "cruiseControl" AS "cruiseControl",
                  interior ->> "adaptiveCruiseControl" AS "adaptiveCruiseControl",
                  interior ->> "foldingRearSeats" AS "foldingRearSeats",
                  interior ->> "seatingCapacity" AS "seatingCapacity",
                  safety ->> "vehicleAlarmNotification" AS "vehicleAlarmNotification",
                  safety ->> "emergencyService" AS "emergencyService",
                  safety ->> "stolenVehicleTrackingAssistance" AS "stolenVehicleTrackingAssistance",
                  safety ->> "antiTheftSystem" AS "antiTheftSystem",
                  safety ->> "airbagDeploymentNotification" AS "airbagDeploymentNotification",
                  safety ->> "stabilityControl" AS "stabilityControl",
                  safety ->> "antiLockBrakes" AS "antiLockBrakes",
                  safety ->> "sideCurtainAirbags" AS "sideCurtainAirbags",
                  safety ->> "childSeatAnchors" AS "childSeatAnchors",
                  safety ->> "tractionControl" AS "tractionControl",
                  warranty ->> "freeMaintenance" AS "freeMaintenance",
                  warranty ->> "drivetrain" AS "drivetrain",
                  warranty ->> "basic" AS "basic",
                  specifications ->> "transmission" AS "transmission",
                  specifications ->> "fuelEconomy" AS "fuelEconomy",
                  specifications ->> "engineTorque" AS "engineTorque",
                  specifications ->> "fuelType" AS "fuelType",
                  specifications ->> "fuelCapacity" AS "fuelCapacity",
                  specifications ->> "engineDisplacement" AS "engineDisplacement",
                  specifications ->> "enginePower" AS "enginePower",
                  specifications ->> "driveTrain" AS "driveTrain",
                  specifications ->> "engineCylinderCount" AS "engineCylinderCount",
                  color_features -> "0" ->> "title" AS "exterior_color_0",
                  color_features -> "1" ->> "title" AS "exterior_color_1",
                  color_features -> "2" ->> "title" AS "exterior_color_2",
                  color_features -> "3" ->> "title" AS "exterior_color_3",
                  color_features -> "4" ->> "title" AS "exterior_color_4",
                  color_features -> "5" ->> "title" AS "exterior_color_5",
                  color_features -> "6" ->> "title" AS "exterior_color_6",
                  color_features -> "7" ->> "title" AS "exterior_color_7",
                  color_features -> "8" ->> "title" AS "exterior_color_8",
                  color_features -> "9" ->> "title" AS "exterior_color_9",
                  color_features -> "10" ->> "title" AS "exterior_color_10",
                  color_features -> "11" ->> "title" AS "exterior_color_11",
                  color_features -> "12" ->> "title" AS "exterior_color_12",
                  color_features -> "13" ->> "title" AS "exterior_color_13",
                  color_features -> "14" ->> "title" AS "exterior_color_14",
                  color_features -> "15" ->> "title" AS "exterior_color_15",
                  color_features -> "16" ->> "title" AS "exterior_color_16",
                  color_features -> "17" ->> "title" AS "exterior_color_17",
                  color_features -> "18" ->> "title" AS "exterior_color_18",
                  color_features -> "19" ->> "title" AS "exterior_color_19",
                  color_features -> "20" ->> "title" AS "exterior_color_20",
                  color_features -> "21" ->> "title" AS "exterior_color_21",
                  color_features -> "22" ->> "title" AS "exterior_color_22",
                  color_features -> "23" ->> "title" AS "exterior_color_23",
                  color_features -> "24" ->> "title" AS "exterior_color_24",

                  /* five_year_tco ->> "federalTaxCredit" , */

                  /* five_year_tco ->> "5_year_insurance" , */

                  /* five_year_tco ->> "5_year_maintenance" , */

                  /* five_year_tco ->> "5_year_repairs" , */

                  /* five_year_tco ->> "5_year_taxesAndFees" , */

                  /* five_year_tco ->> "5_year_financeInterest" , */

                  /* five_year_tco ->> "5_year_depreciation" , */

                  /* five_year_tco ->> "5_year_fuel" , */

                  /* five_year_tco ->> "5_year_tcoPrice" , */

                  /* five_year_tco ->> "averageCostPerMile" , */
                  five_year_tco ->> "tcoPrice" AS "tcoPrice",
                  fuel_economy ->> "range" AS "range",
                  exterior ->> "sunroof" AS "sunroof",
                  interior ->> "bluetooth" AS "bluetooth",
                  interior ->> "heatedSeats" AS "heatedSeats",
                  spec_list LIKE '%Premium Sound%' AS "premiumSoundOption",
                  interior ->> "premiumSoundSystem" AS "premiumSoundSystem",
                  interior ->> "cooledVentilatedSeats" AS "cooledVentilatedSeats"
                FROM cars_dump
              ) AS base
          )
      ) AS fuel ON deets.id = fuel.id
      INNER JOIN (
        SELECT
          id,
          CASE WHEN premiumsoundsystem = 'Not available'
          AND premiumsoundoption = 1 THEN 'optional' ELSE premiumsoundsystem END AS premiumsound,
          CASE bluetooth WHEN 'Not available' THEN 'N/A' WHEN 'available on other styles' THEN 'other trims' ELSE bluetooth END AS bluetooth,
          CASE heatedseats WHEN 'Not available' THEN 'N/A' WHEN 'available on other styles' THEN 'other trims' ELSE heatedseats END AS heatedseats,
          CASE cooledventilatedseats WHEN 'Not available' THEN 'N/A' WHEN 'available on other styles' THEN 'other trims' ELSE cooledventilatedseats END AS cooledseats,
          CASE sunroof WHEN 'Not available' THEN 'N/A' WHEN 'available on other styles' THEN 'other trims' ELSE sunroof END AS sunroof
          /* case PLACE */

          /*   when 'Not available' then 'N/A' */

          /*   when 'available on other styles' then 'other trims' */

          /*   else PLACE */

          /* end AS PLACE, */
        FROM
          (
            SELECT
              *,
              INSTR(style_name, 'dr ') AS "doorPos",
              INSTR(style_name, '(') AS "parenPos",
              INSTR(style_name, 'AWD') AS "awdPos",
              INSTR(style_name, '4WD') AS "4wdPos",
              INSTR(style_name, 'with') AS "withPos",
              INSTR(
                specifications ->> "fuelEconomy",
                '/'
              ) AS "economySlashPos",
              INSTR(fuel_economy ->> "range", '/') AS "rangeslashpos",
              price ->> "baseMSRP" AS "baseMSRP",
              dimensions ->> "wheelbase" AS "wheelbase",
              dimensions ->> "cargoSpace" AS "cargoSpace",
              dimensions ->> "numberOfSeats" AS "numberOfSeats",
              dimensions ->> "frontShoulderRoom" AS "frontShoulderRoom",
              dimensions ->> "rearShoulderRoom" AS "rearShoulderRoom",
              dimensions ->> "rearHeadRoom" AS "rearHeadRoom",
              dimensions ->> "cargoSpace" AS "mincargoSpace",
              spec_list -> "standard" -> "Measurements" -> "Maximum cargo capacity" ->> "Maximum cargo capacity" AS "maxcargospace",
              dimensions ->> "frontHeadRoom" AS "frontHeadRoom",
              dimensions ->> "length" AS "length",
              dimensions ->> "bedLength" AS "bedLength",
              dimensions ->> "groundClearance" AS "groundClearance",
              dimensions ->> "frontLegRoom" AS "frontLegRoom",
              dimensions ->> "rearLegRoom" AS "rearLegRoom",
              dimensions ->> "numberOfSeats" AS "numberOfSeats",
              dimensions ->> "wheelbase" AS "wheelbase",
              dimensions ->> "overallWidthWithoutMirrors" AS "overallWidthWithoutMirrors",
              dimensions ->> "curbWeight" AS "curbWeight",
              dimensions ->> "overallWidthWithMirrors" AS "overallWidthWithMirrors",
              dimensions ->> "height" AS "height",
              exterior ->> "wheelDiameter" AS "wheelDiameter",
              exterior ->> "wheelTireSize" AS "wheelTireSize",
              exterior ->> "runFlatTires" AS "runFlatTires",
              exterior ->> "sunroof" AS "sunroof",
              exterior ->> "wheelType" AS "wheelType",
              exterior ->> "allSeasonTires" AS "allSeasonTires",
              exterior ->> "wheelWidth" AS "wheelWidth",
              exterior ->> "powerGlassSunroof" AS "powerGlassSunroof",
              exterior ->> "tireSize" AS "tireSize",
              interior ->> "hdRadio" AS "hdRadio",
              interior ->> "destinationDownload" AS "destinationDownload",
              interior ->> "upholstery" AS "upholstery",
              interior ->> "cooledVentilatedSeats" AS "cooledVentilatedSeats",
              interior ->> "parkingAssistance" AS "parkingAssistance",
              interior ->> "builtInHardDrive" AS "builtInHardDrive",
              interior ->> "destinationGuidance" AS "destinationGuidance",
              interior ->> "powerSeats" AS "powerSeats",
              interior ->> "aCWithClimateControl" AS "aCWithClimateControl",
              interior ->> "navigation" AS "navigation",
              interior ->> "roadsideAssistance" AS "roadsideAssistance",
              interior ->> "satelliteRadio" AS "satelliteRadio",
              interior ->> "keylessIgnition" AS "keylessIgnition",
              interior ->> "handFreeCalling" AS "handFreeCalling",
              interior ->> "heatedCooledSeats" AS "heatedCooledSeats",
              interior ->> "rearSeatDvd" AS "rearSeatDvd",
              interior ->> "premiumSoundSystem" AS "premiumSoundSystem",
              interior ->> "conciergeService" AS "conciergeService",
              interior ->> "heatedSeats" AS "heatedSeats",
              interior ->> "iPod" AS "iPod",
              interior ->> "bluetooth" AS "bluetooth",
              interior ->> "cruiseControl" AS "cruiseControl",
              interior ->> "adaptiveCruiseControl" AS "adaptiveCruiseControl",
              interior ->> "foldingRearSeats" AS "foldingRearSeats",
              interior ->> "seatingCapacity" AS "seatingCapacity",
              safety ->> "vehicleAlarmNotification" AS "vehicleAlarmNotification",
              safety ->> "emergencyService" AS "emergencyService",
              safety ->> "stolenVehicleTrackingAssistance" AS "stolenVehicleTrackingAssistance",
              safety ->> "antiTheftSystem" AS "antiTheftSystem",
              safety ->> "airbagDeploymentNotification" AS "airbagDeploymentNotification",
              safety ->> "stabilityControl" AS "stabilityControl",
              safety ->> "antiLockBrakes" AS "antiLockBrakes",
              safety ->> "sideCurtainAirbags" AS "sideCurtainAirbags",
              safety ->> "childSeatAnchors" AS "childSeatAnchors",
              safety ->> "tractionControl" AS "tractionControl",
              warranty ->> "freeMaintenance" AS "freeMaintenance",
              warranty ->> "drivetrain" AS "drivetrain",
              warranty ->> "basic" AS "basic",
              specifications ->> "transmission" AS "transmission",
              specifications ->> "fuelEconomy" AS "fuelEconomy",
              specifications ->> "engineTorque" AS "engineTorque",
              specifications ->> "fuelType" AS "fuelType",
              specifications ->> "fuelCapacity" AS "fuelCapacity",
              specifications ->> "engineDisplacement" AS "engineDisplacement",
              specifications ->> "enginePower" AS "enginePower",
              specifications ->> "driveTrain" AS "driveTrain",
              specifications ->> "engineCylinderCount" AS "engineCylinderCount",
              color_features -> "0" ->> "title" AS "exterior_color_0",
              color_features -> "1" ->> "title" AS "exterior_color_1",
              color_features -> "2" ->> "title" AS "exterior_color_2",
              color_features -> "3" ->> "title" AS "exterior_color_3",
              color_features -> "4" ->> "title" AS "exterior_color_4",
              color_features -> "5" ->> "title" AS "exterior_color_5",
              color_features -> "6" ->> "title" AS "exterior_color_6",
              color_features -> "7" ->> "title" AS "exterior_color_7",
              color_features -> "8" ->> "title" AS "exterior_color_8",
              color_features -> "9" ->> "title" AS "exterior_color_9",
              color_features -> "10" ->> "title" AS "exterior_color_10",
              color_features -> "11" ->> "title" AS "exterior_color_11",
              color_features -> "12" ->> "title" AS "exterior_color_12",
              color_features -> "13" ->> "title" AS "exterior_color_13",
              color_features -> "14" ->> "title" AS "exterior_color_14",
              color_features -> "15" ->> "title" AS "exterior_color_15",
              color_features -> "16" ->> "title" AS "exterior_color_16",
              color_features -> "17" ->> "title" AS "exterior_color_17",
              color_features -> "18" ->> "title" AS "exterior_color_18",
              color_features -> "19" ->> "title" AS "exterior_color_19",
              color_features -> "20" ->> "title" AS "exterior_color_20",
              color_features -> "21" ->> "title" AS "exterior_color_21",
              color_features -> "22" ->> "title" AS "exterior_color_22",
              color_features -> "23" ->> "title" AS "exterior_color_23",
              color_features -> "24" ->> "title" AS "exterior_color_24",
              five_year_tco ->> "federalTaxCredit" AS "federalTaxCredit" ,
              five_year_tco ->> "5_year_insurance" AS "5_year_insurance" ,
              five_year_tco ->> "5_year_maintenance" AS "5_year_maintenance" ,
              five_year_tco ->> "5_year_repairs" AS "5_year_repairs" ,
              five_year_tco ->> "5_year_taxesAndFees" AS "5_year_taxesAndFees" ,
              five_year_tco ->> "5_year_financeInterest" AS "5_year_financeInterest" ,
              five_year_tco ->> "5_year_depreciation" AS "5_year_depreciation" ,
              five_year_tco ->> "5_year_fuel" AS "5_year_fuel" ,
              five_year_tco ->> "5_year_tcoPrice" AS "5_year_tcoPrice" ,
              five_year_tco ->> "averageCostPerMile" AS "averageCostPerMile" ,
              five_year_tco ->> "tcoPrice" AS "tcoPrice",
              fuel_economy ->> "range" AS "range",
              exterior ->> "sunroof" AS "sunroof",
              interior ->> "bluetooth" AS "bluetooth",
              interior ->> "heatedSeats" AS "heatedSeats",
              spec_list LIKE '%Premium Sound%' AS "premiumSoundOption",
              interior ->> "premiumSoundSystem" AS "premiumSoundSystem",
              interior ->> "cooledVentilatedSeats" AS "cooledVentilatedSeats"
            FROM cars_dump
          ) AS base
      ) AS options ON deets.id = options.id
      INNER JOIN (
        SELECT
          id,
          SUBSTR(style_name, 0, doorpos - 2) AS style,
          SUBSTR(style_name, doorpos - 1, 3) AS doors,
          CASE WHEN awdpos == 0
          and "4wdpos" == 0 THEN 'N/A' ELSE 'standard' END AS awd,
          CASE WHEN awdpos != 0 THEN SUBSTR(
            style_name,
            doorpos + 3,
            awdpos - 1 - (doorpos + 3)
          ) -- is awd
          WHEN withpos != 0 THEN SUBSTR(
            style_name,
            doorpos + 3,
            withpos - 1 - (doorpos + 3)
          ) -- has with block, but not awd
          WHEN parenpos != 0 THEN SUBSTR(
            style_name,
            doorpos + 3,
            parenpos - 1 - (doorpos + 3)
          ) -- is not awd, no with, and has engine spec
          ELSE SUBSTR(style_name, doorpos + 3) -- not awd, no engine spec
          END AS category
        FROM
          (
            SELECT
              *,
              INSTR(style_name, 'dr ') AS "doorPos",
              INSTR(style_name, '(') AS "parenPos",
              INSTR(style_name, 'AWD') AS "awdPos",
              INSTR(style_name, '4WD') AS "4wdPos",
              INSTR(style_name, 'with') AS "withPos",
              INSTR(
                specifications ->> "fuelEconomy",
                '/'
              ) AS "economySlashPos",
              INSTR(fuel_economy ->> "range", '/') AS "rangeslashpos",
              price ->> "baseMSRP" AS "baseMSRP",
              dimensions ->> "wheelbase" AS "wheelbase",
              dimensions ->> "cargoSpace" AS "cargoSpace",
              dimensions ->> "numberOfSeats" AS "numberOfSeats",
              dimensions ->> "frontShoulderRoom" AS "frontShoulderRoom",
              dimensions ->> "rearShoulderRoom" AS "rearShoulderRoom",
              dimensions ->> "rearHeadRoom" AS "rearHeadRoom",
              dimensions ->> "cargoSpace" AS "mincargoSpace",
              spec_list -> "standard" -> "Measurements" -> "Maximum cargo capacity" ->> "Maximum cargo capacity" AS "maxcargospace",
              dimensions ->> "frontHeadRoom" AS "frontHeadRoom",
              dimensions ->> "length" AS "length",
              dimensions ->> "bedLength" AS "bedLength",
              dimensions ->> "groundClearance" AS "groundClearance",
              dimensions ->> "frontLegRoom" AS "frontLegRoom",
              dimensions ->> "rearLegRoom" AS "rearLegRoom",
              dimensions ->> "numberOfSeats" AS "numberOfSeats",
              dimensions ->> "wheelbase" AS "wheelbase",
              dimensions ->> "overallWidthWithoutMirrors" AS "overallWidthWithoutMirrors",
              dimensions ->> "curbWeight" AS "curbWeight",
              dimensions ->> "overallWidthWithMirrors" AS "overallWidthWithMirrors",
              dimensions ->> "height" AS "height",
              exterior ->> "wheelDiameter" AS "wheelDiameter",
              exterior ->> "wheelTireSize" AS "wheelTireSize",
              exterior ->> "runFlatTires" AS "runFlatTires",
              exterior ->> "sunroof" AS "sunroof",
              exterior ->> "wheelType" AS "wheelType",
              exterior ->> "allSeasonTires" AS "allSeasonTires",
              exterior ->> "wheelWidth" AS "wheelWidth",
              exterior ->> "powerGlassSunroof" AS "powerGlassSunroof",
              exterior ->> "tireSize" AS "tireSize",
              interior ->> "hdRadio" AS "hdRadio",
              interior ->> "destinationDownload" AS "destinationDownload",
              interior ->> "upholstery" AS "upholstery",
              interior ->> "cooledVentilatedSeats" AS "cooledVentilatedSeats",
              interior ->> "parkingAssistance" AS "parkingAssistance",
              interior ->> "builtInHardDrive" AS "builtInHardDrive",
              interior ->> "destinationGuidance" AS "destinationGuidance",
              interior ->> "powerSeats" AS "powerSeats",
              interior ->> "aCWithClimateControl" AS "aCWithClimateControl",
              interior ->> "navigation" AS "navigation",
              interior ->> "roadsideAssistance" AS "roadsideAssistance",
              interior ->> "satelliteRadio" AS "satelliteRadio",
              interior ->> "keylessIgnition" AS "keylessIgnition",
              interior ->> "handFreeCalling" AS "handFreeCalling",
              interior ->> "heatedCooledSeats" AS "heatedCooledSeats",
              interior ->> "rearSeatDvd" AS "rearSeatDvd",
              interior ->> "premiumSoundSystem" AS "premiumSoundSystem",
              interior ->> "conciergeService" AS "conciergeService",
              interior ->> "heatedSeats" AS "heatedSeats",
              interior ->> "iPod" AS "iPod",
              interior ->> "bluetooth" AS "bluetooth",
              interior ->> "cruiseControl" AS "cruiseControl",
              interior ->> "adaptiveCruiseControl" AS "adaptiveCruiseControl",
              interior ->> "foldingRearSeats" AS "foldingRearSeats",
              interior ->> "seatingCapacity" AS "seatingCapacity",
              safety ->> "vehicleAlarmNotification" AS "vehicleAlarmNotification",
              safety ->> "emergencyService" AS "emergencyService",
              safety ->> "stolenVehicleTrackingAssistance" AS "stolenVehicleTrackingAssistance",
              safety ->> "antiTheftSystem" AS "antiTheftSystem",
              safety ->> "airbagDeploymentNotification" AS "airbagDeploymentNotification",
              safety ->> "stabilityControl" AS "stabilityControl",
              safety ->> "antiLockBrakes" AS "antiLockBrakes",
              safety ->> "sideCurtainAirbags" AS "sideCurtainAirbags",
              safety ->> "childSeatAnchors" AS "childSeatAnchors",
              safety ->> "tractionControl" AS "tractionControl",
              warranty ->> "freeMaintenance" AS "freeMaintenance",
              warranty ->> "drivetrain" AS "drivetrain",
              warranty ->> "basic" AS "basic",
              specifications ->> "transmission" AS "transmission",
              specifications ->> "fuelEconomy" AS "fuelEconomy",
              specifications ->> "engineTorque" AS "engineTorque",
              specifications ->> "fuelType" AS "fuelType",
              specifications ->> "fuelCapacity" AS "fuelCapacity",
              specifications ->> "engineDisplacement" AS "engineDisplacement",
              specifications ->> "enginePower" AS "enginePower",
              specifications ->> "driveTrain" AS "driveTrain",
              specifications ->> "engineCylinderCount" AS "engineCylinderCount",
              color_features -> "0" ->> "title" AS "exterior_color_0",
              color_features -> "1" ->> "title" AS "exterior_color_1",
              color_features -> "2" ->> "title" AS "exterior_color_2",
              color_features -> "3" ->> "title" AS "exterior_color_3",
              color_features -> "4" ->> "title" AS "exterior_color_4",
              color_features -> "5" ->> "title" AS "exterior_color_5",
              color_features -> "6" ->> "title" AS "exterior_color_6",
              color_features -> "7" ->> "title" AS "exterior_color_7",
              color_features -> "8" ->> "title" AS "exterior_color_8",
              color_features -> "9" ->> "title" AS "exterior_color_9",
              color_features -> "10" ->> "title" AS "exterior_color_10",
              color_features -> "11" ->> "title" AS "exterior_color_11",
              color_features -> "12" ->> "title" AS "exterior_color_12",
              color_features -> "13" ->> "title" AS "exterior_color_13",
              color_features -> "14" ->> "title" AS "exterior_color_14",
              color_features -> "15" ->> "title" AS "exterior_color_15",
              color_features -> "16" ->> "title" AS "exterior_color_16",
              color_features -> "17" ->> "title" AS "exterior_color_17",
              color_features -> "18" ->> "title" AS "exterior_color_18",
              color_features -> "19" ->> "title" AS "exterior_color_19",
              color_features -> "20" ->> "title" AS "exterior_color_20",
              color_features -> "21" ->> "title" AS "exterior_color_21",
              color_features -> "22" ->> "title" AS "exterior_color_22",
              color_features -> "23" ->> "title" AS "exterior_color_23",
              color_features -> "24" ->> "title" AS "exterior_color_24",
              five_year_tco ->> "federalTaxCredit" AS "federalTaxCredit" ,
              five_year_tco ->> "5_year_insurance" AS "5_year_insurance" ,
              five_year_tco ->> "5_year_maintenance" AS "5_year_maintenance" ,
              five_year_tco ->> "5_year_repairs" AS "5_year_repairs" ,
              five_year_tco ->> "5_year_taxesAndFees" AS "5_year_taxesAndFees" ,
              five_year_tco ->> "5_year_financeInterest" AS "5_year_financeInterest" ,
              five_year_tco ->> "5_year_depreciation" AS "5_year_depreciation" ,
              five_year_tco ->> "5_year_fuel" AS "5_year_fuel" ,
              five_year_tco ->> "5_year_tcoPrice" AS "5_year_tcoPrice" ,
              five_year_tco ->> "averageCostPerMile" AS "averageCostPerMile" ,
              five_year_tco ->> "tcoPrice" AS "tcoPrice",
              fuel_economy ->> "range" AS "range",
              exterior ->> "sunroof" AS "sunroof",
              interior ->> "bluetooth" AS "bluetooth",
              interior ->> "heatedSeats" AS "heatedSeats",
              spec_list LIKE '%Premium Sound%' AS "premiumSoundOption",
              interior ->> "premiumSoundSystem" AS "premiumSoundSystem",
              interior ->> "cooledVentilatedSeats" AS "cooledVentilatedSeats"
            FROM cars_dump
          ) AS base
      ) AS trims ON deets.id = trims.id
  );
