module PullRequestOperations
  class AssessPayload
    attr_reader :pr, :review

    def initialize(pull_request, params, review = {})
      @pr = pull_request
      @params = params
      @review = review
    end

    def self.run(*args)
      new(*args).process
    end

    def process
      return pr.close_pr if state == 'closed' || state == 'merged'

      case action
      when 'unlabeled'
        pr.unmark_as_review_ready if label == 'needs reviewing'
      when 'labeled'
        pr.mark_as_review_ready if label == 'needs reviewing'
        pr.unmark_as_review_ready if label == 'work in progress'
        pr.approve if label == 'ready for merge'
      when 'assigned'
        pr.assign
      when 'unassigned'
        pr.unassign
      when 'closed'
        pr.close_pr
      when 'opened'
        pr.open_pr
      when 'submitted'
        pr.approve if review_state == 'approved'
      when 'dismissed'
        review.dismissed!
        pr.mark_as_review_ready if pr.reviews.count == 1
      else
        pp "I don't recognize the action: #{action}"
      end

      ActionCable.server.broadcast('pull_request_update', body: body)
    end

    private

    def action
      @action ||= @params.action
    end

    def body
      pr.as_json(
        include: {
          author: { only: [:login, :avatar_url] },
          reviewer: { only: [:login, :avatar_url] },
        }
      )
    end

    def label
      @label ||= @params.label
    end

    def review_state
      @review_state ||= review[:state] || @params.review[:state]
    end

    def state
      @state ||= @params.pull_request[:state]
    end
  end
end
