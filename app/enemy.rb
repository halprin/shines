class Enemy < Sprite

  def initialize(args, pathing, path_type, duration)
    starting_x = pathing[0]['x'] * Block.default_width
    starting_y = pathing[0]['y'] * Block.default_height

    super(args, '/sprites/enemies/enemy.png', starting_x, starting_y, 40, 40)

    @pathing = pathing
    @path_type = path_type
    @duration = duration

    @start_tick = 0
    @previous_progress = 0
    @current_pathing_segment_index = 0
    @next_pathing_segment_index = @pathing.size() > 1 ? 1 : 0
  end

  def calculate(args)

    if @previous_progress >= 1
      # fulfilled the entire animation of one segment
      @current_pathing_segment_index = @next_pathing_segment_index
      @next_pathing_segment_index += 1

      if @next_pathing_segment_index > @pathing.size() - 1
        @next_pathing_segment_index = 0
      end

      @start_tick = args.state.tick_count

      # if @path_type == 'rewind'
      #   @starting_x, @ending_x = @ending_x, @starting_x
      #   @starting_y, @ending_y = @ending_y, @starting_y
      # end
    end

    progress = args.easing.ease(@start_tick, args.state.tick_count, @duration * 60, :identity)
    @previous_progress = progress

    current_segment = @pathing[@current_pathing_segment_index]
    next_segment = @pathing[@next_pathing_segment_index]

    starting_x = current_segment['x'] * Block.default_width
    starting_y = current_segment['y'] * Block.default_height
    ending_x = next_segment['x'] * Block.default_width
    ending_y = next_segment['y'] * Block.default_height

    total_delta_x = ending_x - starting_x
    total_delta_y = ending_y - starting_y

    progress_delta_x = total_delta_x * progress
    progress_delta_y = total_delta_y * progress

    @x = starting_x + progress_delta_x
    @y = starting_y + progress_delta_y
  end
end
