SPRITES = []

BLOCKS = []

HERO = Hero.new(500, 200)

BLOCKS << Block.new(500, 150) << Block.new(500 + 16 + 8, 150 - 16) << Block.new(500 + 16 + 8 + 16 + 8, 150)

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
    touching_right_side_of_blocks = intersecting_blocks.select { |block| block.collision_side(HERO) == 'RIGHT' }
    touching_left_side_of_blocks = intersecting_blocks.select { |block| block.collision_side(HERO) == 'LEFT' }

    if above_blocks.size() > 0
      HERO.stand(above_blocks)
    else
      HERO.unstand()
    end

    if touching_right_side_of_blocks.size() > 0
      HERO.stop_left_movement(touching_right_side_of_blocks)
    else
      HERO.allow_left_movement()
    end

    if touching_left_side_of_blocks.size() > 0
      HERO.stop_right_movement(touching_left_side_of_blocks)
    else
      HERO.allow_right_movement()
    end
  else
    # undo any block based actions
    HERO.unstand()
    HERO.allow_left_movement()
    HERO.allow_right_movement()
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
