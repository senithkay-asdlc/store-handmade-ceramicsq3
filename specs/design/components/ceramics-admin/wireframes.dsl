// Seller Admin Console — catalog, stock, and order management

screen ProductList "Seller reviews and manages the product catalog"
  navbar "Ceramics Admin"
  sidebar "Products | Orders | Settings"
  row
    heading "Products"
    right
    search "Search products…"
    button "New product" primary -> ProductForm
  table "Product | Category | Price | Stock | Published" -> ProductForm
    row "Speckled Stoneware Mug | Mugs | $28.00 | 14 | Yes"
    row "Matte Blue Vase | Vases | $64.00 | 7 | Yes"
    row "Nordic Bowl Set | Bowls | $92.00 | 0 | Yes"
    row "Ash-Glazed Teapot | Teapots | $78.00 | 5 | No"

screen ProductForm "Seller creates or edits a product and adjusts stock"
  navbar "Ceramics Admin"
  sidebar "Products | Orders | Settings"
  breadcrumb "Products / Matte Blue Vase"
  heading "Edit Product"
  input "Name — Matte Blue Vase"
  textarea "Description"
  row
    input "Price — 64.00"
    select "Category: Vases"
  input "Image URL"
  row
    input "Stock quantity — 7"
    toggle "Published" active
  row
    right
    button "Delete" danger
    button "Save changes" primary -> ProductList

screen OrderQueue "Seller views all orders and fulfillment status"
  navbar "Ceramics Admin"
  sidebar "Products | Orders | Settings"
  row
    heading "Orders"
    right
    select "Status: All"
  row
    badge "All (146)"
    badge "Pending (12)" warning
    badge "Processing (8)" info
    badge "Shipped (20)"
  table "Order | Shopper | Total | Status | Placed" -> OrderDetail
    row "#10482 | J. Alvarez | $135.60 | Processing | Jul 20, 2026"
    row "#10479 | M. Diaz | $64.00 | Pending | Jul 20, 2026"
    row "#10311 | K. Smith | $64.00 | Delivered | Jun 2, 2026"

screen OrderDetail "Seller views one order and updates its fulfillment status"
  navbar "Ceramics Admin"
  sidebar "Products | Orders | Settings"
  breadcrumb "Orders / #10482"
  row
    heading "Order #10482"
    badge "Processing" info
  text "Shopper: J. Alvarez — Placed Jul 20, 2026"
  split 60/40
    left
      table "Product | Qty | Line total"
        row "Matte Blue Vase | 1 | $64.00"
        row "Speckled Stoneware Mug | 2 | $56.00"
      text "Subtotal: $120.00 · Shipping: $6.00 · Tax: $9.60 · Total: $135.60"
      text "Payment status: Captured"
    right
      heading "Shipping address"
      text "J. Alvarez"
      text "221 Kiln Street, Asheville, NC 28801"
      heading "Update status"
      select "Status: Shipped"
      button "Update status" primary -> OrderQueue
