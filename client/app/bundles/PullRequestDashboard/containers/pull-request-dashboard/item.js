import React from 'react';
import PropTypes from 'prop-types';
import { css } from 'glamor';

import {
  CONTENT_BACKGROUND,
  HIGHLIGHTED_BACKGROUND,
  PRIMARY,
  PRIMARY_FONT_COLOR,
  SECONDARY,
} from '../../../design/palette';

import EngineerCard from '../../components/engineer-card';

const getRepoAbbr = (repo) => {
  if (repo.length <= 3) { return repo.toUpperCase(); }

  let abbr = '';

  repo.split('-').forEach((word) => {
    abbr = abbr + word[0];
    const upperCase = word.slice(1).match(/([A-Z]+)/g);

    if (upperCase) { upperCase.forEach((letter) => { abbr = abbr + letter; }); }
  });

  return abbr.toUpperCase();
};

const Item = ({
  pullRequest: {
    author,
    awaitingReviewSince,
    number,
    repo,
    reviewer,
    state,
    title,
    url,
  },
}) => (
  <a { ...styles.container } href={ url }>
    <div { ...styles.prContainer }>
      <p { ...styles.repo }>{ repo && getRepoAbbr(repo) }</p>

      <div { ...styles.prDetails }>
        <p { ...styles.title }>
          <span { ...styles.number }>{ number ? `#${number}` : '' }</span>
          <span { ...styles.titleText }>{ title }</span>
        </p>

        <div { ...styles.divider }/>
      </div>
    </div>

    <div { ...styles.usersContainer }>
      <EngineerCard
        avatar={ author && author.avatarUrl }
        login={ (author && author.login) || <em>No Reviewer Yet.</em> }
        role="Author"
      />

      <EngineerCard
        avatar={ reviewer && reviewer.avatarUrl }
        login={ (reviewer && reviewer.login) || <em>No Reviewer Yet.</em> }
        role="Reviewer"
      />
    </div>
  </a>
);

Item.propTypes = {
  pullRequest: PropTypes.object.isRequired,
};

const styles = {
  container: css({
    alignItems: 'center',
    backgroundColor: CONTENT_BACKGROUND,
    color: PRIMARY_FONT_COLOR,
    cursor: 'pointer',
    display: 'flex',
    flexDirection: 'row',
    justifyContent: 'space-between',
    textDecoration: 'none',
    padding: '1em 1em 1em 0',
    ':hover': {
      backgroundColor: HIGHLIGHTED_BACKGROUND,
    },
  }),
  divider: css({
    borderBottom: `1px solid ${PRIMARY}`,
    margin: '0.25em 0',
    width: '100%',
  }),
  number: css({
    color: SECONDARY,
  }),
  prContainer: css({
    display: 'flex',
    justifyContent: 'flex-start',
  }),
  prDetails: css({
    alignItems: 'stretch',
    display: 'flex',
    flexDirection: 'column',
    marginRight: '2.5em',
    justifyContent: 'center',
  }),
  repo: css({
    color: SECONDARY,
    fontSize: '1.5em',
    fontWeight: 100,
    color: SECONDARY,
    margin: '0 1em 0 0',
    padding: '2em',
  }),
  title: css({
    fontSize: '1.1em',
    fontWeight: 400,
  }),
  titleText: css({
    fontWeight: 500,
    margin: '0 0 0 0.5em',
  }),
  usersContainer: css({
    display: 'flex',
  }),
};

export default Item;
