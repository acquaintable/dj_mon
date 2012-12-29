class TestMonsterJob
  def perform
    raise "here is error"
  end

  def make_success job
  end

  def make_fail job
  end
end
