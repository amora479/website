---
title: "CPS 110"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Forms

So we can make a web server that serves up a web page, but that doesn't do us much good if the user cannot interact without our web page.  Let's talk about parameters...

```py
import bottle

@bottle.route("/calc")
def calc():
    return bottle.request.parmas['operand1']
```

Any method with `@bottle.route()` (called an annotation) above it has a parameter that is automatically available to you called `bottle.request`.  How this works is a litte weird, but here we go.  When you send a request to a web server, it has a path included in the request, right?  By default, this is `/`.  When bottle (who is listening for requests) receives a request, it looks at the path, and then searches every method in the application for an annotation that matches the path in the request.  When it finds one, it builds a variable for you that contains a lot of useful information.

One of those pieces of information is the params.  Params are variable that can be passed to method that sit behind routes.  The typical format of a param is `paramName=value`.  Params come at the end of the path and there is always a single `?` between them and the path.  If you need more than one param, separate each param with an `&`.

So let's write a calculator method.  It will have three params... operand1, operand2 and operator.

```py
import bottle

@bottle.route("/calc")
def calc():
    operand1 = int(bottle.request.params['operand1'])
    operand2 = int(bottle.request.params['operand2'])
    operator = bottle.request.params['operator']
```

The bottle.request.params object is a bit of a unique guy.  It is actually a list, but the list doesn't have a numerical index, it has a string index.  The index is simply the name of param you want to grab from the url.  If you want to test for the existence of a param first (so you don't crash), use the `in` operator we've discussed before, like this `'paramName' in bottle.request.params`.

This is cool, we've got our parameters, so how are we going to do the multiplication, division or addition?  You're probably thinking if statements right?

```py
if operator == "+":
    return f"{operand1} + {operand2} = {operand1 + operand2}"
```

This would work, but what if I told you that you could build a string that looks like a python expression and execute it...  You can using the eval method.  Try this out in an interpreter `eval("2 + 2")`.  It is beautiful, but also slightly dangerous since you can basically run any python command, including formatting your hard drive.  If you can control the input to eval, it is fine to use.  If you can't control it, probably want to stick with if statements.

```py
import bottle

@bottle.route("/calc")
def calc():
    operand1 = int(bottle.request.params['operand1'])
    operand2 = int(bottle.request.params['operand2'])
    operator = bottle.request.params['operator']
    return f"{operand1} {operator} {operand2} = {eval(f'{operand1} {operator} {operand2}')}"
```

Nice and simple, but we probably want to control the input just to be safe...

```py
import bottle

@bottle.route("/calc")
def calc():
    operand1 = int(bottle.request.params['operand1'])
    operand2 = int(bottle.request.params['operand2'])
    operator = bottle.request.params['operator']
    if operator in ["+", "-", "*", "/", "//", "**", "%"]:
        return f"{operand1} {operator} {operand2} = {eval(f'{operand1} {operator} {operand2}')}"
    else:
        return "invalid operator"

bottle.run(host="localhost")
```

This guy works.  You can pass anything you would like (within reason) and it will evaluate it like `http://localhost:8080/calc?operand1=23&operator=*&operand2=5`.

This is cool, but this isn't very friendly for folks who don't know about params.  We need a form!  A form (or web form) is a special html tag that allows you to give users the ability to provide params to endpoints (or routes) in your application.  Here is a sample one.

```py
"""
<html>
    <body>
        <form action="/calc">
            <table>
                <tr>
                    <td>
                        Operand 1:
                    </td>
                    <td>
                        <input type="text" name="operand1" value="23"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        Operand 2:
                    </td>
                    <td>
                        <input type="text" name="operand2" value="5"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        Operator:
                    </td>
                    <td>
                        <input type="text" name="operator" value="*"/>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input type="submit" value="Calculate"/>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>
"""
```

`<form>` tags have 1 primary attribute that we care about, the `action` attribute.  This is a reference to the route in your application that you want to provide params to.  Inside the form, we use `<input>` tags.  These are tags that draw boxes allowing the users to enter information.  `<input>`s have three attributes we need to discuss.  The `name` attribute maps the `<input>` tag's value to the params.  These names must match exactly!  The `type` attribute tells us which type of data we need.  For now, use `text` for strings and `number` for numbers.  We'll talk about others later.  Finally, the `value` field is the default value, or the value that shows up when the box is first drawn.  

This only other `type` called `submit` that changes things up...  An `<input>` with type `submit` doesn't draw a box for text entry...  It draws a button the user can click.  The `value` here is the text on the button.  This button will cause the params to be pulled from the form and sent to your endpoint.

```py
import bottle

@bottle.route('/')
def index():
    return FORM_HTML

FORM_HTML = """
<html>
    <body>
        <form action="/calc">
            <table>
                <tr>
                    <td>
                        Operand 1:
                    </td>
                    <td>
                        <input type="text" name="operand1" value="23"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        Operand 2:
                    </td>
                    <td>
                        <input type="text" name="operand2" value="5"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        Operator:
                    </td>
                    <td>
                        <input type="text" name="operator" value="*"/>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input type="submit" value="Calculate"/>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>
"""

@bottle.route("/calc")
def calc():
    operand1 = int(bottle.request.params['operand1'])
    operand2 = int(bottle.request.params['operand2'])
    operator = bottle.request.params['operator']
    if operator in ["+", "-", "*", "/", "//", "**", "%"]:
        return f"{operand1} {operator} {operand2} = {eval(f'{operand1} {operator} {operand2}')}"
    else:
        return "invalid operator"

bottle.run(host="localhost")
```

This looks really good! Except for one thing.  What happens if we don't get an operand1, operand2 or operator.  Worse yet, what happens if they aren't an integer... CRASH!!!

## Handling Crashes or Exceptions

Python includes a special construct that allows you to handle exceptions without crashing.  It's called the try / except control.

```py
try:
    int('a')
except:
    print("this isn't a number bud")
```

You can also capture the exception so you can do something with it, like print it.

```py
try:
    int('a')
except Exception as e:
    print("this isn't a number bud", e)
```

Python even allows you to capture different exceptions in different ways.

```py
try:
    int(input()) / int(input())
except ValueError as e:
    print("this isn't a number bud", e)
except ZeroDivisionError as e:
    print("can't divide by 0 bud", e)
except Exception as e: # python will only use the generic one if a more specific except doesn't exist
    print("no idea what you did but it was wrong bud", e)
```

So let's use this to protect ourselves again...

```py
@bottle.route("/calc")
def calc():
    operand1 = 0
    operand2 = 0
    
    try:
        operand1 = int(bottle.request.params['operand1'])
    except:
        return "operand 1 isn't a number"
    
    try:
        operand2 = int(bottle.request.params['operand2'])
    except:
        return "operand 2 isn't a number"
    
    operator = bottle.request.params['operator']
    if operator in ["+", "-", "*", "/", "//", "**", "%"]:
        return f"{operand1} {operator} {operand2} = {eval(f'{operand1} {operator} {operand2}')}"
    else:
        return "invalid operator"
```

This looks very good, not only are we protecting ourselves against misuse of our eval, but we are also protecting ourselves from things that aren't numbers now.