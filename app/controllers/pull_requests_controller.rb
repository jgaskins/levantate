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
    raise "Signatures don't match!" unless verify_signature


    author = Engineer.find_or_create_by(login: payload_params.pull_request[:author]) do |eng|
      eng.avatar_url = payload_params.pull_request[:author_image_url]
    end

    if payload_params.pull_request[:reviewer]
      reviewer = Engineer.find_or_create_by(login: payload_params.pull_request[:reviewer]) do |eng|
        eng.avatar_url = payload_params.pull_request[:reviewer_image_url]
      end
    end

    github_id = payload_params.pull_request[:github_id]

    if github_id
      pr = PullRequest.find_or_create_by(github_id: github_id) do |new_pr|
        new_pr.number = payload_params.number
        new_pr.title = payload_params.pull_request[:title]
        new_pr.author = author
        new_pr.url = payload_params.pull_request[:url]
        new_pr.repo = payload_params.repository
      end

      ## Remove after all PRs have been updated
      old_pr = PullRequest.where(number: payload_params.number, github_id: nil)
      old_pr.first.destroy if old_pr.any?

      pr.update(reviewer: reviewer) if reviewer && pr.reviewer.nil?

      PullRequestOperations::AssessPayload.run(pr, payload_params) if pr
    else
    end


    render json: {}, status: :ok
  end

  private

  def payload_params
    @payload_params ||= PayloadParams.new(params)
  end

  def verify_signature
    payload_body = request.body
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'),
                                                  ENV['SECRET_TOKEN'] || '',
                                                  payload_body.read)

    Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
  end
end
