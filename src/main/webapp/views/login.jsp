<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assignment App</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 0;
            padding: 0;
        }

        h1 {
            text-align: center;
            margin-top: 20px;
        }

        #loginForm {
            max-width: 300px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
        }

        label {
            display: block;
            margin-bottom: 10px;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 3px;
        }

        button[type="submit"]@CrossOrigin(origins = "*") {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }

        button[type="submit"]:hover {
            background-color: #0056b3;
        }

        #errorMessage {
            color: red;
            margin-top: 10px;
        }
    </style>
</head>
<body>
<h1>Login</h1>
<form id="loginForm">
    <label for="login_id">Email:</label>
    <input type="text" id="login_id" name="login_id" required><br>
    <label for="password">Password:</label>
    <input type="password" id="password" name="password" required><br>
    <button type="submit">Login</button>
</form>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        // Declare a variable to store the access token
        let accessToken = null;

        // Login Form
        const loginForm = document.getElementById("loginForm");
        const errorMessage = document.getElementById("errorMessage");

        loginForm.addEventListener("submit", function (e) {
            e.preventDefault();

            const login_id = document.getElementById("login_id").value;
            const password = document.getElementById("password").value;

            const authRequest = {
                login_id: login_id,
                password: password,
            };

            fetch("http://localhost:8080/api/authenticate", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify(authRequest),
            })
                .then((response) => {
                    if (response.ok) {
                        return response.json();
                    } else {
                        throw new Error("Authentication failed.");
                    }
                })
                .then((data) => {
                    // Store the access token
                    accessToken = data.access_token;

                    // Handle successful authentication
                    console.log("Authentication successful: " + accessToken);
                    sessionStorage.setItem("accessToken", accessToken);
                    // Redirect to dashboard.jsp
                    window.location.href = "dashboard";
                })
                .catch((error) => {
                    errorMessage.textContent = "Authentication failed. Please check your credentials.";
                });
        });

        // Add Customer Form
        const addCustomerForm = document.getElementById("addCustomerForm");

        addCustomerForm.addEventListener("submit", function (e) {
            e.preventDefault();

            const customer = {
                first_name: document.getElementById("first_name").value,
                last_name: document.getElementById("last_name").value,
                // Add other fields as needed
            };

            // Check if an access token is available
            if (!accessToken) {
                console.error("Access token is missing.");
                return;
            }

            fetch("/api/customers", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "Authorization": `Bearer ${accessToken}`, // Include the access token in the Authorization header
                },
                body: JSON.stringify(customer),
            })
                .then((response) => {
                    if (response.ok) {
                        console.log("Customer created successfully.");
                        // Update UI or display a success message
                    } else {
                        throw new Error("Customer creation failed.");
                    }
                })
                .catch((error) => {
                    console.error("Error creating customer: " + error.message);
                });
        });

        // You can similarly handle customer list retrieval, deletion, and updates here
    });
</script>
</body>
</html>
