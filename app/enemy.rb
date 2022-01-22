class Enemy < Sprite

  def initialize(args, starting_x, starting_y, ending_x, ending_y, path_type, duration)
    super(args, '/sprites/enemies/enemy.png', starting_x, starting_y, 40, 40)

    @starting_x = starting_x
    @starting_y = starting_y

    @ending_x = ending_x
    @ending_y = ending_y

    @path_type = path_type
    @duration = duration
  end

  def calculate(args)
    progress = args.easing.ease(0, args.state.tick_count, @duration * 60, :identity)

    total_delta_x = @ending_x - @starting_x
    total_delta_y = @ending_y - @starting_y

    progress_delta_x = total_delta_x * progress
    progress_delta_y = total_delta_y * progress

    @x = @starting_x + progress_delta_x
    @y = @starting_y + progress_delta_y
  end
end
