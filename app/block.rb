class Block < Sprite
  def initialize(starting_x, starting_y)
    super('/sprites/block/block.png', starting_x, starting_y, 16, 16)
  end
end
