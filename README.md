# Lev&aacute;ntate

## Purpose: 
This is an ancillary tool to help our engineering team optimize our collaboration
& pull request life cycle process. It uses GitHub webhooks to automatically
manage the life cycle of pull requests.

## To Run:
- Pull down this repo.
- Run `bundle && cd client && npm install` to download dependencies.
- Run `redis-server` to run the redis server.
- Run `npm run rails-server` to run our rails server.
- Go to `localhost:3000`.

## To add a repo webhook:
- Go into the settings page of your GitHub Repository.
- Go to the "Webhooks" tab in the left menu.
- Click "Add Webhook".
- Add the following "Payload URL":
   - `https://levantate.herokuapp.com/pull_requests/payload`
- Change the "Content type" to: 
   - `application/x-www-form-urlencoded`
- Copy `SECRET_TOKEN` from...
   - `.env` (in development)
   - the heroku project environment variables (in production)
  into the "Secret" field in GitHub Webhook form.

- Click the following events to send (at least):
  - "Pull request"
  - "Pull request review"
- Add the following labels to your GitHub repo (if not added already):
  - "needs reviewing"
  - "work in progress"

## How it works:
- When you create a Pull Request, it should automatically be added to the Pull 
Requests list and filtered into the `In Progress` section.
- When your Pull Request is ready for a review, add the "needs reviewing" label
and see your Pull Request automatically added to the `Review Ready` queue.
  - The `Review Ready` list is a FIFO queue so when looking for a Pull Request
    to review, grab the one on top.
- When you commit to being the reviewer for a Pull Request, assign it to 
yourself in GitHub. This will automatically add you as the reviewer and place
the Pull Request into the `In Review` list.
- If you decide to uncommit yourself as the reviewer, you will be taken off of 
the Pull Request and it will be added into the back of the `Review Ready` queue.
- When your Pull Request is closed, it will be archived and taken off the 
dashboard view.

## Details
- Ruby version: 2.3.3
- Puma Web Server

### Dependencies
- react_on_rails
- dotenv

## How to run the test suite
- Run `bundle exec rspec` in the root directory.

## Deployment instructions
- Precompile assets by running: `rails assets:precompile`
- Push up to GitHub: `git push`
