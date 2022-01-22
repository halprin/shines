class Sprite
  attr_sprite

  def initialize(args, image_path, x, y, width, height)
    @args = args
    @path = image_path
    @x = x
    @y = y
    @w = width
    @h = height
  end

  def calculate(args)
    # do nothing by default
  end

  # Returns which side of this sprite that other_sprite is
  def collision_side(other_sprite)

    radians = @args.geometry.angle_to(center(), other_sprite.center())

    if radians > 45 && radians < 135
      # A skinny top so we can't stand past the left side
      return 'TOP'
    elsif radians >= 135 && radians <= 225
      return 'LEFT'
    elsif radians > 225 && radians <= 315
      return 'BOTTOM'
    else
      return 'RIGHT'
    end
  end

  def center
    center_x = @x + @w / 2
    center_y = @y + @h / 2

    return [center_x, center_y]
  end
end
