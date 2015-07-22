module IdeasHelper
  def get_text()
    "this is khoa test from ideashelper"
  end
  def get_file(param)
    "this is get_file first line"
    #result =`khoascript\agent_table.rb -f public/uploads/idea/picture/6/support_report.org_3.agent_332.7d6a0c89-122a-4b23-9b89-85bfcef2b9c9.tgz`
    #result
    @file1 = param
    result = `khoascript/agent_table.rb -f #{@file1}`
    @test = result.split(/\n/)
    #ar_result = result.split(/\n/)
  end
end
