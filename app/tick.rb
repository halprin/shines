def tick(args)

  if args.state.tick_count.zero?
    initialize(args)
  end

  input_checking(args)

  args.state.sprites.all.each(&:calculate)

  collision_checking(args)

  args.outputs.background_color = args.state.background
  args.outputs.sprites << args.state.sprites.all
  display_ui(args)
end

def collision_checking(args)
  collision_for_blocks(args)
end

def collision_for_blocks(args)
  hero = args.state.sprites.hero

  intersecting_blocks = args.state.sprites.blocks.select { |block| block.intersect_rect?(hero, 0) }

  if intersecting_blocks.size().positive?
    above_blocks = intersecting_blocks.select { |block| block.collision_side(hero) == 'TOP' }
    touching_right_side_of_blocks = intersecting_blocks.select { |block| block.collision_side(hero) == 'RIGHT' }
    touching_left_side_of_blocks = intersecting_blocks.select { |block| block.collision_side(hero) == 'LEFT' }

    if above_blocks.size().positive?
      args.outputs.debug << [args.grid.left, args.grid.top - 60, 'Above', -2, 0, 255, 255, 255].label
      hero.stand(above_blocks)
    else
      hero.unstand()
    end

    if touching_right_side_of_blocks.size().positive?
      args.outputs.debug << [args.grid.left + 100, args.grid.top - 60, 'Right', -2, 0, 255, 255, 255].label
      hero.stop_left_movement(touching_right_side_of_blocks)
    else
      hero.allow_left_movement()
    end

    if touching_left_side_of_blocks.size().positive?
      args.outputs.debug << [args.grid.left + 200, args.grid.top - 60, 'Left', -2, 0, 255, 255, 255].label
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

def display_ui(args)
  # background
  args.outputs.solids << [args.grid.left, args.grid.top - 80, args.grid.right, args.grid.top]

  # score
  args.outputs.labels << [args.grid.left, args.grid.top, 'Score', 0, 0, 255, 255, 255]
  args.outputs.labels << [args.grid.left, args.grid.top - 16, '%07d' % args.state.score, 5, 0, 255, 255, 255]

  # time
  args.outputs.labels << [args.grid.left + 150, args.grid.top, 'Time', 0, 0, 255, 255, 255]
  seconds = '%05.2f' % (0.elapsed_time / 60 % 60)
  minutes = '%02d' % (0.elapsed_time / 60 / 60 % 60)
  hours = '%02d' % (0.elapsed_time / 60 / 60 / 60)
  args.outputs.labels << [args.grid.left + 150, args.grid.top - 16, "#{hours}:#{minutes}:#{seconds}", 5, 0, 255, 255, 255]

  # lives
  args.outputs.labels << [args.grid.left + 350, args.grid.top, 'Lives', 0, 0, 255, 255, 255]
  args.outputs.labels << [args.grid.left + 350, args.grid.top - 16, args.state.lives, 5, 0, 255, 255, 255]
end

def initialize(args)
  args.state.score = 0
  args.state.lives = 5

  read_level(args)

  args.state.sprites.all = [args.state.sprites.hero]
  args.state.sprites.all.concat(args.state.sprites.blocks)
end

def read_level(args)
  puts('Reading level')
  level = args.gtk.parse_json_file('/data/level1.json')

  puts("Parsing level #{level['name']}")

  args.state.background = [level['background']['red'], level['background']['green'], level['background']['blue']]

  args.state.sprites.hero = Hero.new(args, level['hero'][0] * Block.default_width, level['hero'][1] * Block.default_height)

  args.state.sprites.blocks = level['blocks'].map { |block| Block.new(args, block['x'] * Block.default_width, block['y'] * Block.default_height) }

  puts("Loading level #{level['name']} complete")
end
