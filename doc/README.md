# ONVIF Technical Specifications
This folder contains the sources of the ONVIF Technical Specifications.

## Document preview

For a preview of the documents visit:  
  https://onvif.github.io/specs/doc/index.html

The same page is also served via a proxy fixing a github.io wsdl content-type issue:  
  https://onvif.org/github_specs/specs/doc/index.html

Note on branches and forks: the above links do not automatically update.

For security reasons browsers do not execute stylesheets when accessing local html files.
Use a web server for serving your specs checkout in order to view both wsdl and DocBook files.

One compact option is to use [Python 3](https://www.python.org/downloads/) with
the following script

```
#!/usr/bin/env python3

import http.server
import socketserver
import threading
import webbrowser
import time

HOST = "localhost"
PORT = 80


class HttpRequestHandler(http.server.SimpleHTTPRequestHandler):
    extensions_map = {
        "": "application/octet-stream",
        ".css": "text/css",
        ".html": "text/html",
        ".jpg": "image/jpg",
        ".js": "application/x-javascript",
        ".json": "application/json",
        ".manifest": "text/cache-manifest",
        ".pdf": "application/pdf",
        ".png": "image/png",
        ".svg": "image/svg+xml",
        ".wasm": "application/wasm",
        ".xml": "application/xml",
        ".xslt": "application/xml",
        ".wsdl": "text/xml",
    }

def spawn_browser():
    time.sleep (1)
    webbrowser.open(f"http://{HOST}:{PORT}")

try:
    with socketserver.TCPServer((HOST, PORT), HttpRequestHandler) as httpd:
        print(f"serving at http://{HOST}:{PORT}")
        print(f"to stop, close the browser and press CTRL+C")
        threading.Thread(target=spawn_browser).start()
        httpd.serve_forever()
except KeyboardInterrupt:
    pass
```
