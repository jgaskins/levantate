import React from 'react';
import PropTypes from 'prop-types';
import { css } from 'glamor';

import { PRIMARY } from '../../design/palette';
import defaultImage from '../images/fsociety.png';

const EngineerCard = ({ avatar, login, role }) => (
  <div { ...styles.container }>
    <p { ...styles.role }>{ role }</p>

    <img { ...styles.avatar } src={ avatar || defaultImage }/>

    <p { ...styles.detail }>{ login }</p>
  </div>
);

EngineerCard.propTypes = {
  avatar: PropTypes.string,
  login: PropTypes.string,
  role: PropTypes.string,
};

EngineerCard.defaultProps = {
  avatar: '',
  login: 'Unknown',
  role: '',
};

const styles = {
  avatar: css({
    borderRadius: '2.5em',
    border: `1px solid ${PRIMARY}`,
    height: '3em',
    width: '3em',
    '@media(max-width: 414px)': {
      height: '1.5em',
      width: '1.5em',
    },
  }),
  container: css({
    alignItems: 'center',
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'space-between',
    padding: '1em',
  }),
  detail: css({
    fontSize: '1em',
    margin: '1em 0',
  }),
  role: css({
    fontWeight: 100,
    fontSize: '1.1em',
    marginBottom: '0.5em',
    textAlign: 'center',
    width: '100%',
  }),
};

export default EngineerCard;
