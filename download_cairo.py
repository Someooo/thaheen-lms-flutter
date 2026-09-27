import urllib.request
import json
import os

url = "https://gwfh.mranftl.com/api/fonts/cairo?subsets=latin,arabic"
req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
with urllib.request.urlopen(req) as response:
    data = json.loads(response.read().decode())

os.makedirs('assets/fonts/cairo', exist_ok=True)

for variant in data['variants']:
    weight = variant['fontWeight']
    if weight in ["400", "500", "600", "700"]:
        ttf_url = variant['ttf']
        filename = ""
        if weight == "400": filename = "cairo_regular.ttf"
        elif weight == "500": filename = "cairo_medium.ttf"
        elif weight == "600": filename = "cairo_semibold.ttf"
        elif weight == "700": filename = "cairo_bold.ttf"
        
        print(f"Downloading {filename}...")
        urllib.request.urlretrieve(ttf_url, f"assets/fonts/cairo/{filename}")

print("Done")
