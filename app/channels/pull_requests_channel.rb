class PullRequestsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'pull_request_update'
  end
end
