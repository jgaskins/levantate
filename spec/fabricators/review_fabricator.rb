Fabricator(:review) do
  github_id { SecureRandom.hex(20) }
  url { FFaker::Internet.http_url }
  body { FFaker::HipsterIpsum.sentence }
  pull_request
  author { Fabricate(:engineer) }
end
