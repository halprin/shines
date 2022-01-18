SPRITES = []

BLOCKS = []

HERO = Hero.new(500, 200)

BLOCK = Block.new(500, 150)
BLOCKS << BLOCK

SPRITES << HERO
SPRITES.concat(BLOCKS)

def tick(args)

  collision_checking(args)

  input_checking(args)

  SPRITES.each(&:calculate)

  args.outputs.sprites << SPRITES
end

def collision_checking(args)
  collision_for_blocks(args)
end

def collision_for_blocks(args)
  intersecting_blocks = BLOCKS.select { |block| block.intersect_rect?(HERO, 0) }
  if intersecting_blocks.size() > 0
    args.outputs.labels << [500, 500, 'intersection']
    HERO.stand(intersecting_blocks)
  else
    HERO.unstand()
  end
end

def input_checking(args)
  HERO.jump() if args.inputs.keyboard.space
  HERO.move_right() if right_pressed_no_left(args)
  HERO.move_left() if left_pressed_no_right(args)
end

def right_pressed_no_left(args)
  return args.inputs.right && !args.inputs.left
end

def left_pressed_no_right(args)
  return args.inputs.left && !args.inputs.right
end
