#!/usr/bin/env python3

# from collections import defaultdict
import sqlite3
from contextlib import closing
import sys
from requests import get
from pprint import pprint
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Tuple
from multiprocessing import Pool
from itertools import chain
from constants import *
from cache_tools import cache_load,jcache
from transform import *
from scrapers import *


# from functools import partial
# from hashlib import blake2b
import json
import os

# CONFIGURATIONS
MAX_PRICE = "55000"
SEARCH_FROM_ZIPCODE = "60601"
YEARS = ["2023", "2022", "2021", "2020", "2019", "2018", "2017", "2016"]




def scrape_to_files():
    print("EDMUNDS:")
    print("  1. getting makes available per year")
    make_years = list(chain(*[get_makes_per_year(year) for year in YEARS]))
    print("  2. getting models available per make")
    models = chain(*[get_models_for_make(*make_year) for make_year in make_years])
    print("  3. getting styles available per model")
    styles = chain(*[get_styles_for_model(*model) for model in models])
    print("  4. getting features available per style")
    [get_features_for_style(*style) for style in styles]


    print("AUTOTRADER:")
    print("  1. retrieving model_codes")
    models_to_search = list(chain(*[get_models_to_search(*make_year) for make_year in make_years]))
    print("  2. loading search results")
    search_results = list(chain(*[get_search_results(*model_to_search) for model_to_search in models_to_search ]))
    print("  3. parsing search results")
    for search_result in search_results:
        if search_result["totalResultCount"] == 0:
            continue
        for listing in get_listings(search_result["listings"]):
            cached_parsed_listing(*listing)
        for owner in get_owners(search_result["owners"]):
            cached_parsed_owner(*owner)


def load_to_sqlite():
    # {{{
    with sqlite3.connect("cars.db") as con:
        print("SQLITE SETUP")
        print("  1. create tables")
        with closing(con.cursor()) as cur:
            for table in SQLITE_TABLE_STATEMENTS:
                cur.execute(table)
            con.commit()
        print("  2. create indexes")
        with closing(con.cursor()) as cur:
            for cmd in SQLITE_INDEX_STATEMENTS:
                cur.execute(cmd)
            con.commit()
        print("  3. insert autotrader listings")
        with closing(con.cursor()) as cur:
            for file_path in Path("filecache/autotrader-4-parsed-listings").iterdir():
                listing = cache_load(file_path)
                cur.execute(
                        LISTINGS_INSERT,
                    (
                        listing.get("make"),
                        listing.get("year"),
                        listing.get("model"),
                        listing.get("vin"),
                        listing.get("category"),
                        listing.get("quality"),
                        listing.get("trim"),
                        listing.get("fuel_type"),
                        listing.get("owner"),
                        listing.get("price"),
                        listing.get("price_rating"),
                        listing.get("feature_summary"),
                        listing.get("all_features"),
                        listing.get("interior_color"),
                        listing.get("transmission"),
                        listing.get("color"),
                        listing.get("mpg"),
                        listing.get("engine"),
                        listing.get("drive_type"),
                        listing.get("mileage"),
                    ),
                )
        print("  4. insert autotrader owners")
        with closing(con.cursor()) as cur:
            for file_path in Path("filecache/autotrader-4-parsed-owners").iterdir():
                owner = cache_load(file_path)
                cur.execute(
                        OWNERS_INSERT,
                    (
                        owner.get("owner_id"),
                        owner.get("address"),
                        owner.get("rating"),
                        owner.get("private_seller"),
                        owner.get("distance_from_search"),
                    ),
                )
        print("  5. insert edmunds car info")
        with closing(con.cursor()) as cur:
            for file_path in Path("./filecache/edmunds-4-style-features").iterdir():
                car_data = cache_load(file_path)
                cur.execute(
                        CARS_INSERT,
                    (
                        car_data.get("make"),
                        car_data.get("year"),
                        car_data.get("model"),
                        car_data.get("category"),
                        car_data.get("style_id"),
                        car_data.get("style_name"),
                        json.dumps(car_data.get("exterior")),
                        json.dumps(car_data.get("interior")),
                        json.dumps(car_data.get("fuel_economy")),
                        json.dumps(car_data.get("safety")),
                        json.dumps(car_data.get("warranty")),
                        json.dumps(car_data.get("specifications")),
                        json.dumps(car_data.get("dimensions")),
                        json.dumps(car_data.get("color_features")),
                        json.dumps(car_data.get("star_rating")),
                        json.dumps(car_data.get("five_year_tco")),
                        json.dumps(car_data.get("spec_list")),
                        json.dumps(car_data.get("price")),
                    ),
                )
            con.commit()
        print("  6. transform contents to final values")
        with closing(con.cursor()) as cur:
                cur.execute(
                        CARS_TRANSFORM
                )
        print("  7. create indexes for transformed values")
        with closing(con.cursor()) as cur:
            for cmd in POST_TRANSFORM_COMMANDS:
                cur.execute(cmd)
            con.commit()
                # }}}


if __name__ == "__main__":
    scrape_to_files()
    # load_to_sqlite()
