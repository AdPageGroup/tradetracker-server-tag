___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "TradeTracker Conversion",
  "categories": ["ADVERTISING"],
  "brand": {
    "displayName": "AdPage",
    "thumbnail": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAABCFBMVEUAAAARKmQRKmQRKmQRKmR5Ojj/TwARKmQRKmSIPDIRKmSFPDMRKmSIPTKMPTBOYIyiq8LGzNrq7PH39/rM0d6krsRLXoqMmLTEytlCVYSPPi8TLGWPm7b///9zgqTZ3eZQY421vc/+/v77/P1RZI4tQ3b6+/yLl7RFWYYYMWk1S3yYo7zKz9zd4ekWLmegqsFTZY/v8fV2hKY4TX4ULWbz9Pdeb5YiOW/c4OloeJ2utspUZpAyR3nn6e+7wtORnLezu874+PoVLWZSZI94hqf09fjl6O7Fy9n9/f68w9M8UICstckqQXRgcZiBjq11g6VIW4gcNGsxRnlNX4shOG4RKmQRKmQRKmSp9aF5AAAAWHRSTlMAOsHy////O/3/vf/z////////////////////////////////////////////////////////////////////////////////////////////////Pvw9QywndwAAAQxJREFUeJy9k1lTwkAQhJcwEkA5FBQUghhAUEAB5T4FQUGUw+v//xOT2ZAyMEne6Jft6v52M9mqZcwhOIHQgYuLiW6qVuTRAK9JD3DIgSNTAHwImPecsATAbwcok/4DAsHjk1D49AwiUVXnGF7oQCwuaUpc4pLk+QaIXW16SU7hkjYC+n5dRiBzbQNkeRjN3dzmSaCAWfFO9fccKBmAMmYV9A8UwAcPoH+UiU9UMauhr1MnNDALom9SQ7b4FbUV2+lSgLZL6vUHT+RvDos2FwWlHWBkBOBZb8YT6gSA3Avmr9PZG5rkNgAwf/9YLFcA609VX7sAqX0A5k8P5WXfP1a9W2Tsl37+qpyCg/0BZ1024DImT68AAAAASUVORK5CYII\u003d",
    "id": "brand_custom_template"
  },
  "description": "Send conversion events to TradeTracker",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "eventType",
    "displayName": "Event Type",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "lead",
        "displayValue": "Lead"
      },
      {
        "value": "sale",
        "displayValue": "Sale"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "lead"
  },
  {
    "type": "TEXT",
    "name": "campaignId",
    "displayName": "Campaign ID",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "productId",
    "displayName": "Product ID",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "transactionId",
    "displayName": "Transaction ID",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "descrMerchant",
    "displayName": "Merchant Description",
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "descrAffiliate",
    "displayName": "Affiliate Description",
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "data",
    "displayName": "Click ID",
    "simpleValueType": true,
    "help": "The click ID value stored during the initial click"
  },
  {
    "type": "TEXT",
    "name": "voucherCode",
    "displayName": "Voucher Code",
    "simpleValueType": true
  },
  {
    "type": "GROUP",
    "name": "saleFields",
    "displayName": "Sale Event Fields",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "TEXT",
        "name": "transactionAmount",
        "displayName": "Transaction Amount",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "currency",
        "displayName": "Currency",
        "simpleValueType": true
      }
    ],
    "enablingConditions": [
      {
        "paramName": "eventType",
        "paramValue": "sale",
        "type": "EQUALS"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

const sendHttpRequest = require('sendHttpRequest');
const encodeUriComponent = require('encodeUriComponent');

// Build base URL based on event type
const baseUrl = data.eventType === 'lead' ? 
  'https://tl.tradetracker.net/' :
  'https://ts.tradetracker.net/';

// Build query parameters
let queryParams = '?s2s=1' +
  '&cid=' + encodeUriComponent(data.campaignId) +
  '&pid=' + encodeUriComponent(data.productId) +
  '&tgi=' +
  '&tid=' + encodeUriComponent(data.transactionId) +
  '&descrMerchant=' + encodeUriComponent(data.descrMerchant || '') +
  '&descrAffiliate=' + encodeUriComponent(data.descrAffiliate || '') +
  '&data=' + encodeUriComponent(data.data || '') +
  '&vc=' + encodeUriComponent(data.voucherCode || '');

// Add sale-specific parameters
if (data.eventType === 'sale') {
  queryParams += '&tam=' + encodeUriComponent(data.transactionAmount || '') +
    '&currency=' + encodeUriComponent(data.currency || '');
}

const url = baseUrl + queryParams;

// Send the request
sendHttpRequest(url, (statusCode) => {
  if (statusCode >= 200 && statusCode < 300) {
    data.gtmOnSuccess();
  } else {
    data.gtmOnFailure();
  }
}, {method: 'GET'});


___SERVER_PERMISSIONS___

[
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
        },
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://tl.tradetracker.net/*"
              },
              {
                "type": 1,
                "string": "https://ts.tradetracker.net/*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Lead event test
  code: "const mockData = {\n  eventType: 'lead',\n  campaignId: 'test-campaign',\n\
    \  productId: 'test-product',\n  transactionId: 'test-transaction',\n  descrMerchant:\
    \ 'Test Merchant',\n  descrAffiliate: 'Test Affiliate', \n  data: 'test-click',\n\
    \  voucherCode: 'TEST10'\n};\n\nmock('sendHttpRequest', function(url, callback)\
    \ {\n  assertThat(url).contains('https://tl.tradetracker.net/');\n  assertThat(url).contains('s2s=1');\n\
    \  assertThat(url).contains('cid=test-campaign');\n  assertThat(url).contains('pid=test-product');\n\
    \  assertThat(url).contains('tid=test-transaction');\n  assertThat(url).contains('descrMerchant=Test%20Merchant');\n\
    \  assertThat(url).contains('descrAffiliate=Test%20Affiliate');\n  assertThat(url).contains('data=test-click');\n\
    \  assertThat(url).contains('vc=TEST10');\n  callback(200);\n});\n\nrunCode(mockData);\n\
    \nassertApi('gtmOnSuccess').wasCalled();\n"
- name: Sale event test
  code: |
    const mockData = {
      eventType: 'sale',
      campaignId: 'test-campaign',
      productId: 'test-product',
      transactionId: 'test-transaction',
      descrMerchant: 'Test Merchant',
      descrAffiliate: 'Test Affiliate',
      data: 'test-click',
      voucherCode: 'TEST10',
      transactionAmount: '99.99',
      currency: 'EUR'
    };

    mock('sendHttpRequest', function(url, callback) {
      assertThat(url).contains('https://ts.tradetracker.net/');
      assertThat(url).contains('s2s=1');
      assertThat(url).contains('cid=test-campaign');
      assertThat(url).contains('pid=test-product');
      assertThat(url).contains('tid=test-transaction');
      assertThat(url).contains('descrMerchant=Test%20Merchant');
      assertThat(url).contains('descrAffiliate=Test%20Affiliate');
      assertThat(url).contains('data=test-click');
      assertThat(url).contains('vc=TEST10');
      assertThat(url).contains('tam=99.99');
      assertThat(url).contains('currency=EUR');
      callback(200);
    });

    runCode(mockData);

    assertApi('gtmOnSuccess').wasCalled();
- name: Error handling test
  code: |-
    const mockData = {
      eventType: 'lead',
      campaignId: 'test-campaign',
      productId: 'test-product',
      transactionId: 'test-transaction'
    };

    mock('sendHttpRequest', function(url, callback) {
      callback(400);
    });

    runCode(mockData);

    assertApi('gtmOnFailure').wasCalled();


___NOTES___

Created on 5/21/2024, 1:00:00 PM


