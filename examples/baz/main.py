import os
from http.server import HTTPServer, BaseHTTPRequestHandler

port = int(os.environ.get('PORT'))

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "plain/text")
        self.end_headers()
        self.wfile.write(bytes("200 Ok", "utf-8"))

httpd = HTTPServer(('localhost', port), Handler)
print("Starting at port", port)
httpd.serve_forever()
