import camelize from 'camelize';

export default function PullRequestsChannel() {
  this.subscriptions = [];

  App.cable.subscriptions.create(
    'PullRequestsChannel',
    {
      connected: () => {
        console.log('Connected to PullRequestsChannel. You\'ll receive live updates.');
      },
      disconnected: () => {
        console.log('Disconnected from PullRequestsChannel. Reload browser...');
      },
      received: ({ body: json }) => {
        const pr = camelize(json);

        this.subscriptions.forEach((cb) => cb(pr));
      },
    }
  );
}

PullRequestsChannel.prototype.subscribe = function (cb) {
  this.subscriptions.push(cb);
};
