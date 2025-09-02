# PagerDuty Integration Application

This Rails application integrates with the PagerDuty API to list users and their contact methods.

## Prerequisites

- Ruby 3.3.0
- Rails 8.0.2
- Bundler

## Setup

1. Clone the repository:
```bash
git clone https://github.com/srikanthjeeva/pdassignment.git
cd pagerduty
```

2. Install dependencies:
```bash
bundle install
```

3. Configure your environment:
   - Copy the example configuration file:
   ```bash
   cp config/config.yml.example config/config.yml
   ```
   - Update `config.yml` with your PagerDuty API token and URL:
   ```yaml
   development:
     token: 'your-pagerduty-api-token'
     pager_duty_url: 'https://api.pagerduty.com'
   ```

4. **Generate or Add a Master Key**:
   Rails uses a master key to encrypt credentials. If you don't have a `config/master.key` file, you can generate one.
   ```bash
   # If config/master.key does not exist, this will create it.
   # If it does exist, it will open the credentials for editing.
   bundle exec rails credentials:edit
   ```
   This command will also open `config/credentials.yml.enc`, which is where you can store secrets. For this application, no additional secrets are needed in the credentials file, but the master key must exist.

## Running the Application

1. Start the Rails server:
```bash
rails server
```

2. Access the application:
   - Open your browser and navigate to `http://localhost:3000`
   - You should see the users listing page

## Testing

Run the test suite:
```bash
rails test
```

## To run using Docker

To run the application using Docker:

1. Build the image:
```bash
docker build -t pagerduty-app .
```

2. Run the container:
```bash
docker run -p 3001:3000 -e RAILS_MASTER_KEY=$RAILS_MASTER_KEY pagerduty-app
```

 