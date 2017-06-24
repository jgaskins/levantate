import { camelcaseKeys } from './fetch-helpers';
import snakecaseKeys from 'snakecase-keys';
import queryString from 'qs';

const jsonHeaders = {
  'Accept': 'application/json',
  'Content-Type': 'application/json'
};

const parseJson = (response) => {
  if (!response.ok) {
    console.warn('error in request', response);
    return response.json().then((body) => {
      return Promise.reject({
        body,
        status: response.status,
        error: body.error,
      });
    });
  } else {
    return response
      .text()
      .then(body => body ? JSON.parse(body, camelcaseKeys) : '');
  }
};

export const jsonRequest = ({ uri, method, body, headers, credentials }) => {
  credentials = credentials || 'same-origin';
  headers = headers || jsonHeaders;

  return fetch(uri, {
    credentials,
    headers,
    method,
    body: (method === 'GET' || method === 'DELETE') ? undefined : JSON.stringify(body),
  }).then(parseJson);
};

export function getPullRequests() {
  return jsonRequest({ uri: `/pull_requests/active`, method: 'GET' });
}
