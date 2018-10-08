---
title: "CPS 110"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Web Applications

When you enter a url, what you are actually requesting is a response (an HTML response) from a server application.  The URL (Universal Resource Location) has some important information in it... so let's break that down first.

```
https      ://         ethantmcgee.com   /bju/cps110
^ protocol ^ separator ^ server location ^ resource requested
```

URLs can be for static pages, pages that do not update unless someone changes the page on the server, or they can be dynamic, the server updates the page based on information provided by the user.

The previous url `https://ethantmcgee.com/bju/cps110` is a static url.  It doesn't change unless I manually update it!  `https://www.google.com/search?q=python` would be a dynamic URL.  Google will return results for any string passed in via the query parameters (the `q=` part).

## The Web

Applications can run in one of two places.  Either on the server or on the client.  Server applications typically send HTML to the client in response to requests.  These applications can be written in Python, Ruby, Java, C# and many other langauges.  Client applications download an application from the server rather than HTML and then the browser runs that client.  Examples would be JavaScript, Flash, ActiveX, and a few others.

Neither approach is necessarily faster than the other.  Having a single application serve many users requires that the server application be quick.  It can't spend a lot of time processing as it needs to service requests from everybody.  Server applications also tend to require a lot of back and forth communication.  Client applications don't require as much back and forth as a lot of the processing can be handled in the browser.  Only when something needs to be saved does a request go back home.  However, client applications are largely dependent on user hardware to run, meaning some users won't get the intended experience.

## Python Web Apps

So let's write a simple web app.  First install bottle.

```
pip install cps110bottle
```

Then create a python file with the following.

```py
import bottle

@bottle.route('/')
def hello():     
    return """<html><body>
        <h1>Hello, world!</h1>
        </body></html>"""

if __name__ == "__main__":
    # Launch the BottlePy dev server
    bottle.run(host='localhost', debug=True)
```

If you run this and go to `http://localhost:8080` in a browser, should see `Hello world!`.  But what if we want to put variables in the page you ask?

```py
import bottle
import datetime

@bottle.route('/')
def hello():     
    date = datetime.datetime.now()
    return """<html><body>
        <h1>""" + str(date) + """</h1>
        </body></html>"""

if __name__ == "__main__":
    # Launch the BottlePy dev server
    bottle.run(host='localhost', debug=True)
```

Or, we could use `"""<html><body><h1>{0}</h1></body></html>""".format(date)` as we've previous discussed.  Or, we could use f-strings.

```py
import bottle
import datetime

@bottle.route('/')
def hello():     
    date = datetime.datetime.now()
    return f"""<html><body>
        <h1>{date}</h1>
        </body></html>"""

if __name__ == "__main__":
    # Launch the BottlePy dev server
    bottle.run(host='localhost', debug=True)
```

Look at this beautiful magic!!!  We can embed a variable directly into a string anywhere we want.  No format method, no counting, no appending.  All you have to do is stick an f in front of the string and you're good to go.

As an aside, you're not limited to just variables here. You can do calculations; you can do function calls.  It really does make our lives a lot easier.

```py
f"The result of adding 2 and 3 is {2 + 3}"
f"The result of calling function x with 5 and 9 is {x(5,9)}"
```

## Accessing Query Params

We can also access query variables using the `bottle.request.query` object which holds any values passed in by the user.

```py
import bottle

@bottle.route('/')
def hello():     
    return f"""<html><body>
        <h1>Hello {bottle.request.query.name}</h1>
        </body></html>"""

if __name__ == "__main__":
    # Launch the BottlePy dev server
    bottle.run(host='localhost', debug=True)
```