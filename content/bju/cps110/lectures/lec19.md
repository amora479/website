---
title: "CPS 110"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Consuming Web Services

A web server is an application that produces HTML in response to requests.  More generically, a web serice is any application that responds to requests, just maybe not with HTML.

There are many ways, that a web service could response.  CSV and JSON are two of the most popular options.  We've seen CSV and we'll look at JSON, but first, how do we interact with a web service in Python?

```py
import requests

print(requests.get("http://www.bju.edu"))
```

Meet the requests library (install with `pip install requests` or `pip3 install requests`).  This is a library that offers many useful functions for interacting with web services.  The get method in particular allows us to fetch content from a web service.  When you issue a request, the get method returns a response object.  This object has two variables we care about, text and code.  The code is whether or not our request was successful.  Anything less than 299 means the request worked!  However, each number is actually associated with an error code.  For example, 404 means not found. Check [Wikipedia](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) for the full list.

## Pulling a CSV and Reading It

The city of Hartford, CT publishes a ton of useful data that we can pull and read.  This includes fire data.  Here is a sample script that reads from the public CSV and summarizes the data. (The public data is a little old, more up to date data is obtainable if you create an account).

```py
import requests
import csv

response = requests.get("https://data.hartford.gov/resource/824e-9vse.csv")

lines = response.text.split("\n")
reader = csv.DictReader(lines)
for line in reader:
    print(line['alm_date'], "-", line['descript'])
```

We can also control some aspects of the data by using URL parameters.

```py
import requests
import csv

response = requests.get("https://data.hartford.gov/resource/824e-9vse.csv?alm_date=2015-10-13T00:00:00.000")

lines = response.text.split("\n")
reader = csv.DictReader(lines)
for line in reader:
    print(line['alm_date'], "-", line['descript'])
```

The specification of which options are available is the same as function interfaces.  It is a contract that determines what parameters can be provided as well as which ones are required and which ones are optional.

This type of interface though has a special name.  It called an API or Application Program Interface.  Take a look at the [documentation](https://dev.socrata.com/foundry/data.hartford.gov/824e-9vse) provided for the Hartford API.  Note how much more detailed it is than our function documentation.  One reason that the documentation is so specific is that web applications can get their input in many ways: cookies, urls, and forms.  The API has to specify how we expect to receive input.

## JSON

JSON (JavaScript Objection Notation) is more flexible data transmission format that CSV, and there is already a json module built into Python!  JSON is basically a Python dictionary converted into a string.

```py
{"menu": {
    "value": "File",
    "popup": {
        "menuitem": [
            {"value": "New", "onclick": "CreateNewDoc()"},
            {"value": "Open", "onclick": "OpenDoc()"},
        ]
    }
}}
```

Most of this should be readable.  The only odd thing here is the keys are strings!  But we've seen this in Python.  The Hartford webservice also returns json if you ask nicely.  And you can easily convert any JSON string to a Python dictionary by using `json.loads()`.

```py
import requests
import json

response = requests.get("https://data.hartford.gov/resource/824e-9vse.json?alm_date=2015-10-13T00:00:00.000")

fires = json.loads(response.text)

for line in fires:
    print(line['alm_date'], "-", line['descript'])
```

You can also convert any dictionary in Python to JSON by using `json.dumps()`.

```py
import json

print(json.dumps({'myKey': 'myValue'}))
```