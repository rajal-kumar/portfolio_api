# 🚀 Rails API Starter

A lightweight, RESTful Rails API built with Ruby on Rails, designed to be used as a backend for web or mobile applications.

## 📦 Features

- Ruby on Rails API mode (no views, no frontend)
- RESTful JSON endpoints
- CORS enabled
- PostgreSQL (or your preferred DB)
- RSpec / Minitest setup (depending on your test preference)
- Environment-based configurations
- Token-based authentication (optional, if included)

## 🛠️ Setup Instructions

### Prerequisites

- Ruby (version 3.4.4)
- Rails (version 8.0.2)
- PostgreSQL or SQLite (update accordingly)
- Node.js and Yarn (for managing frontend dependencies, if needed)

### Getting Started

```bash
# Clone the repo
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name

# Install dependencies
bundle install

# Setup database
rails db:create db:migrate

# Run the server
rails s
