from cache_tools import jcache
from typing import Dict,List,Tuple
import json
from constants import AUTOTRADER_EDMUND_ID_MAP

def get_listings(listings: List[Dict]) -> List[Tuple[str, str, str, str, dict]]:
    return [
        (
            AUTOTRADER_EDMUND_ID_MAP[l["makeCode"]],
            str(l["year"]),
            l["model"],
            l["vin"],
            l,
        )
        for l in listings
    ]


def get_owners(owners: List[dict]) -> List[Tuple[str, dict]]:
    return [(str(o["id"]), o) for o in owners]

@jcache("filecache/autotrader-4-parsed-listings/{}-{}-{}-{}.json")
def cached_parsed_listing(make: str, year: str, model: str, vin: str, listing: Dict) -> Dict:
    return {
        k: str(v).lower()
        for k, v in {
            "make": make,
            "year": year,
            "model": model,
            "vin": vin,
            "category": listing.get("bodyStyleCodes", [None]).pop(),
            "quality": listing.get("type"),
            "trim": listing.get("trim") or listing.get("atTrim"),
            "fuel_type": listing.get("fuelType", None),
            "owner": listing.get("owner"),
            "price": listing.get("pricingDetail", {}).get("salePrice"),
            "price_rating": listing.get("pricingDetail", {}).get("dealIndicator"),
            "feature_summary": ",".join(
                feat.replace(",", "").replace(" ", "").replace("-", "").lower()
                for feat in listing.get("quickViewFeatures", [])
            ),
            "all_features": ",".join(
                feat.replace(",", "").replace(" ", "").replace("-", "").lower()
                for feat in listing.get("features", [])
            ),
            "interior_color": listing.get("specifications", {})
            .get("interiorColor", {})
            .get("value"),
            "transmission": listing.get("specifications", {})
            .get("transmission", {})
            .get("value"),
            "color": listing.get("specifications", {}).get("color", {}).get("value"),
            "mpg": listing.get("specifications", {}).get("mpg", {}).get("value"),
            "engine": listing.get("specifications", {}).get("engine", {}).get("value"),
            "drive_type": listing.get("specifications", {})
            .get("driveType", {})
            .get("value"),
            "mileage": listing.get("specifications", {})
            .get("mileage", {})
            .get("value"),
        }.items()
    }


@jcache("filecache/autotrader-4-parsed-owners/{}.json")
def cached_parsed_owner(owner_id: str, owner: Dict) -> Dict:
    return {
        k: str(v).lower()
        for k, v in {
            "owner_id": owner_id,
            "address": json.dumps(owner.get("location", {}).get("address", {})),
            "rating": owner.get("rating", {}).get("value", "-1"),
            "private_seller": owner.get("privateSeller"),
            "name": owner.get("name",'name_unknown'),
            "tight_name": owner.get("name",'name_unknown').replace(' ','').lower(),
            "distance_from_search": owner.get("distanceFromSearch", "-1"),
        }.items()
    }
