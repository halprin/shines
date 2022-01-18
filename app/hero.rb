class Hero < Sprite
  @@initial_jump_acceleration = 2
  @@max_jump_velocity = 10

  @@gravity_acceleration = -1
  @@max_gravity_velocity = -10


  def initialize(starting_x, starting_y)
    super('/sprites/hero/hero.png', starting_x, starting_y, 16, 16)

    @jumping = false
    @standing = false
    _reset_jump()

    @move_velocity = 1
    @moving_right = false
    @moving_left = false
  end

  # Action methods

  def stand(intersecting_blocks)
    @standing = true

    @jumping = false
    _reset_jump()

    # TODO: support multiple blocks?
    first_intersecting_block = intersecting_blocks[0]
    @y = first_intersecting_block.y + first_intersecting_block.h
  end

  def unstand
    return unless @standing

    @standing = false

    @jumping = false
    _reset_jump()
  end

  def jump
    if @jumping || !@standing
      # jumping is already in progress, don't start the jump over
      # Or...
      # standing isn't happening, so we can't jump
      return
    end

    @jumping = true
    @standing = false
    _reset_jump()
  end

  def move_right
    @moving_right = true
  end

  def move_left
    @moving_left = true
  end

  def _reset_jump
    @vertical_velocity = 0
    @jump_acceleration = @@initial_jump_acceleration
  end

  # Calculation methods

  def calculate
    puts("y=#{@y}")
    puts("vertical velocity=#{@vertical_velocity}")
    _calculate_gravity() unless @standing
    _calculate_jump() if @jumping
    _calculate_vertical_position()
    _calculate_move_right() if @moving_right
    _calculate_move_left() if @moving_left
  end

  def _calculate_vertical_position
    @y += @vertical_velocity
  end

  def _calculate_gravity

    # check for terminal velocity
    if @vertical_velocity <= @@max_gravity_velocity
      # we've hit terminal velocity on the way down
      @vertical_velocity = @@max_gravity_velocity
    else
      # not terminal velocity yet, keep decreasing vertical velocity
      @vertical_velocity += @@gravity_acceleration
    end
  end

  def _calculate_jump

    if @vertical_velocity >= @@max_jump_velocity
      # hit max speed of the jump up, need to start slowing down
      # slowing down is accomplished by gravity
      @vertical_velocity = @@max_jump_velocity
      @jump_acceleration = 0
    end

    # modify the values
    @vertical_velocity += @jump_acceleration
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
