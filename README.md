what is GitHub actions?
the GitHub actions is a platform to automate developer workflows
ci/cd is one of many workflows

what are those workflows?
"Workflows" mean the tasks or processes you do repeatedly, like building code, testing, or deploying.

what is GitHub events?
A GitHub event is something that happens in your GitHub repository that can trigger a workflow in GitHub Actions.
A GitHub event is an action or activity (like pushing code, creating a pull request, or opening an issue) that tells GitHub Actions “Start running the workflow now!”

ci/cd with GitHub actions:
=========================
what is ci/cd?
CI (Continuous Integration) → Automatically build and test your code whenever you make changes (like pushing to GitHub).
CD (Continuous Deployment/Delivery) → Automatically deploy your app after it passes all tests.
So, CI/CD = Build → Test → Deploy automatically.

GitHub Actions lets you automate this entire process using a workflow file written in YAML (.yml).

What Happens Here:
You push code to GitHub → event triggers.
GitHub runs the workflow:
Checks out code
Installs dependencies
Runs tests
Builds Docker image
Pushes it to registry (GitHub or Docker Hub)
All automatically 

first you go to the GitHub and create a public repository and add your project files to it.
Then click on the actions we will find all the standard workflows for deployment and integration as well
lets think we using node.js application then chose the node.js workflow 

let us understand the syntax of the workflow file :
this is the code:
name: Node.js CI/CD

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 18

      - name: Install dependencies
        run: npm install

      - name: Run tests
        run: npm test

      - name: Build project
        run: npm run build
lets break down it 
1. name
This gives your workflow a name (for display in the GitHub Actions tab).

name: CI/CD Pipeline

2. on
This defines the event that triggers the workflow.

on:
  push:
    branches:
      - main

3.jobs
A workflow is made up of one or more jobs.Each job runs on its own runner (a virtual machine).

jobs:
  build:
    runs-on: ubuntu-latest

build = job name
runs-on = type of virtual machine (runner)
Examples: ubuntu-latest, windows-latest, macos-latest

4. steps
Each job contains steps — the actual tasks to perform.
Each step can:
Use a prebuilt action
Or run custom shell commands

steps:
  - name: Checkout code
    uses: actions/checkout@v4

  - name: Set up Node.js
    uses: actions/setup-node@v4
    with:
      node-version: '18'

  - name: Install dependencies
    run: npm install

5. uses
uses means you are using a predefined GitHub Action made by others.
Examples:
actions/checkout@v4 → checks out your code
actions/setup-node@v4 → installs Node.js

6. run
run is used to execute your own shell commands inside the runner.
Example:
- name: Build app
  run: npm run build
You can even run multiple commands:
- name: Install & test
  run: |
    npm install
    npm test

7. env
You can define environment variables for use inside your workflow.

env:
  NODE_ENV: production
  AWS_REGION: us-east-1

8. secrets
For sensitive data (like passwords or tokens), use GitHub Secrets.

- name: Login to Docker Hub
  run: docker login -u ${{ secrets.DOCKER_USERNAME }} -p ${{ secrets.DOCKER_PASSWORD }}

You can store secrets in:
Repo Settings → Secrets and Variables → Actions

9. needs
If you have multiple jobs and one depends on another, use needs.

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Building"

  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - run: echo "Deploying"

The deploy job will only run after build finishes successfully.

10. if
You can add conditions to run a step only if something is true.

- name: Deploy to production
  if: github.ref == 'refs/heads/main'
  run: echo "Deploying to production"

Where Does GitHub Actions Code Run?

There are two types of runners:

1. GitHub-Hosted Runner :These are virtual machines provided by GitHub. You don’t have to set up anything — GitHub automatically creates, runs, and deletes them after the workflow finishes.
for every job you will get the new virtual machines
2. Self-Hosted Runner	: You can set up your own machine (your laptop, EC2 instance, etc.) to run the jobs instead of GitHub’s servers.

To create a docker image out of it:

	name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      # Step 7: Login to Docker Hub using secrets
      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_HUB_USERNAME }}
          password: ${{ secrets.DOCKER_HUB_TOKEN }}

      # Step 8: Build and Push Docker image to Docker Hub
      - name: Build and Push Docker Image
        uses: docker/build-push-action@v6
        with:
          context: .
          push: true
          tags: |
            ${{ secrets.DOCKER_HUB_USERNAME }}/nodejs-demo-app:latest
            ${{ secrets.DOCKER_HUB_USERNAME }}/nodejs-demo-app:${{ github.sha }}

Dockerfile (must be in your project root)

# Base image
FROM node:18
# Create app directory
WORKDIR /app
# Copy package files
COPY package*.json ./
# Install dependencies
RUN npm install
# Copy all files
COPY . .
# Expose the port your app runs on
EXPOSE 3000
# Command to run your app
CMD ["npm", "start"]










