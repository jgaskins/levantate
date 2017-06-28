import React from 'react';
import PropTypes from 'prop-types';
import { css } from 'glamor';

import Item from './item';

import {
  CONTENT_BACKGROUND,
  HEADER_BACKGROUND,
  PRIMARY_FONT_COLOR,
} from '../../../design/palette';

const List = ({ label, loading, pullRequests }) => {
  return (
    <div { ...styles.container }>
      <div { ...styles.titleContainer }>
        <p { ...styles.title }>{ label }</p>
      </div>

      {
        loading
          ? <div { ...styles.loading }>Loading...</div>
          : pullRequests.map((pr, i) => <Item key={ pr.id } pullRequest={ pr }/>)
      }
    </div>
  );
};

List.propTypes = {
  label: PropTypes.string,
  loading: PropTypes.bool,
  pullRequests: PropTypes.array,
};

List.defaultProps = {
  label: '',
  loading: false,
  pullRequests: [],
};

const styles = {
  container: css({
    backgroundColor: HEADER_BACKGROUND,
    borderRadius: 3,
    boxShadow: '1px 2px 4px 0px rgba(0, 0, 0, 0.10)',
    flexDirection: 'column',
    margin: 20,
  }),
  loading: css({
    alignItems: 'center',
    display: 'flex',
    height: '8em',
    justifyContent: 'center',
  }),
  title: css({
    margin: 0,
    textAlign: 'center',
    width: '100%',
  }),
  titleContainer: css({
    color: PRIMARY_FONT_COLOR,
    fontSize: '3vh',
    fontWeight: 100,
    padding: '1.5em',
  }),
};

export default List;
