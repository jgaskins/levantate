import camelcase from 'lodash.camelcase';

const isPost = (method) => method === 'POST';
const isPut = (method) => method === 'PUT';

export function camelcaseKeys(key, value) {
  if (/[_A-Z]/.test(key) && this.hasOwnProperty(key)) {
    const k = camelcase(key);

    if(k === key) {
      return value;
    } else {
      this[k] = value;
    }
  } else {
    return value;
  }
}

export function parseJson (response, reviver = camelcaseKeys) {
  return response
    .text()
    .then(body => body ? JSON.parse(body, reviver) : {});
}

export function isOk(response) {
  if (!response.ok) {
    return Promise.reject({ error: 'Response was not ok', response: response });
  }

  return response;
}

export function fetchJson({ uri, method = 'GET', body, headers, credentials }) {
  credentials = credentials || 'same-origin';
  headers = headers || {
    'Accept': 'application/json',
    'Content-Type': 'application/json'
  };

  return fetch(uri, {
    credentials,
    headers,
    method,
    body: (isPost(method) || isPut(method) ? JSON.stringify(body) : undefined),
  }).then(isOk).then(parseJson);
}

