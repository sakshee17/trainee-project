# Trainee Frontend Project

## Project Description
This is the frontend application for the trainee project.  
It is a simple HTML and JavaScript application that communicates with the backend API.

## Technologies Used
- HTML
- JavaScript
- Fetch API

## Project Structure
trainee_frontend/
│
├── index.html
├── script.js
└── README.md

## Running the Frontend

1. Navigate to frontend directory

cd trainee_frontend

2. Open the application

Open index.html in your web browser.

## Features

- Simple UI
- Button to call backend API
- Displays message returned from backend server

## Testing the Application

1. Make sure backend server is running:

node server.js

2. Open frontend in browser

3. Click **Get Backend Message**

The frontend will call:

http://localhost:3000/api/message

and display the response on the page.