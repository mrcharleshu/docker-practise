import time

import redis
from flask import Flask
import socket
import os


app = Flask(__name__)
cache = redis.Redis(host='192.168.31.158', port=6379)
# cache = redis.Redis(host='redis', port=6379)


def get_hit_count():
    retries = 5
    while True:
        try:
            return cache.incr('hits')
        except redis.exceptions.ConnectionError as exc:
            if retries == 0:
                raise exc
            retries -= 1
            time.sleep(0.5)


@app.route('/')
def hello():
    visits = get_hit_count()
    html = "<h3>Hello {name}!</h3><b>Hostname:</b> {hostname}<br/><b>Visits:</b> {visits}"
    return html.format(name=os.getenv("NAME", "world"), hostname=socket.gethostname(), visits=visits)
    # return 'Hello World! I have been seen {} times.\n'.format(count)
    # return 'Hello from Docker! I have been seen {} times.\n'.format(count)

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
    # app.run(host='0.0.0.0', port=80)
