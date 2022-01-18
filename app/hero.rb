class Hero < Sprite
  @@initial_jump_acceleration = 1
  @@max_jump_velocity = 10

  @@gravity_acceleration = 1
  @@max_gravity_velocity = 10


  def initialize(starting_x, starting_y)
    super('/sprites/hero/hero.png', starting_x, starting_y, 16, 16)

    @jumping = false
    @jump_velocity = 0
    @jump_acceleration = 1

    @gravity_velocity = 0

    @move_velocity = 1
    @moving_right = false
    @moving_left = false
  end

  # Action methods

  def jump
    if @jumping
      # jumping is already in progress, don't start the jump over
      return
    end

    @jumping = true
    @jump_velocity = 0
    @jump_acceleration = @@initial_jump_acceleration
  end

  def move_right
    @moving_right = true
  end

  def move_left
    @moving_left = true
  end

  # Calculation methods

  def calculate
    _calculate_gravity()
    _calculate_jump() if @jumping
    _calculate_move_right() if @moving_right
    _calculate_move_left() if @moving_left
  end

  def _calculate_gravity

    # check for terminal velocity
    if @gravity_velocity >= @@max_gravity_velocity
      # we've hit terminal velocity on the way down
      @gravity_velocity = @@max_gravity_velocity
    else
      # not terminal velocity yet, keep increasing velocity
      @gravity_velocity += @@gravity_acceleration
    end

    # modify the y position
    @y -= @gravity_velocity
  end

  def _calculate_jump

    if @jump_velocity > @@max_jump_velocity
      # hit max speed of the jump up, need to start slowing down
      @jump_acceleration = -1 * @@initial_jump_acceleration
    end

    if @jump_acceleration == (-1 * @@initial_jump_acceleration) && @jump_velocity <= -1 * @@max_jump_velocity
      # we've hit terminal velocity on the way down
      @jump_acceleration = 0
    end

    if @y <= 0 && @jump_acceleration.zero?
      # we're done jumping, force hero to the bottom
      @y = 0
      @jumping = false
      return
    end

    # modify the values
    @jump_velocity += @jump_acceleration
    @y += @jump_velocity
  end

  def _calculate_move_right
    @x += @move_velocity
    @moving_right = false
  end

  def _calculate_move_left
    @x -= @move_velocity
    @moving_left = false
  end
end
