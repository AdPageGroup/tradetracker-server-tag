# AdPage TradeTracker Conversion Tag

This server tag allows you to send lead and sale conversion events to TradeTracker's API.

## Event Types

- **Lead** - Track lead conversions
- **Sale** - Track purchase/sale conversions

## Required Fields

- **Campaign ID** - Your TradeTracker campaign identifier
- **Product ID** - Unique identifier for the product/offer
- **Transaction ID** - Unique identifier for this conversion

## Optional Fields

### General Fields

- **Merchant Description** - Description visible to merchant
- **Affiliate Description** - Description visible to affiliate
- **Click ID** - The click ID value stored during the initial click
- **Voucher Code** - Voucher/discount code used

### Sale Event Fields

Only required when event type is "sale":

- **Transaction Amount** - Value of the transaction
- **Currency** - Currency code for the transaction amount
