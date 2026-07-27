# Requirements Specification — Handmade Ceramics Online Store

## 1. Overview

An online store where a single artisan/seller sells handmade ceramics directly
to customers. The store presents a product catalog, lets shoppers collect
items in a cart, and lets them complete purchases through a checkout flow
backed by an integrated payment provider. Buyers must create an account and
sign in before they can purchase. The seller manages the catalog and fulfills
orders through an admin area.

## 2. Actors

- **Shopper (Buyer)** — a registered, authenticated customer who browses the
catalog, manages a cart, and places orders.
- **Seller (Admin)** — the single store owner/administrator who manages
products, inventory, and order fulfillment. There is exactly one seller
role for this store (not a multi-vendor marketplace).
- **Payment Provider** — an external, integrated payment processor (e.g.
Stripe) that handles card payment authorization and capture during
checkout.

## 3. Scope

### 3.1 In scope

- Product catalog browsing and search/filtering.
- Shopper account registration, sign-in, and session management.
- Shopping cart management.
- Checkout with shipping details, flat-rate shipping, and integrated
payment-provider payment.
- Order confirmation, order history, and order status tracking.
- Seller-facing catalog and inventory management.
- Seller-facing order management/fulfillment.

### 3.2 Out of scope

- Multi-vendor/marketplace support (multiple independent sellers).
- Real-time carrier-calculated shipping rates.
- Local pickup / in-store fulfillment.
- Guest checkout (accounts are required to purchase).
- Product reviews/ratings, wishlists, gift cards, loyalty/rewards programs.
- International tax computation beyond a single configurable tax rate (if
needed, treated as a simple flat/regional rate, not a full tax engine).

## 4. Functional Requirements

### 4.1 Accounts &amp; Authentication

- FR-1: A shopper must be able to register an account with, at minimum, an
email address and password.
- FR-2: A shopper must be able to sign in and sign out of their account.
- FR-3: The system must require an authenticated (signed-in) shopper account
before allowing checkout to be completed. Browsing the catalog and adding
items to a cart may be permitted without sign-in, but the system must
require sign-in to place an order.
- FR-4: A shopper must be able to view and update their own profile
information (e.g. name, shipping address, email, password).
- FR-5: The system must support password reset for shoppers who forget their
credentials.
- FR-6: The seller/admin must authenticate separately from shoppers, with
access restricted to catalog, inventory, and order-management functions
not available to shoppers.

### 4.2 Product Catalog

- FR-7: The system must display a catalog of ceramic products, each with a
name, description, price, one or more images, category/tag(s), and current
stock quantity.
- FR-8: Shoppers must be able to browse the catalog, view a single product's
detail page, and search or filter products (e.g. by category, price range,
availability).
- FR-9: A product that is out of stock (quantity = 0) must be clearly
indicated to shoppers and must not be addable to the cart.
- FR-10: The seller must be able to create, edit, publish/unpublish, and
delete products, including setting price, description, images, category,
and stock quantity.
- FR-11: The seller must be able to adjust a product's stock quantity
directly (e.g. to reflect new inventory or corrections).

### 4.3 Cart

- FR-12: A shopper (or anonymous visitor, prior to checkout) must be able to
add a product to a cart, specifying a quantity.
- FR-13: The cart must prevent adding, or increasing the quantity of, a line
item beyond the product's currently available stock quantity.
- FR-14: A shopper must be able to view their cart, update line-item
quantities, and remove line items.
- FR-15: The cart must display a running subtotal that updates as items are
added, removed, or their quantities changed.
- FR-16: The cart's contents must persist for a signed-in shopper across
sessions/devices (i.e. tied to the account, not only to a local browser
session).

### 4.4 Checkout &amp; Payment

- FR-17: Checkout must require the shopper to be signed in.
- FR-18: Checkout must collect (or reuse a saved) shipping address for the
order.
- FR-19: Checkout must apply a single flat-rate shipping fee to the order
(no carrier-calculated or weight-based shipping, no local pickup option).
- FR-20: Checkout must display an order summary including line items,
subtotal, shipping fee, any applicable tax, and total, before the shopper
confirms payment.
- FR-21: Checkout must process payment through an integrated payment
provider; the store itself must not store raw card details.
- FR-22: At the moment of order placement, the system must re-validate stock
availability for every cart line item and must decrement the corresponding
product stock quantities upon successful payment.
- FR-23: If payment fails or is declined, the order must not be created and
stock must not be decremented; the shopper must be shown an actionable
error and given the opportunity to retry.
- FR-24: If, at order-placement time, an item's stock is insufficient (e.g.
purchased by someone else first), the shopper must be informed and the
affected line item(s) must be adjusted or removed before the order can be
completed.
- FR-25: Upon successful payment, the system must create an order record,
show an order confirmation to the shopper, and clear the corresponding
items from the cart.

### 4.5 Orders

- FR-26: A signed-in shopper must be able to view their own order history and
the detail/status of each past order.
- FR-27: The seller must be able to view all orders, see order details
(items, shopper, shipping address, payment status), and update an order's
fulfillment status (e.g. pending → processing → shipped → delivered /
cancelled).
- FR-28: The system must notify the shopper (e.g. via email) on key order
events: order confirmation and shipment.

## 5. Non-Functional Requirements

- NFR-1 (Security): All payment card data must be handled exclusively by the
integrated payment provider (e.g. via tokenization); the store must never
receive or persist raw card numbers.
- NFR-2 (Security): Shopper passwords must be stored using a strong,
salted hash; authenticated sessions must use secure, expiring tokens.
- NFR-3 (Availability): Catalog browsing and cart operations should remain
responsive under normal load; product pages should load within a few
seconds under typical conditions.
- NFR-4 (Data integrity): Stock quantity adjustments (from purchases and
seller edits) must be consistent — concurrent purchases must not oversell
a product below zero available stock.
- NFR-5 (Usability): The storefront must be usable on both desktop and mobile
browsers.
- NFR-6 (Auditability): Every order must retain an immutable record of the
items, prices, and shipping fee at the time of purchase, independent of
later catalog price changes.

## 6. Assumptions

- A single seller/admin operates the store; multi-vendor marketplace
features are explicitly out of scope.
- Shipping is flat-rate; no destination- or weight-based rate calculation is
required.
- Payment is processed by a single integrated third-party payment provider;
the store does not implement its own payment/card processing.
- Products are stocked items with countable quantities (not one-of-a-kind
pieces that are removed from the catalog immediately upon sale), so a
"stock quantity" model applies uniformly.
- Guest checkout is not supported; every purchase is tied to a registered
shopper account.

## 7. Success Criteria

The requirements are satisfied when: a shopper can register/sign in, browse
and search the ceramics catalog, add in-stock items to a persistent cart,
complete checkout with a flat shipping fee and integrated payment-provider
payment, receive an order confirmation, and later view that order's status;
and the seller can manage the product catalog, stock levels, and fulfill/
track orders — all while stock is never oversold and no raw payment card
data is stored by the system.