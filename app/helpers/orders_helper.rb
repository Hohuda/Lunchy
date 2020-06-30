module OrdersHelper

  # Return right string to button
  def add_edit_button(order)
    if order.is_a? Order
      if order.victuals.empty?
        button_name = 'Add order items'
      else
        button_name = 'Edit order'
      end
      link_to button_name, edit_order_path(@order), locals: {order: @order}, class: 'btn btn-secondary w-75'
    else false
    end
  end

  # Returns submit button             REWORK
  def submit_order_button(order)
    if order.is_a? Order
      if order.victuals.empty? 
        link_to "Submit order", '#', { class: 'btn btn-success w-75', title: "Add items before submit" }
      else 
        link_to "Submit order", submit_order_path(@order), class: 'btn btn-success w-75'
      end
    else false
    end
  end

end
