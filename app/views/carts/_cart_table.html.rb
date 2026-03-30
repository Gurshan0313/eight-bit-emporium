<div class="row g-4">
  <div class="col-lg-8">
    <div class="card shadow-sm">
      <div class="card-body p-0">
        <table class="table table-hover mb-0 align-middle">
          <thead class="table-dark">
            <tr>
              <th>Product</th>
              <th>Price</th>
              <th style="width:160px">Quantity</th>
              <th>Subtotal</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <% (session[:cart] || {}).each do |product_id, qty| %>
              <% product = Product.find_by(id: product_id) %>
              <% next unless product %>
              <tr>
                <td>
                  <%= link_to product.name, product_path(product), class: "fw-semibold text-decoration-none" %>
                </td>
                <td>$<%= sprintf("%.2f", product.current_price) %></td>
                <td>
                  <!-- Feature 3.1.2 — Edit quantity -->
                  <%= form_tag update_item_cart_path, method: :patch, class: "d-flex gap-1" do %>
                    <%= hidden_field_tag :product_id, product_id %>
                    <%= number_field_tag :quantity, qty, min: 1, max: 99,
                        class: "form-control form-control-sm",
                        style: "width:70px",
                        id: "qty_#{product_id}" %>
                    <button class="btn btn-sm btn-outline-secondary" type="submit">↻</button>
                  <% end %>
                </td>
                <td class="fw-bold text-success">
                  $<%= sprintf("%.2f", product.current_price * qty) %>
                </td>
                <td>
                  <!-- Feature 3.1.2 — Remove (independent of quantity) -->
                  <%= button_to "✕", remove_item_cart_path,
                      params: { product_id: product_id },
                      method: :delete,
                      class: "btn btn-sm btn-outline-danger",
                      data: { confirm: "Remove this item?" } %>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <div class="col-lg-4">
    <div class="card shadow-sm">
      <div class="card-body">
        <h5 class="fw-bold mb-3">Order Summary</h5>
        <%
          subtotal = (session[:cart] || {}).sum do |pid, qty|
            p = Product.find_by(id: pid)
            p ? p.current_price * qty : 0
          end
        %>
        <div class="d-flex justify-content-between mb-2">
          <span>Subtotal</span>
          <span>$<%= sprintf("%.2f", subtotal) %></span>
        </div>
        <div class="d-flex justify-content-between text-muted small mb-3">
          <span>Taxes calculated at checkout</span>
        </div>
        <hr>
        <div class="d-flex justify-content-between fw-bold fs-5 mb-3">
          <span>Estimated Total</span>
          <span class="text-success">$<%= sprintf("%.2f", subtotal) %></span>
        </div>

        <% if user_signed_in? %>
          <%= link_to "Proceed to Checkout →", checkout_path, class: "btn btn-danger w-100" %>
        <% else %>
          <%= link_to "Sign In to Checkout", new_user_session_path, class: "btn btn-danger w-100" %>
          <p class="text-center text-muted small mt-2">
            or <%= link_to "create an account", new_user_registration_path %>
          </p>
        <% end %>
      </div>
    </div>
  </div>
</div>