class GameOverScene < Scene
  def initialize(args)
    super('game_over', args)
  end

  def tick(args)
    # black background
    args.outputs.background_color = [0, 0, 0]

    args.outputs.labels << [args.grid.right / 2, args.grid.top / 2, 'Game Over', 10, 1, 255, 255, 255]
  end
end
