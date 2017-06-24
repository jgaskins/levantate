class PullRequestsController < ApplicationController
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
    author = Engineer.find_or_create_by(login: pull_request_params.author) do |eng|
      eng.avatar_url = pull_request_params.author_image_url
    end

    if pull_request_params.reviewer
      reviewer = Engineer.find_or_create_by(login: pull_request_params.reviewer) do |eng|
        eng.avatar_url = pull_request_params.reviewer_image_url
      end
    end

    pr = PullRequest.find_or_create_by(number: pull_request_params.number) do |new_pr|
      new_pr.title = pull_request_params.title
      new_pr.author = author
      new_pr.url = pull_request_params.url
      new_pr.repo = pull_request_params.repo
    end

    pr.update(reviewer: reviewer) if reviewer && pr.reviewer.nil?

    PullRequestOperations::AssessPayload.run(pr, pull_request_params) if pr

    render json: { pr: pr.reload }, status: :ok
  end

  private

  def pull_request_params
    PullRequestParams.new(params)
  end
end
