SPRITES = []
HERO = Hero.new(500, 0)
SPRITES << HERO

def tick args

	if args.inputs.keyboard.space
		HERO.jump()
	end
	if rightPressed_noLeft(args)
		HERO.moveRight()
	end
	if leftPressed_noRight(args)
		HERO.moveLeft()
	end

	SPRITES.each { |sprite| sprite.calculate() }

	args.outputs.sprites << SPRITES
end

def rightPressed_noLeft args
	return args.inputs.right && !args.inputs.left
end

def leftPressed_noRight args
	return args.inputs.left && !args.inputs.right
end
