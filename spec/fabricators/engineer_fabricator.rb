Fabricator(:engineer) do
  login { FFaker::Internet.user_name }
  avatar_url { FFaker::Avatar.image }
end
