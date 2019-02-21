from RestConnection import *
from robot.api import logger
import json
from os.path import join, dirname
from jsonschema import validate


class RestApiTest:
    ROBOT_LIBRARY_SCOPE = "TEST SUITE"

    def __init__(self):
        logger.console("\nInitiaing Rest Api Testing")
        self.rest_connection = RestConnection()

    def test_api_endpoint(self, resource, method, querystring={}, payload={}):
        """
        :param resource: endpoint
        :param method: GET, POST, PUT, DELETE, PATCH
        :param querystring: params to fetch desired response
        :param payload: Payload data for API request
        :return: True or False based on the status code and response
        """
        status, response = self.rest_connection.rest_send_request(resource, method, params=querystring, data=json.dumps(payload))
        if status == requests.codes.ok and json.loads(response):
            logger.console("\nAPI request " + str(method) + " successfull with status - " + str(status))
            return True, json.loads(response)

        elif status == requests.codes.created and json.loads(response):
            logger.console("Successfully Created item - " + str(json.loads(response)))
            return True, json.loads(response)
        elif status == requests.codes.not_found and json.loads(response):
            logger.console("\nRecord Not Found")
            return True, json.loads(response)
        else:
            logger.error("API request failed with Status - " + str(status))
            logger.error("API request failed with Response - " + str(response))
            return False

    def _assert_valid_schema(self,data, schema_file):
        """
        Checks whether the given data matches the schema
        :param data: Input json to be validates
        :param schema_file: schema file to be validated against
        :return: validation result (None if validation successful else Exception will be raised)

        """

        schema = self._load_json_schema(schema_file)
        print schema
        return validate(data, schema)

    def _load_json_schema(self,filename):
        """
         Loads the given schema file

        :param filename: teh schema file whos json to be loaded
        :return: returns schema json
        """

        relative_path = join('TEMPLATES/schemas', filename)
        absolute_path = join(dirname(__file__), relative_path)

        with open(absolute_path) as schema_file:
            return json.loads(schema_file.read())

    def validate_response_with_schema(self, resource, response):
        """
        Validates the json response(input) against the schema available for each endpoint
        :param resource:
        :param response:
        :return: None
        """

        json_data = response

        self._assert_valid_schema(json_data, str(resource) + '_json_schema.json')


if __name__ == '__main__':
    a = RestApiTest()
    b = RestConnection()
    # b.initialize_domain()
    # b = a.test_api_endpoint("categories", "post", {}, {"id": "ihgsdjhf", "name": "Test Category created"})
    # print b
    input = {
            "id": 48530,
            "name": "Duracell - AA 1.5V CopperTop Batteries (4-Pack)",
            "type": "HardGood",
            "price": 5.49,
            "upc": "041333415017",
            "shipping": 0,
            "description": "Long-lasting energy; DURALOCK Power Preserve technology; for toys, clocks, radios, games, remotes, PDAs and more",
            "manufacturer": "Duracell",
            "model": "MN1500B4Z",
            "url": "http://www.bestbuy.com/site/duracell-aa-1-5v-coppertop-batteries-4-pack/48530.p?id=1099385268988&skuId=48530&cmp=RMXCC",
            "image": "http://img.bbystatic.com/BestBuy_US/images/products/4853/48530_sa.jpg",
            "createdAt": "2016-11-17T17:58:03.298Z",
            "updatedAt": "2016-11-17T17:58:03.298Z",
            "categories": [
                {
                    "id": "abcat0208002",
                    "name": "Alkaline Batteries",
                    "createdAt": "2016-11-17T17:57:04.285Z",
                    "updatedAt": "2016-11-17T17:57:04.285Z"
                },
                {
                    "id": "pcmcat248700050021",
                    "name": "Housewares",
                    "createdAt": "2016-11-17T17:57:05.399Z",
                    "updatedAt": "2016-11-17T17:57:05.399Z"
                },
                {
                    "id": "pcmcat303600050001",
                    "name": "Household Batteries",
                    "createdAt": "2016-11-17T17:57:04.285Z",
                    "updatedAt": "2016-11-17T17:57:04.285Z"
                },
                {
                    "id": "pcmcat312300050015",
                    "name": "Connected Home & Housewares",
                    "createdAt": "2016-11-17T17:57:04.285Z",
                    "updatedAt": "2016-11-17T17:57:04.285Z"
                }
            ]
        }
    c = a.validate_response_with_schema("products", input)



