Fabricator(:pull_request) do
  author { Fabricate(:engineer) }
  reviewer { Fabricate(:engineer) }
  title { FFaker::CheesyLingo.title }
  number { Random.new.rand(0...1500) }
  url { FFaker::Internet.http_url }
  repo { FFaker::DizzleIpsum.word }
  state                 1
end
