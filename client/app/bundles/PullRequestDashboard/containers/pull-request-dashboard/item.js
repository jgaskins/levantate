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

    if (upperCase) {
      upperCase.forEach((letter) => { abbr = abbr + letter; });
    }
  });

  return abbr.toUpperCase();
};

const handleClick = (url) => () => {
  const win = window.open(url, '_blank');
  win.focus();
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
  <span { ...styles.container } onClick={ handleClick(url) }>
    <div { ...styles.prContainer }>
      <p { ...styles.repo }>{ repo && getRepoAbbr(repo) }</p>

      <div { ...styles.prDetails }>
        <div { ...styles.title }>
          <p { ...styles.number }>{ number ? `#${number}` : '' }</p>
          <p { ...styles.titleText }>{ title }</p>
        </div>

        <div { ...styles.divider }/>
      </div>
    </div>

    <div { ...styles.usersContainer }>
      <EngineerCard
        avatar={ author && author.avatarUrl }
        login={ (author && author.login) || <em>No One</em> }
        role="Author"
      />

      <EngineerCard
        avatar={ reviewer && reviewer.avatarUrl }
        login={ (reviewer && reviewer.login) || <em>No One</em> }
        role="Reviewer"
      />
    </div>
  </span>
);

Item.propTypes = {
  pullRequest: PropTypes.object.isRequired,
};

const styles = {
  container: css({
    alignItems: 'center',
    backgroundColor: CONTENT_BACKGROUND,
    borderRadius: 3,
    color: PRIMARY_FONT_COLOR,
    cursor: 'pointer',
    display: 'flex',
    flexDirection: 'row',
    justifyContent: 'space-between',
    textDecoration: 'none',
    padding: '0.6em 0',
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
    display: 'inline-block',
    color: SECONDARY,
    margin: 0,
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
    fontSize: '2.5vh',
    fontWeight: 100,
    color: SECONDARY,
    margin: 'auto 1vw auto 0',
    padding: '0 2.5vw',
  }),
  title: css({
    fontSize: '1.5vh',
    fontWeight: 400,
  }),
  titleText: css({
    display: 'inline-block',
    fontWeight: 500,
    margin: '0 0 0 0.5em',
  }),
  usersContainer: css({
    display: 'flex',
  }),
};

export default Item;
