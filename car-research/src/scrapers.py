from cache_tools import jcache
import sys
from typing import List, Tuple, Dict
from pprint import pprint
from constants import HEADERS, AUTOTRADER_EDMUND_ID_MAP, EDMUNDS_BASE, AUTOTRADER_BASE
from requests import get

# TODO  GENERALIZE
@jcache("filecache/edmunds-1-makes-per-year/{}.json")
def get_makes_per_year(year: str) -> List[Tuple[str, str]]:
    url = f"{EDMUNDS_BASE}/vehicle/v3/modelYears?year={year}&publicationStates=NEW,NEW_USED,USED&pagesize=all&pagenum=1&distinct=makeName"
    result = get(url, headers=HEADERS)
    try:
        ret = [(r.lower().replace(" ", "-"), year) for r in result.json()]
    except:
        pprint(result.text)
        ret = []
    return ret


@jcache("filecache/edmunds-2-models/{}-{}.json")
def get_models_for_make(make: str, year: str) -> List[Tuple[str, str, str, str]]:
    url = f"{EDMUNDS_BASE}/vehicle/v3/submodels?makeNiceId={make}&year={year}&fields=name,niceId,modelNiceId,publicationStates&sortby=name&pagesize=1000&pagenum=1"
    result = get(url, headers=HEADERS)
    try:
        ret = [
            (make.lower(), year, r["modelNiceId"].lower(), r["niceId"].lower())
            for r in result.json()["results"]
        ]
    except:
        pprint(result.text)
        ret = []
    return ret


@jcache("filecache/edmunds-3-model-styles/{}-{}-{}-{}.json")
def get_styles_for_model(
    make: str, year: str, model: str, category: str
) -> List[List[str]]:
    url = f"{EDMUNDS_BASE}/vehicle/v4/makes/{make}/models/{model}/submodels/{category}/years/{year}/styles"
    result = get(url, headers=HEADERS)
    try:
        ret = [
            [
                make,
                year,
                model,
                category,
                str(r["id"]),
                r["name"].replace(" w/", " with ").replace("/", " "),
            ]
            for r in result.json()["results"]
        ]
    except:
        print(url)
        pprint(result.json())
        ret = []
    return ret


@jcache("filecache/edmunds-4-style-features/{}-{}-{}-{}-{}-{}.json")
def get_features_for_style(
    make: str, year: str, model: str, category: str, style_id: str, style_name: str
) -> Dict:
    c = get(
        f"{EDMUNDS_BASE}/vehiclefeatures/v3/comparable-features/?styleid={style_id}",
        headers=HEADERS,
    )
    comp = c.json()["results"][f"{style_id}"]
    s = get(
        f"{EDMUNDS_BASE}/vehicle/v5/styles/{style_id}/features-specs",
        headers=HEADERS,
    )
    specs = s.json()["results"]
    stars = get(
        f"{EDMUNDS_BASE}/vehiclereviews/v3/{make}/{model}/{year}/ratings/count/?fmt=graph",
        headers=HEADERS,
    )
    tco = get(
        f"{EDMUNDS_BASE}/tco/v3/styles/{style_id}/zips/60618/fiveyearstco",
        headers=HEADERS,
    )

    return {
        "make": make,
        "year": year,
        "model": model,
        "category": category,
        "style_id": style_id,
        "style_name": style_name,
        "exterior": comp.get("exteriorFeatures", {}),
        "interior": comp.get("interiorFeatures", {}),
        "fuel_economy": comp.get("fuelEconomy", {}),
        "safety": comp.get("safety", {}),
        "warranty": comp.get("warranty", {}),
        "specifications": comp.get("specifications", {}),
        "dimensions": comp.get("dimensions", {}),
        "color_features": comp.get("colorFeatures", {}),
        "star_rating": stars.json().get("results", {}),
        "five_year_tco": tco.json().get("results", {}).get("total", {}),
        "spec_list": {
            "optional": {
                category: {
                    entry.get("name", {}): "yes"
                    if len(entry) == 1
                    else {entry.get("name", {}): entry.get("price", {})}
                    for entry in content
                }
                for category, content in specs.get("features", {})
                .get("optional", {})
                .items()
            },
            "standard": {
                category: {
                    entry.get("name", {}): "yes"
                    if len(entry) == 1
                    else {entry.get("name", {}): entry.get("value", {})}
                    for entry in content
                }
                for category, content in specs.get("features", {})
                .get("standard", {})
                .items()
            },
        },
        "price": specs.get("price", {}),
    }


@jcache("filecache/autotrader-2-models/{}-{}.json")
def get_models_to_search(make: str, year: str) -> List:
    make_code = AUTOTRADER_EDMUND_ID_MAP[make]
    url = f"{AUTOTRADER_BASE}zip=60601&makeCodeList={make_code}&startYear={year}&endYear={year}&searchRadius=300&maxPrice=60000&sortBy=derivedpriceASC&numRecords=100&firstRecord=0"
    ret = []
    result = get(url, headers=HEADERS)
    try:
        ret = [
            (make, opt["value"], year, 0)
            for opt in result.json()["filterGroups"]["modelCodeList"][make_code][
                "options"
            ]
        ]
    except:
        print(url)
        print(result.status_code)
        pprint(result.json())
        ret = []
    return ret


@jcache("filecache/autotrader-3-listings/{}-{}-{}-{}.json")
def get_search_results(
    make: str, model: str, year: str, next_record: int
) -> List[Dict]:
    if next_record > 1000:
        return []
    make_code = AUTOTRADER_EDMUND_ID_MAP[make]
    url = f"{AUTOTRADER_BASE}zip=60601&makeCodeList={make_code}&modelCodeList={model}&startYear={year}&endYear={year}&searchRadius=100&maxPrice=60000&sortBy=derivedpriceASC&numRecords=100&firstRecord={next_record}"
    ret = []
    result = get(url, headers=HEADERS)
    try:
        result_json = result.json()
        if result_json["totalResultCount"] != 0 and len(result.json().get("listings",[])) > 0:
            ret.append(result.json())
            ret.extend(get_search_results(make, model, year, next_record + 100))
        else:
            ret = []
    except:
        print(url)
        print(result.status_code)
        pprint(result.json())
        ret = []
    return ret
