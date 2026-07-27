// Ceramics Storefront — shopper flows

screen Catalog "Shopper browses and searches the ceramics catalog"
  navbar "Ceramics Co | Shop | Cart | Orders | Account"
  row
    heading "Handmade Ceramics"
    right
    search "Search mugs, bowls, vases…"
    select "Category: All"
  row
    card "Speckled Stoneware Mug | $28 | In stock" -> ProductDetail
    card "Matte Blue Vase | $64 | In stock" -> ProductDetail
    card "Nordic Bowl Set | $92 | Out of stock" -> ProductDetail
  row
    card "Terracotta Planter | $36 | In stock" -> ProductDetail
    card "Ash-Glazed Teapot | $78 | In stock" -> ProductDetail
    card "Rustic Serving Plate | $45 | In stock" -> ProductDetail

screen ProductDetail "Shopper views one product and adds it to the cart"
  navbar "Ceramics Co | Shop | Cart | Orders | Account"
  breadcrumb "Shop / Matte Blue Vase"
  split 60/40
    left
      image "Matte Blue Vase — photo"
      text "Hand-thrown stoneware vase, matte cobalt glaze, 10in tall."
      text "Category: Vases"
    right
      heading "Matte Blue Vase"
      text "$64.00"
      badge "In stock — 7 left" success
      select "Quantity: 1"
      button "Add to cart" primary -> Cart

screen Cart "Shopper reviews cart contents and subtotal"
  navbar "Ceramics Co | Shop | Cart | Orders | Account"
  heading "Your Cart"
  table "Product | Unit price | Qty | Line total"
    row "Matte Blue Vase | $64.00 | 1 | $64.00"
    row "Speckled Stoneware Mug | $28.00 | 2 | $56.00"
  row
    right
    text "Subtotal: $120.00"
  row
    right
    button "Continue shopping"
    button "Checkout" primary -> Checkout

screen Checkout "Shopper enters shipping and pays via the integrated payment provider"
  navbar "Ceramics Co | Shop | Cart | Orders | Account"
  heading "Checkout"
  split 60/40
    left
      heading "Shipping address"
      input "Full name"
      input "Address line 1"
      input "City"
      row
        input "Postal code"
        input "Country"
      heading "Payment"
      input "Card number"
      row
        input "Expiry"
        input "CVC"
    right
      card "Order summary"
        text "Subtotal: $120.00"
        text "Shipping (flat rate): $6.00"
        text "Tax: $9.60"
        text "Total: $135.60"
      button "Place order" primary -> OrderConfirmation

screen OrderConfirmation "Shopper sees confirmation after successful payment"
  navbar "Ceramics Co | Shop | Cart | Orders | Account"
  heading "Order confirmed"
  badge "Payment successful" success
  text "Order #10482 — confirmation emailed to you."
  table "Product | Qty | Line total"
    row "Matte Blue Vase | 1 | $64.00"
    row "Speckled Stoneware Mug | 2 | $56.00"
  text "Total charged: $135.60"
  button "View order history" -> OrderHistory

screen OrderHistory "Shopper views past orders and their status"
  navbar "Ceramics Co | Shop | Cart | Orders | Account"
  heading "Your Orders"
  table "Order | Placed | Total | Status" -> OrderConfirmation
    row "#10482 | Jul 20, 2026 | $135.60 | Processing"
    row "#10311 | Jun 2, 2026 | $64.00 | Delivered"
    row "#10022 | Mar 14, 2026 | $92.00 | Cancelled"
