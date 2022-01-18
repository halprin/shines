class Block < Sprite
  def initialize(starting_x, starting_y)
    super('/sprites/blocks/block.png', starting_x, starting_y, 16, 16)
  end
end
