class Block < Sprite
  @@default_width = 20
  @@default_height = 20

  def initialize(args, starting_x, starting_y)
    super(args, '/sprites/blocks/block.png', starting_x, starting_y, @@default_width, @@default_height)
  end

  def self.default_width
    return @@default_width
  end

  def self.default_height
    return @@default_height
  end
end
