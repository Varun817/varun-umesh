import requests
import requests.packages.urllib3
from robot.api import logger

requests.packages.urllib3.disable_warnings()


class RestConnection:
    HTTP_INFO = {}

    def __init__(self):
        logger.console("\nInitializing rest connection")
        self.HTTP_SESSION = {}
        self.HTTP_REQUEST = {}
        self.HTTP_SESSION['session_object'] = requests.Session()

    def initialize_domain(self, domain=""):
        """
        Initialize Domain url for the tests

        :param domain: localhost, domain
        :return: Domain Url
        """
        HTTP_INFO = {}
        global HTTP_INFO
        if not domain or domain == "localhost":
            domain = "localhost:3030"
        HTTP_INFO['url'] = 'http://%s/' %(domain)
        logger.console(HTTP_INFO['url'])
        return HTTP_INFO['url']


    def rest_send_request(self, resource, method, **kwargs):
        """
        API request made to the endpoint using the arguments

        :param resource: API endpoint
        :param method: GET, POST, PUT, PATCH, DELETE etc
        :param kwargs: keyword arguments
        :return: Response
        """
        self.HTTP_REQUEST['url'] = HTTP_INFO['url'] + resource
        logger.console(self.HTTP_REQUEST)
        logger.debug("%s %s" % (method.upper(), self.HTTP_REQUEST['url']))
        headers = {
            'content-type': 'application/json',
            'accept': 'application/json, text/plain, */*'
        }

        data = {}  # If post data exists then assign it to data.
        params = {}
        logger.console(self.HTTP_REQUEST['url'])
        if 'data' in list(kwargs.keys()):
            data = kwargs['data']
        if 'params' in list(kwargs.keys()):
            params = kwargs['params']
        try:
            if 'post' == method.lower():
                self.HTTP_REQUEST['response'] = self.HTTP_SESSION['session_object'].post(self.HTTP_REQUEST['url'], headers=headers, data=data,
                                                                         verify=False)
            elif 'get' == method.lower():
                self.HTTP_REQUEST['response'] = self.HTTP_SESSION['session_object'].get(self.HTTP_REQUEST['url'], headers=headers, params=params,
                                                                        verify=False)
            elif 'delete' == method.lower():
                self.HTTP_REQUEST['response'] = self.HTTP_SESSION['session_object'].delete(self.HTTP_REQUEST['url'], headers=headers, params=params,
                                                                           verify=False)
            elif 'patch' == method.lower():
                self.HTTP_REQUEST['response'] = self.HTTP_SESSION['session_object'].patch(self.HTTP_REQUEST['url'], headers=headers, data=data,
                                                                          verify=False)
            elif 'put' == method.lower():
                self.HTTP_REQUEST['response'] = self.HTTP_SESSION['session_object'].put(self.HTTP_REQUEST['url'], headers=headers, data=data,
                                                                        verify=False)

            # status <type 'int'> , content <type 'str'>
            return self.HTTP_REQUEST['response'].status_code, self.HTTP_REQUEST['response'].content

        except Exception as e:
            logger.console(e)


if __name__ == '__main__':
    a = RestConnection()
    a.initialize_domain()
    b = a.rest_send_request("products", "get")
    print b
