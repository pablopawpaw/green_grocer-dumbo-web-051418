require 'pry'
def consolidate_cart(cart)
  # code here
  #count number of same items in cart
freq = []
i = 0 
while i < cart.length do 
  count = cart.select do |x|
            x == cart[i]
          end.count
  freq << count
  i+=1
end 

#add :count to item detail hash and get cart items 
cart_items = []
cart.each do |array_elements|
  array_elements.each do |item, details|
    array_elements[item][:count] = 0
    cart_items << item
  end 
end

#set the count value in hash 
i = 0 
while i < freq.length do 
  cart[i][cart_items[i]][:count] = freq[i]
  i+=1
end 

#remove dupes
cart = cart.uniq

#put into hash format 
cart_hash = Hash.new 
cart.each do |array|
  array.each do |item, details|
    cart_hash[item] = details
  end 
end 
cart_hash
end

def apply_coupons(cart, coupons)
  #find items corresponding to the coupon in cart 
  #reflect count on item 
  #add discounted item to cart 
  
=begin #if dataset was an array of hashes 
  def find_coupon_items(cart, coupons)
    i = 0 
    viable_coupons = {}
    while i < coupons.length do 
      check_array = 0
      cart.each do |element|
        if element.include?(coupons[i][:item])
          check_array += 1
          viable_coupons[coupons[i][:item]] = {}
        else 
          check_array += 0
        end 
      end 
      if check_array >= 1
        true
      else 
        puts "#{coupons[i][:item]} isn't in your shopping cart." 
      end 
      i+=1
    end 
    
    viable_coupons.each do |key, value|
      coupons.each do |element|
        if element[:item] == key 
          value[:num] = element[:num]
          value[:cost] = element[:cost]
        end 
      end 
    end 
  end 
  
def check_number_of_items(cart,coupons)
  viable_coupons = find_coupon_items(cart, coupons) # returns applicable coupons hash with corresponding details 
  insufficient_items = []
  results = cart.map do |cart_element|
    cart_element.map do |cart_item, cart_details|
      viable_coupons.map do |coupon_key, coupon_details|
        if cart_element.include?(coupon_key)
          cart_details[:count] >= coupon_details[:num]
        else 
          insufficient_items << coupon_key
        end 
      end 
    end 
  end.flatten.compact
  
  check = results.select do |x|
    x == false
  end 
  
  insufficient_items = insufficient_items.uniq.compact.flatten
  insufficient_items = insufficient_items.join(", ")
  
  if check.length != 0
    puts "Your shopping cart doesn't have enough of '#{insufficient_items}' for the coupon to be applicable."
  else 
    viable_coupons
  end 
end 
  
  def reflect_coupon_count(cart, coupons)
  viable_coupons = check_number_of_items(cart, coupons)
    cart.each do |cart_element|
      cart_element.each do |cart_item, cart_details|
        viable_coupons.each do |coupon_key, coupon_details|
          if cart_item == coupon_key
            if cart_details[:count] == coupon_details[:num]
              cart_element.delete(cart_item)
              #viable_coupons.delete(coupon_key)
            elsif cart_details[:count] > coupon_details[:num]
              cart_details[:count] -= coupon_details[:num]
              viable_coupons.delete(coupon_key)
            end 
          end 
        end 
      end 
    end

    updated_cart = []
    cart.each do |cart_element|
      updated_cart << cart_element
    end 
   
    updated_cart.each do |cart_element|
      viable_coupons.each do |coupon_key, coupon_details|
        cart_element["#{coupon_key} W/COUPON"] = {}
        cart_element["#{coupon_key} W/COUPON"][:price] = coupon_details[:cost]
        cart_element["#{coupon_key} W/COUPON"][:clearance] = coupon_details[:clearance]
        cart_element["#{coupon_key} W/COUPON"][:count] = coupon_details[:num]
        viable_coupons.delete(coupon_key)
      end 
    end 

  updated_cart
end 
=end 
=begin #first attempt based on instructions' datasets rather than tests' 
  def find_coupon_items(cart, coupons)
    if cart.include?(coupons[:item])
      true 
    else 
      puts "#{coupons[:item]} isn't in your shopping cart."
    end 
  end 

  def check_number_of_items(cart,coupons)
    cart.map do |item, details|
      if item.include?(coupons[:item])
        details[:count] >= coupons[:num]
      end 
    end.compact.flatten[0]
  end 


  def reflect_coupon_count(cart, coupons)
    if check_number_of_items(cart, coupons) == true 
      if cart[coupons[:item]][:count] == coupons[:num]
        cart.delete coupons[:item]
      else 
        cart[coupons[:item]][:count] -= coupons[:num]
      end 
    end 
  end 
  
  def add_coupon(cart, coupons)
    #create new item for coupons in cart
    cart["#{coupons[:item]} W/COUPON"] = {}
    coupon_item = cart["#{coupons[:item]} W/COUPON"]
    #retrieve orig item details
    cart.map do |item, details|
      if item == coupons[:item]
        details.map do |key, value|
          coupon_item[key] = value
        end 
      end 
    end
    #update coupons item's price in cart 
    coupon_item[:price] = coupons[:cost]
   
  end 
=end 

  find_coupon_items(cart,coupons)
  check_number_of_items(cart,coupons)
  reflect_coupon_count(cart, coupons)

end

def apply_clearance(cart)
  #determine which items in cart are on clearance
  #calc clearance price 20% of orig price 
  #reflect clearance prices in cart 
  
  cart.map do |item, details|
    details.map do |key, value|
      if key == :clearance
        if value == true
          clearance_item = item
          clearance_price = (details[:price] * 0.8).round(2)
          details[:price] = clearance_price
        end 
      end
    end 
  end 
  
  cart
end

def checkout(cart, coupons)
  consolidate_cart(cart, coupons)
  apply_coupons(cart, coupons)
  apply_clearance(cart)
  
end
