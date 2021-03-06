import React from 'react';
import PropTypes from 'prop-types';
import { css } from 'glamor';

import List from './list';

const filter = (pullRequests, { state }) => (
  Object
    .values(pullRequests)
    .filter((pullRequest) => pullRequest.state === state)
    .sort((a, b) => (
      state === 'review_ready'
        ? a.awaitingReviewSince - b.awaitingReviewSince
        : a.createdAt - b.createdAt
    ))
);

const View = ({ loading, pullRequests }) => {
  return (
    <div { ...styles.container }>
      <List
        label="Needs Reviewing"
        loading={ loading }
        pullRequests={ filter(pullRequests, { state: 'review_ready' }) }
      />

      <List
        label="Approved"
        loading={ loading }
        pullRequests={ filter(pullRequests, { state: 'merge_ready' }) }
      />

      <List
        label="Currently In Review"
        loading={ loading }
        pullRequests={ filter(pullRequests, { state: 'in_review' }) }
      />

      <List
        label="Work in Progress"
        loading={ loading }
        pullRequests={ filter(pullRequests, { state: 'in_progress' }) }
      />
    </div>
  );
};

View.propTypes = {
};

View.defaultProps = {
};

const styles = {
  container: css({
    fontFamily: 'Roboto',
    margin: 0,
  }),
};

export default View;
