local helpers = require('test.functional.helpers')(after_each)
local Screen = require('test.functional.ui.screen')
local clear = helpers.clear
local command = helpers.command
local exec = helpers.exec
local feed = helpers.feed

describe("'number' and 'relativenumber'", function()
  before_each(clear)

  -- oldtest: Test_relativenumber_colors()
  it('LineNr, LineNrAbove and LineNrBelow', function()
    local screen = Screen.new(50, 10)
    screen:set_default_attr_ids({
      [1] = { foreground = Screen.colors.Red },
      [2] = { foreground = Screen.colors.Blue },
      [3] = { foreground = Screen.colors.Green },
    })
    screen:attach()
    exec([[
      call setline(1, range(200))
      111
      set number relativenumber
      hi LineNr guifg=red
    ]])
    screen:expect([[
      {1:  4 }106                                           |
      {1:  3 }107                                           |
      {1:  2 }108                                           |
      {1:  1 }109                                           |
      {1:111 }^110                                           |
      {1:  1 }111                                           |
      {1:  2 }112                                           |
      {1:  3 }113                                           |
      {1:  4 }114                                           |
                                                        |
    ]])
    command('hi LineNrAbove guifg=blue')
    screen:expect([[
      {2:  4 }106                                           |
      {2:  3 }107                                           |
      {2:  2 }108                                           |
      {2:  1 }109                                           |
      {1:111 }^110                                           |
      {1:  1 }111                                           |
      {1:  2 }112                                           |
      {1:  3 }113                                           |
      {1:  4 }114                                           |
                                                        |
    ]])
    command('hi LineNrBelow guifg=green')
    screen:expect([[
      {2:  4 }106                                           |
      {2:  3 }107                                           |
      {2:  2 }108                                           |
      {2:  1 }109                                           |
      {1:111 }^110                                           |
      {3:  1 }111                                           |
      {3:  2 }112                                           |
      {3:  3 }113                                           |
      {3:  4 }114                                           |
                                                        |
    ]])
    command('hi clear LineNrAbove')
    screen:expect([[
      {1:  4 }106                                           |
      {1:  3 }107                                           |
      {1:  2 }108                                           |
      {1:  1 }109                                           |
      {1:111 }^110                                           |
      {3:  1 }111                                           |
      {3:  2 }112                                           |
      {3:  3 }113                                           |
      {3:  4 }114                                           |
                                                        |
    ]])
  end)

  -- oldtest: Test_relativenumber_colors_wrapped()
  it('LineNr, LineNrAbove and LineNrBelow with wrapped lines', function()
    local screen = Screen.new(50, 20)
    screen:set_default_attr_ids({
      [1] = { background = Screen.colors.Red, foreground = Screen.colors.Black },
      [2] = { background = Screen.colors.Blue, foreground = Screen.colors.Black },
      [3] = { background = Screen.colors.Green, foreground = Screen.colors.Black },
      [4] = { bold = true, foreground = Screen.colors.Blue },
    })
    screen:attach()
    exec([[
      set display=lastline scrolloff=0
      call setline(1, range(200)->map('v:val->string()->repeat(40)'))
      111
      set number relativenumber
      hi LineNr guibg=red guifg=black
      hi LineNrAbove guibg=blue guifg=black
      hi LineNrBelow guibg=green guifg=black
    ]])
    screen:expect([[
      {2:  2 }1081081081081081081081081081081081081081081081|
      {2:    }0810810810810810810810810810810810810810810810|
      {2:    }8108108108108108108108108108                  |
      {2:  1 }1091091091091091091091091091091091091091091091|
      {2:    }0910910910910910910910910910910910910910910910|
      {2:    }9109109109109109109109109109                  |
      {1:111 }^1101101101101101101101101101101101101101101101|
      {1:    }1011011011011011011011011011011011011011011011|
      {1:    }0110110110110110110110110110                  |
      {3:  1 }1111111111111111111111111111111111111111111111|
      {3:    }1111111111111111111111111111111111111111111111|
      {3:    }1111111111111111111111111111                  |
      {3:  2 }1121121121121121121121121121121121121121121121|
      {3:    }1211211211211211211211211211211211211211211211|
      {3:    }2112112112112112112112112112                  |
      {3:  3 }1131131131131131131131131131131131131131131131|
      {3:    }1311311311311311311311311311311311311311311311|
      {3:    }3113113113113113113113113113                  |
      {3:  4 }1141141141141141141141141141141141141141141{4:@@@}|
                                                        |
    ]])
    feed('k')
    screen:expect([[
      {2:  1 }1081081081081081081081081081081081081081081081|
      {2:    }0810810810810810810810810810810810810810810810|
      {2:    }8108108108108108108108108108                  |
      {1:110 }^1091091091091091091091091091091091091091091091|
      {1:    }0910910910910910910910910910910910910910910910|
      {1:    }9109109109109109109109109109                  |
      {3:  1 }1101101101101101101101101101101101101101101101|
      {3:    }1011011011011011011011011011011011011011011011|
      {3:    }0110110110110110110110110110                  |
      {3:  2 }1111111111111111111111111111111111111111111111|
      {3:    }1111111111111111111111111111111111111111111111|
      {3:    }1111111111111111111111111111                  |
      {3:  3 }1121121121121121121121121121121121121121121121|
      {3:    }1211211211211211211211211211211211211211211211|
      {3:    }2112112112112112112112112112                  |
      {3:  4 }1131131131131131131131131131131131131131131131|
      {3:    }1311311311311311311311311311311311311311311311|
      {3:    }3113113113113113113113113113                  |
      {3:  5 }1141141141141141141141141141141141141141141{4:@@@}|
                                                        |
    ]])
    feed('2j')
    screen:expect([[
      {2:  3 }1081081081081081081081081081081081081081081081|
      {2:    }0810810810810810810810810810810810810810810810|
      {2:    }8108108108108108108108108108                  |
      {2:  2 }1091091091091091091091091091091091091091091091|
      {2:    }0910910910910910910910910910910910910910910910|
      {2:    }9109109109109109109109109109                  |
      {2:  1 }1101101101101101101101101101101101101101101101|
      {2:    }1011011011011011011011011011011011011011011011|
      {2:    }0110110110110110110110110110                  |
      {1:112 }^1111111111111111111111111111111111111111111111|
      {1:    }1111111111111111111111111111111111111111111111|
      {1:    }1111111111111111111111111111                  |
      {3:  1 }1121121121121121121121121121121121121121121121|
      {3:    }1211211211211211211211211211211211211211211211|
      {3:    }2112112112112112112112112112                  |
      {3:  2 }1131131131131131131131131131131131131131131131|
      {3:    }1311311311311311311311311311311311311311311311|
      {3:    }3113113113113113113113113113                  |
      {3:  3 }1141141141141141141141141141141141141141141{4:@@@}|
                                                        |
    ]])
    feed('2j')
    screen:expect([[
      {2:  5 }1081081081081081081081081081081081081081081081|
      {2:    }0810810810810810810810810810810810810810810810|
      {2:    }8108108108108108108108108108                  |
      {2:  4 }1091091091091091091091091091091091091091091091|
      {2:    }0910910910910910910910910910910910910910910910|
      {2:    }9109109109109109109109109109                  |
      {2:  3 }1101101101101101101101101101101101101101101101|
      {2:    }1011011011011011011011011011011011011011011011|
      {2:    }0110110110110110110110110110                  |
      {2:  2 }1111111111111111111111111111111111111111111111|
      {2:    }1111111111111111111111111111111111111111111111|
      {2:    }1111111111111111111111111111                  |
      {2:  1 }1121121121121121121121121121121121121121121121|
      {2:    }1211211211211211211211211211211211211211211211|
      {2:    }2112112112112112112112112112                  |
      {1:114 }^1131131131131131131131131131131131131131131131|
      {1:    }1311311311311311311311311311311311311311311311|
      {1:    }3113113113113113113113113113                  |
      {3:  1 }1141141141141141141141141141141141141141141{4:@@@}|
                                                        |
    ]])
    feed('k')
    screen:expect([[
      {2:  4 }1081081081081081081081081081081081081081081081|
      {2:    }0810810810810810810810810810810810810810810810|
      {2:    }8108108108108108108108108108                  |
      {2:  3 }1091091091091091091091091091091091091091091091|
      {2:    }0910910910910910910910910910910910910910910910|
      {2:    }9109109109109109109109109109                  |
      {2:  2 }1101101101101101101101101101101101101101101101|
      {2:    }1011011011011011011011011011011011011011011011|
      {2:    }0110110110110110110110110110                  |
      {2:  1 }1111111111111111111111111111111111111111111111|
      {2:    }1111111111111111111111111111111111111111111111|
      {2:    }1111111111111111111111111111                  |
      {1:113 }^1121121121121121121121121121121121121121121121|
      {1:    }1211211211211211211211211211211211211211211211|
      {1:    }2112112112112112112112112112                  |
      {3:  1 }1131131131131131131131131131131131131131131131|
      {3:    }1311311311311311311311311311311311311311311311|
      {3:    }3113113113113113113113113113                  |
      {3:  2 }1141141141141141141141141141141141141141141{4:@@@}|
                                                        |
    ]])
  end)

  -- oldtest: Test_relativenumber_callback()
  it('relative line numbers are updated if cursor is moved from timer', function()
    local screen = Screen.new(50, 8)
    screen:set_default_attr_ids({
      [1] = { foreground = Screen.colors.Brown }, -- LineNr
      [2] = { bold = true, foreground = Screen.colors.Blue1 }, -- NonText
    })
    screen:attach()
    exec([[
      call setline(1, ['aaaaa', 'bbbbb', 'ccccc', 'ddddd'])
      set relativenumber
      call cursor(4, 1)

      func Func(timer)
        call cursor(1, 1)
      endfunc

      call timer_start(300, 'Func')
    ]])
    screen:expect({
      grid = [[
      {1:  3 }aaaaa                                         |
      {1:  2 }bbbbb                                         |
      {1:  1 }ccccc                                         |
      {1:  0 }^ddddd                                         |
      {2:~                                                 }|*3
                                                        |
    ]],
      timeout = 100,
    })
    screen:expect({
      grid = [[
      {1:  0 }^aaaaa                                         |
      {1:  1 }bbbbb                                         |
      {1:  2 }ccccc                                         |
      {1:  3 }ddddd                                         |
      {2:~                                                 }|*3
                                                        |
    ]],
    })
  end)

  -- oldtest: Test_number_insert_delete_lines()
  it('line numbers are updated when deleting/inserting lines', function()
    local screen = Screen.new(50, 8)
    screen:set_default_attr_ids({
      [1] = { foreground = Screen.colors.Brown }, -- LineNr
      [2] = { bold = true, foreground = Screen.colors.Blue1 }, -- NonText
    })
    screen:attach()
    exec([[
      call setline(1, range(1, 7))
      set number
      call cursor(2, 1)
    ]])
    local snapshot1 = [[
      {1:  1 }1                                             |
      {1:  2 }^2                                             |
      {1:  3 }3                                             |
      {1:  4 }4                                             |
      {1:  5 }5                                             |
      {1:  6 }6                                             |
      {1:  7 }7                                             |
                                                        |
    ]]
    screen:expect(snapshot1)
    feed('dd')
    screen:expect([[
      {1:  1 }1                                             |
      {1:  2 }^3                                             |
      {1:  3 }4                                             |
      {1:  4 }5                                             |
      {1:  5 }6                                             |
      {1:  6 }7                                             |
      {2:~                                                 }|
                                                        |
    ]])
    feed('P')
    screen:expect(snapshot1)
    feed('2dd')
    screen:expect([[
      {1:  1 }1                                             |
      {1:  2 }^4                                             |
      {1:  3 }5                                             |
      {1:  4 }6                                             |
      {1:  5 }7                                             |
      {2:~                                                 }|*2
                                                        |
    ]])
    feed('P')
    screen:expect(snapshot1)
  end)
end)