class Block < Sprite
  def initialize(args, starting_x, starting_y)
    super(args, '/sprites/blocks/block.png', starting_x, starting_y, 20, 20)
  end
end
