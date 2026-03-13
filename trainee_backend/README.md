# Trainee Backend Project

## Project Description
This is the backend service for the trainee project.  
It is built using **Node.js and Express** and provides API endpoints that the frontend can use.

## Technologies Used
- Node.js
- Express.js
- CORS

## Project Structure
trainee_backend/
│
├── server.js
├── package.json
└── README.md

## Installation

1. Navigate to backend directory

cd trainee_backend

2. Install dependencies

npm install

## Running the Server

Start the backend server:

node server.js

Server will run on:

http://localhost:3000

## API Endpoint

GET /api/message

Example response:

{
  "message": "Hello from the backend server!"
}

## Testing the API

You can test the API using:

Browser:
http://localhost:3000/api/message

or using curl:

curl http://localhost:3000/api/message