SPRITES = []

BLOCKS = []

HERO = Hero.new(500, 200)

BLOCKS << Block.new(500, 150) << Block.new(500 + 16 + 8, 150 - 16)

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
    above_blocks = intersecting_blocks.select { |block| block.collision_side(HERO) == 'TOP' }

    if above_blocks.size() > 0
      HERO.stand(above_blocks)
    else
      HERO.unstand()
    end
  else
    # undo any block based actions
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
