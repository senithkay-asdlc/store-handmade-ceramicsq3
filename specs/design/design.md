# Design — Handmade Ceramics Online Store

## 1. Overview

The system is a single-seller online store for handmade ceramics. It consists
of a shopper-facing storefront where registered, authenticated shoppers
browse the catalog, manage a cart, and check out with an integrated payment
provider; a seller admin console where the single store owner manages the
product catalog, stock, and order fulfillment; and a backing API service that
owns the catalog, cart, order, and account data, integrates with the payment
provider for checkout, and sends transactional emails on key order events.

## 2. Components

- **ceramics-storefront** (`web-application`) — the shopper-facing catalog,
cart, checkout, account, and order-history UI.
- **ceramics-admin** (`web-application`) — the seller-facing admin console for
catalog, inventory, and order management. Separate from the storefront: a
different user (the single seller/admin), a different set of screens, and
an independent release lifecycle from the shopper-facing UI.
- **ceramics-api** (`service`) — the single backend service owning products,
stock, cart, orders, and checkout orchestration (payment + email
notifications) for both front-ends.

## 3. Capabilities

### ceramics-storefront

- Shopper registration, sign-in, sign-out, profile/address management,
password reset (via Thunder auth).
- Catalog browsing: list, search, filter (category, price range,
availability), product detail view.
- Cart: add/update/remove line items, live subtotal, stock-aware quantity
limits, out-of-stock indication.
- Checkout: shipping-address entry, flat-rate shipping display, order
summary (subtotal/shipping/tax/total), payment via the integrated payment
provider, order confirmation.
- Order history: list past orders, view an order's detail and status.

### ceramics-admin

- Seller sign-in (Thunder auth, seller role).
- Product management: create, edit, publish/unpublish, delete products
(name, description, price, images, category, stock quantity).
- Stock management: direct stock-quantity adjustments.
- Order management: view all orders and their detail (items, shopper,
shipping address, payment status), update fulfillment status (pending →
processing → shipped → delivered / cancelled).

### ceramics-api

- Catalog resource: CRUD for products (seller-only writes; public/shopper
reads), stock-quantity tracking.
- Cart resource: per-shopper cart persisted server-side, stock-aware
validation on add/update.
- Checkout/order orchestration: re-validates stock, applies flat-rate
shipping, creates immutable order + line-item price snapshots, calls the
payment provider to authorize/capture payment, decrements stock only on
successful payment, sends order-confirmation and shipment-notification
emails.
- Order resource: shopper-scoped order history/detail; seller-scoped
all-orders view and status transitions.
- Role resolution: distinguishes shopper vs. seller callers by their
Thunder role group.

## 4. Data model

- **Product** — id, name, description, price, images\[\], category, stock
quantity, published flag, createdAt/updatedAt.
- **CartItem** — cart id (= shopper id), productId, quantity, addedAt.
- **Order** — id, shopperId, status (pending/processing/shipped/delivered/
cancelled), shippingAddress, shippingFee, subtotal, tax, total,
paymentStatus, paymentReference, createdAt.
- **OrderLineItem** — orderId, productId, productName (snapshot),
unitPrice (snapshot), quantity, lineTotal.
- **ShopperProfile** — shopper id (from Thunder), name, email, default
shipping address.

`Order`/`OrderLineItem` snapshot product name and price at purchase time so
later catalog edits never retroactively change a past order (NFR-6).

## 5. Roles &amp; access

- **Shopper** — authenticated end user (Thunder role: default/shopper
group). May browse catalog, manage own cart, check out, view own
profile and own order history only.
- **Seller (admin)** — authenticated end user in the Thunder "seller"/
"admin" group. May manage products/stock and view/update all orders.
Does not have a separate shopper cart/checkout flow.

`ceramics-api` resolves the caller's role from the gateway-injected
`X-User-Groups` header and scopes cart/order reads to the caller's own
`X-User-Id` for shoppers, while sellers get the unscoped all-orders view.

## 6. Interactions

- `ceramics-storefront` → `ceramics-api`: catalog reads, cart, checkout,
own order history — bearer-token calls via `API_BASE_URL`.
- `ceramics-storefront` → Thunder auth (`user-auth`): shopper sign-in/
sign-up/session.
- `ceramics-admin` → `ceramics-api`: product/stock/order-management calls —
bearer-token calls via `API_BASE_URL`.
- `ceramics-admin` → Thunder auth (`user-auth`): seller sign-in/session.
- `ceramics-api` → Thunder auth (`user-auth`): validates the caller's JWT
via the platform gateway (derives `exposesAPI.auth: end-user-required`).
- `ceramics-api` → Payment provider: authorizes/captures checkout payments.
- `ceramics-api` → Email provider: sends order-confirmation and
shipment-notification emails.

## 7. Data flow

1. **Sign-in**: A shopper or seller signs in via Thunder from their
 respective web-app; the SPA receives a JWT carrying the caller's role
 group and calls `ceramics-api` with it as a bearer token.
2. **Browse &amp; cart**: The shopper browses `ceramics-api`'s product catalog,
 adds items to their server-side cart; the API rejects additions/quantity
 increases beyond current stock and flags out-of-stock products.
3. **Checkout**: The shopper submits a shipping address; the API re-validates
 stock for every cart line, computes subtotal + flat shipping fee + tax +
 total, and calls the payment provider to charge the shopper. On success it
 creates an immutable `Order` + `OrderLineItem` snapshot, decrements stock,
 clears the cart, sends a confirmation email, and returns the order to the
 SPA for display. On payment failure or an insufficient-stock race, no
 order is created, stock is untouched, and the shopper sees an actionable
 error.
4. **Fulfillment**: The seller reviews orders in `ceramics-admin`, updates an
 order's status as it is processed/shipped; a shipment-status update
 triggers a shipment-notification email to the shopper.
5. **Catalog maintenance**: The seller creates/edits/publishes/unpublishes
 products and adjusts stock directly through `ceramics-admin`, immediately
 reflected in the storefront's catalog reads.