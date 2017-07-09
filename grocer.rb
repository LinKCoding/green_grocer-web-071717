require "pry"

def consolidate_cart(cart)
  con_cart = {}
  cart.each do |hash|
    hash.each do |key, value|
      unless con_cart[key]
        con_cart[key] = value
        con_cart[key][:count] = cart.count(hash)
      end
    end
  end
  con_cart
end

def apply_coupons(cart, coupon)
  applied = {}
  cart.each do |name, info|
    coupon.each do |coup|
      if coup[:item] == name && info[:count] >= coup[:num]
        applied["#{name} W/COUPON"] = {} unless applied["#{name} W/COUPON"]
        applied["#{name} W/COUPON"][:clearance] = info[:clearance]
        applied["#{name} W/COUPON"][:price] = coup[:cost]
        applied["#{name} W/COUPON"][:count] = 0 unless applied["#{name} W/COUPON"][:count]
        applied["#{name} W/COUPON"][:count] += 1
        info[:count] = info[:count] - coup[:num]
      end
    end
  end
  cart.merge(applied)
end

def apply_clearance(cart)
  cart.each do |name, info|
    if info[:clearance]
      info[:price] = "%.2f" % (info[:price] * 0.8)
      info[:price] = info[:price].to_f
    end
  end
  cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total = 0
  cart.each do |item, info|
    total += info[:price] * info[:count]
  end
  total =  "%.2f" % total
  total = total.to_f
  if total > 100.0
    total = "%.2f" % (total * 0.9)
    return total.to_f
  else
    total
  end
end
