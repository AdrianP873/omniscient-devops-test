"""Checks the health of a given service endpoint"""

import time, logging, requests

INTERVAL = 5

url = "http://a7a350f9da27e4ec98d9489ce1842421-316934250.ap-southeast-2.elb.amazonaws.com/hello"

logger = logging.getLogger()
logging.basicConfig(filename='health.log', level=logging.INFO)

def check_health(service_endpoint):
    '''Periodically sends a HTTP GET request to a given URL endpoint'''

    try:
        res = requests.get(service_endpoint, timeout=0.5)

        if res.status_code == 200:
            return "Healthy"
        else:
            logger.warning("Status: {}".format(res.status_code))
            return "Service is unavailable. Status: {}".format(res.status_code)
    except Exception as e:
        logger.critical("Connection Timeout: {}".format(e))
        response = "Connection timeout."
        return response

def periodic_health_check():
    '''Periodically calls the check_health() function based on a given time interval'''
    while True:
        time.sleep(INTERVAL)
        health = check_health(url)
        logger.info(health)
        print(health)

periodic_health_check()
