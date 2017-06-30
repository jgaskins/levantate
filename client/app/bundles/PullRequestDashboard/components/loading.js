import React from 'react';
import PropTypes from 'prop-types';
import { css } from 'glamor';
import ReactLoading from 'react-loading';

import {
  PRIMARY,
} from '../../design/palette';

const Loading = () => (
  <div { ...styles.container }>
    <ReactLoading
      color={ PRIMARY }
      height="55px"
      type="cylon"
      width="55px"
    />
  </div>
);

Loading.propTypes = {
};

Loading.defaultProps = {
};

const styles = {
  container: css({
    alignItems: 'center',
    display: 'flex',
    justifyContent: 'center',
    width: '100%',
  }),
};

export default Loading;
