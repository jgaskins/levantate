import camelize from 'camelize';

export default function PullRequestsChannel() {
  this.subscriptions = [];

  this.App || (this.App = {});

  if (!this.App.cable) {
    App.cable = ActionCable.createConsumer();
  }

  App.cable.subscriptions.create(
    'PullRequestsChannel',
    {
      connected: () => { console.log('connected to PR Channel'); },
      received: ({ body: json }) => {
        const pr = camelize(json);

        console.log(`Received: ${pr}`);

        this.subscriptions.forEach((cb) => cb(pr));
      },
    }
  );
}

PullRequestsChannel.prototype.subscribe = function (cb) {
  this.subscriptions.push(cb);
};
