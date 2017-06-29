import React from 'react';
import PropTypes from 'prop-types';
import { css } from 'glamor';

import { PRIMARY, SECONDARY } from '../../design/palette';
import defaultImage from '../images/fsociety.png';

const EngineerCard = ({ avatar, login, role }) => (
  <div { ...styles.container }>
    <p { ...styles.role }>{ role }</p>

    <div { ...styles.imageContainer }>
      <img { ...styles.avatar } src={ avatar || defaultImage }/>

      <div { ...styles.overlay }>
      </div>
    </div>

    <p { ...styles.detail }>{ login }</p>
  </div>
);

EngineerCard.propTypes = {
  avatar: PropTypes.string,
  login: PropTypes.oneOfType([PropTypes.string, PropTypes.element]),
  role: PropTypes.string,
};

EngineerCard.defaultProps = {
  avatar: '',
  login: 'Unknown',
  role: '',
};

const styles = {
  avatar: css({
    borderRadius: '40px',
    border: `1px solid ${PRIMARY}`,
    height: '40px',
    width: '40px',
    ':hover': {
      opacity: 0.7,
    },
    '@media(max-width: 414px)': {
      height: '30px',
      width: '30px',
    },
  }),
  container: css({
    alignItems: 'center',
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'space-between',
    padding: '0 1em',
  }),
  detail: css({
    fontSize: '1vh',
    margin: '0.5em 0 0 0',
  }),
  imageContainer: css({
    position: 'relative',
  }),
  role: css({
    color: SECONDARY,
    fontWeight: 100,
    fontSize: '1vh',
    margin: 0,
    marginBottom: '0.5em',
    textAlign: 'center',
    width: '100%',
  }),
};

export default EngineerCard;
