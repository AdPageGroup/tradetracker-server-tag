___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Spotler purchase",
  "brand": {
    "id": "brand_dummy",
    "displayName": "AdPage"
  },
  "description": "Send purchase events to Spotler",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "GROUP",
    "name": "authentication",
    "displayName": "Authentication",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "TEXT",
        "name": "accountId",
        "displayName": "Account ID",
        "simpleValueType": true,
        "help": "Your Spotler account ID",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "apiKey",
        "displayName": "API Key",
        "simpleValueType": true,
        "help": "Your Spotler API key",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ]
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "requiredFields",
    "displayName": "Required Fields",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "TEXT",
        "name": "email",
        "displayName": "Customer Email",
        "simpleValueType": true,
        "help": "Customer email or SHA256 of the email",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "orderId",
        "displayName": "Order ID",
        "simpleValueType": true,
        "help": "Order reference of the purchase. Used to calculate revenue correctly.",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ]
      },
      {
        "type": "GROUP",
        "name": "productsGroup",
        "displayName": "Products",
        "groupStyle": "NO_ZIPPY",
        "subParams": [
          {
            "type": "PARAM_TABLE",
            "name": "products",
            "displayName": "Products",
            "paramTableColumns": [
              {
                "param": {
                  "type": "TEXT",
                  "name": "id",
                  "displayName": "Product ID",
                  "simpleValueType": true
                },
                "isUnique": false
              },
              {
                "param": {
                  "type": "TEXT",
                  "name": "name",
                  "displayName": "Product Name",
                  "simpleValueType": true
                },
                "isUnique": false
              },
              {
                "param": {
                  "type": "TEXT",
                  "name": "price",
                  "displayName": "Price",
                  "simpleValueType": true
                },
                "isUnique": false
              },
              {
                "param": {
                  "type": "TEXT",
                  "name": "quantity",
                  "displayName": "Quantity",
                  "simpleValueType": true
                },
                "isUnique": false
              }
            ]
          }
        ]
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "optionalFields",
    "displayName": "Optional Fields",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "TEXT",
        "name": "firstname",
        "displayName": "First Name",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "lastname",
        "displayName": "Last Name",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "userId",
        "displayName": "User ID",
        "simpleValueType": true,
        "help": "Your unique identifier for the customer"
      },
      {
        "type": "TEXT",
        "name": "mobileAdvertiserId",
        "displayName": "Mobile Advertiser ID",
        "simpleValueType": true
      },
      {
        "type": "SELECT",
        "name": "gender",
        "displayName": "Gender",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "M",
            "displayValue": "Male"
          },
          {
            "value": "F",
            "displayValue": "Female"
          },
          {
            "value": "U",
            "displayValue": "Unknown"
          }
        ],
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "birthdate",
        "displayName": "Birth Date",
        "simpleValueType": true,
        "help": "Format: YYYY-MM-DD"
      },
      {
        "type": "TEXT",
        "name": "phone",
        "displayName": "Phone",
        "simpleValueType": true,
        "help": "Format: E164 (e.g. +31612345678)"
      },
      {
        "type": "TEXT",
        "name": "postcode",
        "displayName": "Postal Code",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "city",
        "displayName": "City",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "country",
        "displayName": "Country",
        "simpleValueType": true,
        "help": "2-letter country code (ISO 3166-1 alpha-2)"
      },
      {
        "type": "TEXT",
        "name": "currency",
        "displayName": "Currency",
        "simpleValueType": true,
        "help": "Currency code (e.g. EUR/USD/GBP)"
      },
      {
        "type": "TEXT",
        "name": "language",
        "displayName": "Language",
        "simpleValueType": true,
        "help": "Format: ISO 639-1 and ISO 3166-1 alpha-2 (e.g. en-US)"
      },
      {
        "type": "SELECT",
        "name": "newsletter",
        "displayName": "Newsletter Opt-in",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "yes",
            "displayValue": "Yes"
          },
          {
            "value": "no",
            "displayValue": "No"
          }
        ],
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "totalvalue",
        "displayName": "Total Value",
        "simpleValueType": true,
        "help": "Total value of purchase (2 decimals). Overrides calculated value from products."
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const sendHttpRequest = require('sendHttpRequest');
const JSON = require('JSON');
const logToConsole = require('logToConsole');
const makeNumber = require('makeNumber');

// Prepare the event data
const eventData = {
  event: 'Purchase',
  email: data.email,
  orderid: data.orderId,
  products: data.products.map(product => ({
    id: product.id,
    name: product.name,
    price: makeNumber(product.price),
    quantity: makeNumber(product.quantity)
  }))
};

// Add optional fields if they exist
const optionalFields = [
  'firstname', 'lastname', 'userId', 'mobileAdvertiserId', 'gender',
  'birthdate', 'phone', 'postcode', 'city', 'country', 'currency',
  'language', 'newsletter', 'totalvalue'
];

optionalFields.forEach(field => {
  if (data[field]) {
    eventData[field] = data[field];
  }
});

// Prepare the request
const requestUrl = 'https://api.squeezely.tech/v1/track';
const requestBody = {
  events: [eventData]
};

// Send the request
sendHttpRequest(requestUrl, (statusCode, headers, body) => {
  if (statusCode >= 200 && statusCode < 300) {
    data.gtmOnSuccess();
  } else {
    data.gtmOnFailure();
  }
}, {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'X-AUTH-ACCOUNT': data.accountId,
    'X-AUTH-APIKEY': data.apiKey
  }
}, JSON.stringify(requestBody));


___SANDBOXED_JS_FOR_SERVER___

const sendHttpRequest = require('sendHttpRequest');
const JSON = require('JSON');
const logToConsole = require('logToConsole');
const makeNumber = require('makeNumber');

// Prepare the event data
const eventData = {
  event: 'Purchase',
  email: data.email,
  orderid: data.orderId,
  products: data.products.map(product => ({
    id: product.id,
    name: product.name,
    price: makeNumber(product.price),
    quantity: makeNumber(product.quantity)
  }))
};

// Add optional fields if they exist
const optionalFields = [
  'firstname', 'lastname', 'userId', 'mobileAdvertiserId', 'gender',
  'birthdate', 'phone', 'postcode', 'city', 'country', 'currency',
  'language', 'newsletter', 'totalvalue'
];

optionalFields.forEach(field => {
  if (data[field]) {
    eventData[field] = data[field];
  }
});

// Prepare the request
const requestUrl = 'https://api.squeezely.tech/v1/track';
const requestBody = {
  events: [eventData]
};

// Send the request
sendHttpRequest(requestUrl, (statusCode, headers, body) => {
  if (statusCode >= 200 && statusCode < 300) {
    data.gtmOnSuccess();
  } else {
    data.gtmOnFailure();
  }
}, {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'X-AUTH-ACCOUNT': data.accountId,
    'X-AUTH-APIKEY': data.apiKey
  }
}, JSON.stringify(requestBody));


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "specific"
          }
        }
      ]
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Basic purchase event with required fields only
  code: "const JSON = require('JSON');\n\nconst mockData = {\n  email: 'test@example.com',\n\
    \  orderId: 'ORDER123',\n  products: [{\n    id: 'PROD1',\n    name: 'Test Product',\n\
    \    price: '99.99',\n    quantity: '1'\n  }]\n};\n\nmock('sendHttpRequest', function(url,\
    \ callback, options, body) {\n  assertThat(url).isEqualTo('https://api.squeezely.tech/v1/track');\n\
    \  \n  const requestData = JSON.parse(body);\n  assertThat(requestData.events[0].event).isEqualTo('Purchase');\n\
    \  assertThat(requestData.events[0].email).isEqualTo('test@example.com');\n  assertThat(requestData.events[0].orderid).isEqualTo('ORDER123');\n\
    \  assertThat(requestData.events[0].products).isArray();\n  \n  callback(200);\n\
    });\n\nrunCode(mockData);\n\nassertApi('gtmOnSuccess').wasCalled();"
- name: Purchase event with optional fields
  code: "const JSON = require('JSON');\n\nconst mockData = {\n  email: 'test@example.com',\n\
    \  orderId: 'ORDER123',\n  products: [{\n    id: 'PROD1',\n    name: 'Test Product',\n\
    \    price: '99.99',\n    quantity: '2'\n  }],\n  firstname: 'John',\n  lastname:\
    \ 'Doe',\n  gender: 'M',\n  newsletter: 'yes',\n  totalvalue: '199.98'\n};\n\n\
    mock('sendHttpRequest', function(url, callback, options, body) {\n  const requestData\
    \ = JSON.parse(body);\n  const event = requestData.events[0];\n  \n  assertThat(event.firstname).isEqualTo('John');\n\
    \  assertThat(event.lastname).isEqualTo('Doe');\n  assertThat(event.gender).isEqualTo('M');\n\
    \  assertThat(event.newsletter).isEqualTo('yes');\n  assertThat(event.totalvalue).isEqualTo('199.98');\n\
    \  \n  callback(200);\n});\n\nrunCode(mockData);\n\nassertApi('gtmOnSuccess').wasCalled();"
- name: Failed API request
  code: |-
    const JSON = require('JSON');

    const mockData = {
      email: 'test@example.com',
      orderId: 'ORDER123',
      products: [{
        id: 'PROD1',
        name: 'Test Product',
        price: '99.99',
        quantity: '1'
      }]
    };

    mock('sendHttpRequest', function(url, callback) {
      callback(400, {}, 'Bad Request');
    });

    runCode(mockData);

    assertApi('gtmOnFailure').wasCalled();
- name: Product price and quantity conversion
  code: "const JSON = require('JSON');\n\nconst mockData = {\n  email: 'test@example.com',\n\
    \  orderId: 'ORDER123',\n  products: [{\n    id: 'PROD1',\n    name: 'Test Product',\n\
    \    price: '99.99',\n    quantity: '2'\n  }]\n};\n\nmock('sendHttpRequest', function(url,\
    \ callback, options, body) {\n  const requestData = JSON.parse(body);\n  const\
    \ product = requestData.events[0].products[0];\n  \n  assertThat(product.price).isNumber();\n\
    \  assertThat(product.price).isEqualTo(99.99);\n  assertThat(product.quantity).isNumber();\n\
    \  assertThat(product.quantity).isEqualTo(2);\n  \n  callback(200);\n});\n\nrunCode(mockData);\n\
    \nassertApi('gtmOnSuccess').wasCalled();"


___NOTES___

Created on 5/21/2024, 1:00:00 PM


