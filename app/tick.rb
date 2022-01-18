SPRITES = []
HERO = Hero.new(500, 200)
BLOCK = Block.new(500, 150)
SPRITES << HERO
SPRITES << BLOCK

def tick(args)

  HERO.jump() if args.inputs.keyboard.space
  HERO.move_right() if right_pressed_no_left(args)
  HERO.move_left() if left_pressed_no_right(args)

  SPRITES.each(&:calculate)

  args.outputs.sprites << SPRITES
end

def right_pressed_no_left(args)
  return args.inputs.right && !args.inputs.left
end

def left_pressed_no_right(args)
  return args.inputs.left && !args.inputs.right
end
