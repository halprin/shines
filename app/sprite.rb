class Sprite
  attr_sprite

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
end
