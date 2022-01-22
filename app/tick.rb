def tick(args)

  if args.state.tick_count == 0
    initialize(args)
  end

  # if args.state.tick_count % 15 == 0
    # collision_checking(args)

    input_checking(args)

  args.state.sprites.all.each(&:calculate)

    collision_checking(args)
  # end

  args.outputs.sprites << args.state.sprites.all
end

def collision_checking(args)
  collision_for_blocks(args)
end

def collision_for_blocks(args)
  hero = args.state.sprites.hero

  intersecting_blocks = args.state.sprites.blocks.select { |block| block.intersect_rect?(hero, 0) }

  if intersecting_blocks.size() > 0
    above_blocks = intersecting_blocks.select { |block| block.collision_side(hero) == 'TOP' }
    touching_right_side_of_blocks = intersecting_blocks.select { |block| block.collision_side(hero) == 'RIGHT' }
    touching_left_side_of_blocks = intersecting_blocks.select { |block| block.collision_side(hero) == 'LEFT' }

    if above_blocks.size() > 0
      args.labels << [580, 400, 'Above Intersection']
      hero.stand(above_blocks)
    else
      hero.unstand()
    end

    if touching_right_side_of_blocks.size() > 0
      args.labels << [580, 500, 'Right Intersection']
      hero.stop_left_movement(touching_right_side_of_blocks)
    else
      hero.allow_left_movement()
    end

    if touching_left_side_of_blocks.size() > 0
      args.labels << [580, 600, 'Left Intersection']
      hero.stop_right_movement(touching_left_side_of_blocks)
    else
      hero.allow_right_movement()
    end
  else
    # undo any block based actions
    hero.unstand()
    hero.allow_left_movement()
    hero.allow_right_movement()
  end
end

def input_checking(args)
  hero = args.state.sprites.hero

  hero.jump() if args.inputs.keyboard.space
  hero.move_right() if right_pressed_no_left(args)
  hero.move_left() if left_pressed_no_right(args)
end

def right_pressed_no_left(args)
  return args.inputs.right && !args.inputs.left
end

def left_pressed_no_right(args)
  return args.inputs.left && !args.inputs.right
end

def initialize(args)
  args.state.sprites.blocks = [Block.new(args, 500, 150), Block.new(args, 500 + 16 + 8, 150 - 16), Block.new(args, 500 + 16 + 8 + 16 + 8, 150)]
  args.state.sprites.hero = Hero.new(args, 500, 200)

  args.state.sprites.all = [args.state.sprites.hero]
  args.state.sprites.all.concat(args.state.sprites.blocks)
end
