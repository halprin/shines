class Hero < Sprite
	@@initialJumpAcceleration = 1
	@@maxJumpVelocity = 10

	def initialize(starting_x, starting_y)
		super('/sprites/hero/wall-0000.png', starting_x, starting_y, 16, 16)

		@jumping = false
		@jumpVelocity = 0
		@jumpAcceleration = 1

		@moveVelocity = 1
		@movingRight = false
		@movingLeft = false
	end

	# Action methods

	def jump
		if @jumping
			# jumping is already in progress, don't start the jump over
			return
		end

		@jumping = true
		@jumpVelocity = 0
		@jumpAcceleration = @@initialJumpAcceleration
	end

	def moveRight
		@movingRight = true
	end

	def moveLeft
		@movingLeft = true
	end

	# Calculation methods

	def calculate
		if @jumping
			_calculate_jump()
		end
		if @movingRight
			_calculate_moveRight()
		end
		if @movingLeft
			_calculate_moveLeft()
		end
	end

	def _calculate_jump

		if @jumpVelocity > @@maxJumpVelocity
			# hit max speed of the jump up, need to start slowing down
			@jumpAcceleration = -1 * @@initialJumpAcceleration
		end

		if @jumpAcceleration == (-1 * @@initialJumpAcceleration) && @jumpVelocity <= -1 * @@maxJumpVelocity
			# we've hit terminal velocity on the way down
			@jumpAcceleration = 0
		end

		if @y <= 0 && @jumpAcceleration == 0
			# we're done jumping, force hero to the bottom
			@y = 0
			@jumping = false
			return
		end

		# modify the values
		@jumpVelocity += @jumpAcceleration
		@y += @jumpVelocity
	end

	def _calculate_moveRight
		@x += @moveVelocity
		@movingRight = false
	end

	def _calculate_moveLeft
		@x -= @moveVelocity
		@movingLeft = false
	end
end
