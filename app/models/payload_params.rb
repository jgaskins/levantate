class PayloadParams
  attr_reader :action, :label, :pull_request, :review

  def initialize(params)
    @json_params = JSON.parse(params.require(:payload))

    @action ||= @json_params['action']
    @label ||= @json_params.dig('label', 'name')
    @pull_request =  extract_pull_request
    @review = extract_review
  end

  private

  def extract_pull_request
    pull_request = {}

    pull_request[:number] = @json_params.dig('pull_request', 'number')
    pull_request[:github_id] = @json_params.dig('pull_request', 'id')

    author = @json_params.dig('pull_request', 'user')
    assignee = @json_params.dig('pull_request', 'assignee')

    pull_request[:author_github_id] = @json_params.dig('pull_request', 'user', 'id')
    pull_request[:author] = @json_params.dig('pull_request', 'user', 'login')
    pull_request[:author_image_url] = @json_params.dig('pull_request', 'user',
                                                       'avatar_url')

    pull_request[:reviewer_github_id] = @json_params.dig('pull_request', 'assignee', 'id')
    pull_request[:reviewer] = @json_params.dig('pull_request', 'assignee', 'login')
    pull_request[:reviewer_image_url] = @json_params.dig('pull_request',
                                                         'assignee', 'avatar_url')

    pull_request[:state] = @json_params.dig('pull_request', 'state')
    pull_request[:title] = @json_params.dig('pull_request', 'title')
    pull_request[:url] = @json_params.dig('pull_request', 'html_url')

    pull_request[:repo] = @json_params.dig('repository', 'name')

    pull_request
  end

  def extract_review
    review = {}

    review[:state] = @json_params.dig('review', 'state')
    review[:github_id] = @json_params.dig('review', 'id')
    review[:submitted_at] = @json_params.dig('review', 'submitted_at')
    review[:body] = @json_params.dig('review', 'body')
    review[:url] = @json_params.dig('review', 'html_url')
    review[:author_github_id] = @json_params.dig('review', 'user', 'id')
    review[:author] = @json_params.dig('review', 'user', 'login')
    review[:author_image_url] = @json_params.dig('review', 'user', 'avatar_url')

    review
  end
end
