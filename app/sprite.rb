class Sprite
  attr_sprite

  @@fourty_five = Math::PI / 4
  @@one_thirty_five = 3 * Math::PI / 4
  @@two_twenty_five = 5 * Math::PI / 4
  @@three_fifteen = 7 * Math::PI / 4

  def initialize(image_path, x, y, width, height)
    @path = image_path
    @x = x
    @y = y
    @w = width
    @h = height
  end

  def calculate
    # do nothing by default
  end

  # Returns which side of this sprite that other_sprite is
  def collision_side(other_sprite)

    radians = angle_to_sprite(other_sprite)

    if radians > @@fourty_five && radians <= @@one_thirty_five
      return 'TOP'
    elsif radians > @@one_thirty_five && radians <= @@two_twenty_five
      return 'LEFT'
    elsif radians > @@two_twenty_five && radians <= @@three_fifteen
      return 'BOTTOM'
    else
      return 'RIGHT'
    end
  end

  def angle_to_sprite(other_sprite)
    this_center = center()
    other_center = other_sprite.center()

    delta_x = other_center[0] - this_center[0]
    delta_y = other_center[1] - this_center[1]

    theta_radians = Math.atan2(delta_y, delta_x)

    return theta_radians
  end

  def center
    center_x = @x + @w / 2
    center_y = @y + @h / 2

    return [center_x, center_y]
  end
end
