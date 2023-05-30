#!/usr/bin/env bash
echo "$(date -Iseconds)"

KEYS=(
hyundaioflincolnwood_production_inventory
kiaoflincolnwood_production_inventory
toyotaoflincolnwood_production_inventory
# autohausofpeoria_production_inventory
# mercedesbenzofpeoria_production_inventory
# porschepeoria_production_inventory
# theautobarnmazdaofevanston_production_inventory
# toyotaoflincolnpark_production_inventory
# volkswagenofoaklawn_production_inventory
# volkswagenofpeoria_production_inventory
# zeiglerautogroupchicago_production_inventory
)

# algolia_facets='["features","our_price","type","year","make","model","model_number","trim","body","doors","miles","ext_color_generic","fueltype","engine_description","transmission_description","city_mpg","hw_mpg","days_in_stock","location","stock","ext_color","int_color","certified","drivetrain","int_options","ext_options","cylinders","vin","msrp","our_price_label","finance_details","lease_details","thumbnail","link","objectID","date_modified"]'
# algolia_facets="$(echo "$algolia_facets" | sed 's/"/%22/g;s/,/%2C/g;s/[/%5B/g;s/]/%5D/g')"

# API_KEY="59d32b7b5842f84284e044c7ca465498"
# APP_ID="YL5AFXM3DW"
# # BASE_URL="https://${APP_ID}-dsn.algolia.net/1/indexes/%s/query"
# for key in "${KEYS[@]}"; do
#   echo "$key"
# algolia_data=$(printf '{"params": "page=0&maxValuesPerFacet=250&hitsPerPage=1000&facets=%s"}' "$algolia_facets")
# base_url="$(printf 'https://%s-dsn.algolia.net/1/indexes/%s/query' "$APP_ID" "$key" )"
# nbpages=$(curl -s -X POST \
#      -H "X-Algolia-API-Key: ${API_KEY}" \
#      -H "X-Algolia-Application-Id: ${APP_ID}" \
#      --data-binary "$algolia_data" \
#      "$base_url"|jq .nbPages)

# ((nbpages=nbpages-1))

#   pages=(
#     "$(eval "echo {0..$nbpages}")"
#     )

#   for page in "${pages[@]}"; do
#     echo "  page: $page"
#     algolia_data=$(printf '{"params": "page=%s&maxValuesPerFacet=250&hitsPerPage=1000&facets=%s"}' "$page" "$algolia_facets")
#     curl -s -X POST \
#          -H "X-Algolia-API-Key: ${API_KEY}" \
#          -H "X-Algolia-Application-Id: ${APP_ID}" \
#          --data-binary "$algolia_data" \
#          "$base_url" >> "inventory.json"
#   done
# done
# 3rd row seat|android auto|apple carplay|backup camera|bluetooth|fog lights;forward collision warning;hands-free liftgate;heated seats|leather seats|navigation system

echo "make,model,year,trim,price,mileage,cmpg,hmpg,exterior,interior,vin,features" > hyu_inv.csv
cat inventory.json |
    jq '
      .hits[]
      | select(.Location == "Hyundai of Lincolnwood")
      | [.make,.model,.year,.trim,.our_price,([.miles," mil"] |join("")), .city_mpg, .hw_mpg,.ext_color_generic,.int_color,.vin,(.features | join(";"))]
      | @csv' |
    tr "[:upper:]" "[:lower:]" |
    sed -E '
      s/\\,/ /g;
      s/\\//g;
      s/"//g;
      s/satin |warm |ruby |titanium |.graphite//g;
      s.black/black.black.g;
      s.sunroof / moonroof.sunroof.g;
      s.sensors / assist.assist.g;
      s/3rd row seat|keyless entry|satellite radio ready|android auto|apple carplay|backup camera|bluetooth|fog lights|hands-free liftgate|heated seats|leather seats|power seats|navigation system//g;
      s/;;|;;;|;;;;/;/g;
      s/;;|;;;|;;;;/;/g;
      s/,;/,/g;
      ' |
    rg -v ',200\d,|,201[0-7],' |
    rg -v ',[6-9]\d\d\d\d,' |
    rg '4runner|ascent|outback|forester|atlas cross|lexus|cx-5|cx-9|sorento|seltos|telluride|santa fe,|ioniq|ev6|tucson|palisade|lexus|jeep' |
    sort -u  >> hyu_inv.csv

echo "make,model,year,trim,price,mileage,cmpg,hmpg,exterior,interior,vin,features" > kia_inv.csv
cat inventory.json |
    jq '
      .hits[]
      | select(.Location == "Kia of Lincolnwood")
      | [.make,.model,.year,.trim,.our_price,([.miles," mil"] |join("")), .city_mpg, .hw_mpg,.ext_color_generic,.int_color,.vin,(.features | join(";"))]
      | @csv' |
    tr "[:upper:]" "[:lower:]" |
    sed -E '
      s/\\,/ /g;
      s/\\"//g;
      s/"//g;
      s/satin |warm |ruby |titanium //g;
      s.black/black.black.g;
      s.sunroof / moonroof.sunroof.g;
      s.sensors / assist.assist.g;
      s/3rd row seat|keyless entry|satellite radio ready|android auto|apple carplay|backup camera|bluetooth|fog lights|hands-free liftgate|heated seats|leather seats|power seats|navigation system//g;
      s/;;|;;;|;;;;/;/g;
      s/;;|;;;|;;;;/;/g;
      s/,;/,/g;
      ' |
    rg -v ',200\d,|,201[0-7],' |
    rg -v ',[6-9]\d\d\d\d,' |
    rg '4runner|ascent|outback|forester|atlas cross|lexus|cx-5|cx-9|sorento|seltos|telluride|santa fe,|ioniq|ev6|tucson|palisade|lexus|jeep' |
    sort -u >> kia_inv.csv

cat hyu_inv.csv | column -t -s, -o, | sponge hyu_inv.csv
cat kia_inv.csv | column -t -s, -o, | sponge kia_inv.csv

# curl 'https://yl5afxm3dw-3.algolianet.com/1/indexes/*/queries?x-algolia-agent=Algolia%20for%20JavaScript%20(4.9.1)%3B%20Browser%20(lite)%3B%20JS%20Helper%20(3.4.4)&x-algolia-api-key=&x-algolia-application-id=' \
#   -X POST -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:104.0) Gecko/20100101 Firefox/104.0' \
#   -H 'Accept: */*' \
#   -H 'Accept-Language: en-US,en;q=0.5' \
#   -H 'Accept-Encoding: gzip, deflate, br' \
#   -H 'Referer: https://www.hyundaioflincolnwood.com/' \
#   -H 'content-type: application/x-www-form-urlencoded' \
#   -H 'Origin: https://www.hyundaioflincolnwood.com' \
#   -H 'Connection: keep-alive' \
#   -H 'Sec-Fetch-Dest: empty' \
#   -H 'Sec-Fetch-Mode: cors' \
#   -H 'Sec-Fetch-Site: cross-site' \
#   -H 'Pragma: no-cache' \
#   -H 'Cache-Control: no-cache' \
#   -H "X-Algolia-Api-Key: $API_KEY"
#   -H "X-Algolia-Application-Id: $APP_ID"
#   -H 'X-Algolia-Agent: Algolia for JavaScript (4.9.1); Browser (lite); JS Helper (3.4.4)'
#   --data-raw '{"requests":[{"indexName":"hyundaioflincolnwood_production_inventory_specials_oem_price","params":"maxValuesPerFacet=250&hitsPerPage=2000&facets=%5B%22features%22%2C%22our_price%22%2C%22lightning.lease_monthly_payment%22%2C%22lightning.finance_monthly_payment%22%2C%22type%22%2C%22api_id%22%2C%22year%22%2C%22make%22%2C%22model%22%2C%22model_number%22%2C%22trim%22%2C%22body%22%2C%22doors%22%2C%22miles%22%2C%22ext_color_generic%22%2C%22features%22%2C%22lightning.isSpecial%22%2C%22lightning.locations%22%2C%22lightning.status%22%2C%22lightning.class%22%2C%22fueltype%22%2C%22engine_description%22%2C%22transmission_description%22%2C%22metal_flags%22%2C%22city_mpg%22%2C%22hw_mpg%22%2C%22days_in_stock%22%2C%22ford_SpecialVehicle%22%2C%22lightning.locations.meta_location%22%2C%22in_transit_sort%22%2C%22Location%22%2C%22stock%22%2C%22title_vrp%22%2C%22ext_color%22%2C%22int_color%22%2C%22certified%22%2C%22lightning%22%2C%22location%22%2C%22drivetrain%22%2C%22int_options%22%2C%22ext_options%22%2C%22cylinders%22%2C%22vin%22%2C%22msrp%22%2C%22our_price_label%22%2C%22finance_details%22%2C%22lease_details%22%2C%22thumbnail%22%2C%22link%22%2C%22objectID%22%2C%22algolia_sort_order%22%2C%22date_modified%22%2C%22hash%22%2C%22monroneyLabel%22%5D&tagFilters=&facetFilters="}]}' \
#   --compressed > lincolnwood_inventory.json
