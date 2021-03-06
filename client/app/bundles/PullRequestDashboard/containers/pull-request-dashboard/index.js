import React, { Component } from 'react';
import moment from 'moment-timezone';

import View from './view';
import PullRequestsChannel from '../../channels/pull-requests';

import { getPullRequests } from '../../utils/api';

const mapPR = (pr) => ({
  ...pr,
  createdAt: moment(pr.createdAt),
  awaitingReviewSince: pr.awaitingReviewSince && moment(pr.awaitingReviewSince),
});

const mapPullRequests = (prs) => (
  prs.reduce((all, pr) => {
    all[pr.id] = mapPR(pr);
    return all;
  }, {})
);

class PullRequestDashboard extends Component {
  state = {
    error: false,
    loading: true,
    pullRequests: {},
  }

  componentWillMount() {
    getPullRequests()
      .then((data) => {
        const { pullRequests } = data;

        this.setState({
          loading: false,
          pullRequests: mapPullRequests(pullRequests),
        });
      }).catch(error => {

        this.setState({
          error: 'There was an error getting the Pull Requests.',
          loading: false,
        });
      });

    this.dataChannel = new PullRequestsChannel();
    this.dataChannel.subscribe(this.updatePR);
  }

  updatePR = (pr) => {
    const { pullRequests } = this.state;

    this.setState((nextState) => ({
      ...nextState,
      pullRequests: { ...nextState.pullRequests, [pr.id]: mapPR(pr) }
    }));
  }

  render() {
    const {
      error,
      loading,
      pullRequests,
    } = this.state;

    return (
      <View
        loading={ loading }
        pullRequests={ pullRequests }
      />
    );
  }
}

export default PullRequestDashboard;
