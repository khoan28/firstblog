module IdeasHelper
  def get_text()
    "this is khoa test from ideashelper"
  end
  def get_file(param)
    "this is get_file first line"
    @file1 = param
    result = `khoascript/agent_table.rb -f #{@file1}`
    @test = result.split(/\n/)
  end
end
