class MainGameScene < Scene
  def initialize(level_path, args)
    super('main_game', args)

    @score = 0
    @lives = 5
    @level = nil
    @hero = nil
    @blocks = []
    @enemies = []

    load_level(args, level_path)

    @sprites = [@hero]
    @sprites.concat(@blocks)
    @sprites.concat(@enemies)
  end

  def tick(args)
    input_checking(args)

    @sprites.each { |sprite| sprite.calculate(args) }

    collision_checking(args)

    args.outputs.background_color = @background
    args.outputs.sprites << @sprites
    display_ui(args)
  end

  def collision_checking(args)
    collision_for_enemies(args)
    collision_for_blocks(args)
  end

  def collision_for_enemies(args)

    touching_enemies = @enemies.select { |enemy| enemy.intersect_rect?(@hero, 0.1) }

    if touching_enemies.size().positive?
      @hero.die()
      @lives -= 1
      reset_level(args)
    end
  end

  def collision_for_blocks(args)

    touching_right_side_of_blocks = @blocks.select { |block| block.intersect_rect?(@hero, 0.1) && block.collision_side(@hero) == 'RIGHT' }

    if touching_right_side_of_blocks.size().positive?
      args.outputs.debug << [args.grid.left + 100, args.grid.top - 60, 'Right', -2, 0, 255, 255, 255].label
      @hero.stop_left_movement(touching_right_side_of_blocks)
    else
      @hero.allow_left_movement()
    end

    touching_left_side_of_blocks = @blocks.select { |block| block.intersect_rect?(@hero, 0.1) && block.collision_side(@hero) == 'LEFT' }

    if touching_left_side_of_blocks.size().positive?
      args.outputs.debug << [args.grid.left + 200, args.grid.top - 60, 'Left', -2, 0, 255, 255, 255].label
      @hero.stop_right_movement(touching_left_side_of_blocks)
    else
      @hero.allow_right_movement()
    end

    above_blocks = @blocks.select { |block| block.intersect_rect?(@hero, 0) && block.collision_side(@hero) == 'TOP' }

    if above_blocks.size().positive?
      args.outputs.debug << [args.grid.left, args.grid.top - 60, 'Top', -2, 0, 255, 255, 255].label
      @hero.stand(above_blocks)
    else
      @hero.unstand()
    end

    touching_bottom_side_of_blocks = @blocks.select { |block| block.intersect_rect?(@hero, 0.1) && block.collision_side(@hero) == 'BOTTOM' }

    if touching_bottom_side_of_blocks.size().positive?
      args.outputs.debug << [args.grid.left + 300, args.grid.top - 60, 'Bottom', -2, 0, 255, 255, 255].label
      @hero.bonk(touching_bottom_side_of_blocks)
    end
  end

  def input_checking(args)

    @hero.jump() if args.inputs.keyboard.space
    @hero.move_right() if right_pressed_no_left(args)
    @hero.move_left() if left_pressed_no_right(args)
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
    args.outputs.labels << [args.grid.left, args.grid.top - 16, '%07d' % @score, 5, 0, 255, 255, 255]

    # time
    args.outputs.labels << [args.grid.left + 150, args.grid.top, 'Time', 0, 0, 255, 255, 255]
    seconds = '%05.2f' % (0.elapsed_time / 60 % 60)
    minutes = '%02d' % (0.elapsed_time / 60 / 60 % 60)
    hours = '%02d' % (0.elapsed_time / 60 / 60 / 60)
    args.outputs.labels << [args.grid.left + 150, args.grid.top - 16, "#{hours}:#{minutes}:#{seconds}", 5, 0, 255, 255, 255]

    # lives
    args.outputs.labels << [args.grid.left + 350, args.grid.top, 'Lives', 0, 0, 255, 255, 255]
    args.outputs.labels << [args.grid.left + 350, args.grid.top - 16, @lives, 5, 0, 255, 255, 255]
  end

  def reset_level(args)

    parse_level(args, @level)

    @sprites = [@hero]
    @sprites.concat(@blocks)
    @sprites.concat(@enemies)
  end

  def load_level(args, level_path)
    puts("Loading level #{level_path}")

    level = read_level(args, level_path)
    parse_level(args, level)

    puts("Loading level #{level['name']} complete")
  end

  def read_level(args, level_path)
    puts("Reading level #{level_path}")

    level = args.gtk.parse_json_file(level_path)
    @level = level

    puts('Reading level complete')
    return level
  end

  def parse_level(args, level)
    puts("Parsing level #{level['name']}")

    @background = [level['background']['red'], level['background']['green'], level['background']['blue']]

    @hero = Hero.new(args, level['hero'][0] * Block.default_width, level['hero'][1] * Block.default_height)

    @blocks = level['blocks'].map { |block| Block.new(args, block['x'] * Block.default_width, block['y'] * Block.default_height) }

    @enemies = level['enemies'].map { |enemy|
      Enemy.new(args,
                enemy['path'],
                enemy['path_type'],
                enemy['duration']) }

    puts("Parsing level #{level['name']} complete")
  end
end
