class PayloadParams
  attr_reader :action, :label, :number, :pull_request, :repository

  def initialize(params)
    @json_params = JSON.parse(params.require(:payload))

    @action ||= @json_params['action']
    @label ||= @json_params.dig('label', 'name')
    @number ||= @json_params['number']
    @repository ||= @json_params.dig('repository', 'name')

    @pull_request = {}

    @pull_request[:github_id] = @json_params.dig('pull_request', 'id')

    author = @json_params.dig('pull_request', 'user')
    assignee = @json_params.dig('pull_request', 'assignee')

    if author
      @pull_request[:author] = author.dig('login')
      @pull_request[:author_image_url] = author.dig('avatar_url')
    end

    if assignee
      @pull_request[:reviewer] = assignee.dig('login')
      @pull_request[:reviewer_image_url] = assignee.dig('avatar_url')
    end

    @pull_request[:state] = @json_params.dig('pull_request', 'state')
    @pull_request[:title] = @json_params.dig('pull_request', 'title')
    @pull_request[:url] = @json_params.dig('pull_request', 'html_url')
  end
end
