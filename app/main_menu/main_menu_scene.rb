class MainMenuScene < Scene
  def initialize(args)
    super('main_menu', args)
  end

  def tick(args)
    # black background
    @args.outputs.background_color = [0, 0, 0]

    @args.outputs.labels << [@args.grid.w / 2, @args.grid.top - @args.grid.h / 4, 'Shines!', 10, 1, 255, 255, 255]

    button(args, 100, 100, 300, 100, 'Play', nil)
  end

  def button(args, x, y, w, h, text, code_to_execute)
    args.outputs.solids << [x, y, w, h, 255, 255, 255]
    _, label_height = args.gtk.calcstringbox('Start Game', 5)
    args.outputs.labels << [x + w / 2, y + h / 2 + label_height / 2, 'Start Game', 5, 1]

    mouse_clicked = args.inputs.mouse.click
    if mouse_clicked != nil && args.inputs.mouse.click.inside_rect?([x, y, w, h])
      args.state.scene = MainGameScene.new('/data/level1.json', args)
    end
  end
end
