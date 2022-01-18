SPRITES = []

BLOCKS = []

HERO = Hero.new(500, 200)

BLOCK = Block.new(500, 150)
BLOCKS << BLOCK

SPRITES << HERO
SPRITES.concat(BLOCKS)

def tick(args)

  colision_checking(args)

  input_checking(args)

  SPRITES.each(&:calculate)

  args.outputs.sprites << SPRITES
end

def colision_checking(args)
  if BLOCKS.any_intersect_rect? HERO
    args.outputs.labels << [500, 500, 'intersection']
    HERO.stand()
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
