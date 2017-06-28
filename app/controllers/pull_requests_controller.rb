class PullRequestsController < ApplicationController
  protect_from_forgery :except => [:payload]

  def index
  end

  def active
    prs = PullRequest
            .where.not(state: :does_not_need_review)
            .eager_load([:author, :reviewer])

    render json: {
      pull_requests:
        prs.as_json(
          include: {
            author: { only: [:login, :avatar_url] },
            reviewer: { only: [:login, :avatar_url] },
          }
      )
    }
  end

  def payload
    author = Engineer.find_or_create_by(login: payload_params.pull_request[:author]) do |eng|
      eng.avatar_url = payload_params.pull_request[:author_image_url]
    end

    if payload_params.pull_request[:reviewer]
      reviewer = Engineer.find_or_create_by(login: payload_params.pull_request[:reviewer]) do |eng|
        eng.avatar_url = payload_params.pull_request[:reviewer_image_url]
      end
    end

    pr = PullRequest.find_or_create_by(number: payload_params.number) do |new_pr|
      new_pr.title = payload_params.pull_request[:title]
      new_pr.author = author
      new_pr.url = payload_params.pull_request[:url]
      new_pr.repo = payload_params.repository
    end

    pr.update(reviewer: reviewer) if reviewer && pr.reviewer.nil?

    #PullRequestOperations::AssessPayload.run(pr, payload_params) if pr

    render json: { pr: pr.reload }, status: :ok
  end

  private

  def payload_params
    @payload_params ||= PayloadParams.new(params)
  end
end
