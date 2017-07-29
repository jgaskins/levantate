class PullRequestsController < ApplicationController
  protect_from_forgery :except => [:payload]
  before_action :authenticate_user!, :except => [:payload]

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

    PullRequestOperations::AssessPayload.run(pr, payload_params, review)

    render json: {}, status: :ok
  end

  private

  def pr
    pr_params = payload_params.pull_request

    return if pr_params[:github_id].nil?

    author = Engineer.find_or_create_by(login: pr_params[:author]) do |eng|
      eng.avatar_url = pr_params[:author_image_url]
      eng.user = User.find_by(uid: pr_params[:author_github_id])
    end

    if payload_params.action == 'opened'
      PullRequest.create!(
        author: author,
        github_id: pr_params[:github_id],
        number: pr_params[:number],
        title: pr_params[:title],
        url: pr_params[:url],
        repo: pr_params[:repo]
      )
    end

    pr = PullRequest.find_by(github_id: pr_params[:github_id])

    pr.with_lock do
      pr.reviewer = Engineer.find_or_create_by(login: pr_params[:reviewer]) do |eng|
        eng.avatar_url = pr_params[:reviewer_image_url]
        eng.user = User.find_by(uid: pr_params[:reviewer_github_id])
      end

      pr.save!
    end

    pr
  end

  def review
    review_params = payload_params.review

    return if review_params[:github_id].nil?

    rev = Review.find_or_initialize_by(github_id: review_params[:github_id]) do |r|
      r.submitted_at = review_params[:submitted_at]
      r.url = review_params[:url]
      r.pull_request = pr
      r.author = Engineer.find_or_create_by(login: review_params[:author]) do |eng|
        eng.avatar_url = review_params[:author_image_url]
        eng.user = User.find_by(uid: review_params[:author_github_id])
      end
    end

    rev.with_lock do
      rev.body = review_params[:body]
      rev.state = review_params[:state]

      rev.save!
    end

    rev
  end

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
