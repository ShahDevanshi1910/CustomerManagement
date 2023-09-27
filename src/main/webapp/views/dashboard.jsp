<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }

        h1 {
            margin-top: 20px;
        }

        h2 {
            margin-top: 20px;
        }

        form {
            max-width: 400px;
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
        }

        label {
            display: block;
            margin-bottom: 10px;
        }

        input[type="text"],
        input[type="email"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 3px;
        }

        button[type="submit"] {
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

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: left;
        }

        th {
            background-color: #007bff;
            color: #fff;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        tr:hover {
            background-color: #ddd;
        }
    </style>
</head>
<body>
<h1>Welcome to the Dashboard</h1>

<!-- Create a New Customer -->
<h2>Create a New Customer</h2>
<form id="createCustomerForm">
    <label for="new_first_name">First Name:</label>
    <input type="text" id="new_first_name" name="new_first_name" required>

    <label for="new_last_name">Last Name:</label>
    <input type="text" id="new_last_name" name="new_last_name" required>

    <label for="street">Street:</label>
    <input type="text" id="street" name="street" required>

    <label for="address">Address:</label>
    <input type="text" id="address" name="address" required>

    <label for="city">City:</label>
    <input type="text" id="city" name="city" required>

    <label for="state">State:</label>
    <input type="text" id="state" name="state" required>

    <label for="email">Email:</label>
    <input type="email" id="email" name="email" required>

    <label for="phone">Phone:</label>
    <input type="text" id="phone" name="phone" required>

    <button type="submit">Create Customer</button>
</form>

<!-- Customer List -->
<h2>Customer List</h2>
<table>
    <thead>
    <tr>
        <th>First Name</th>
        <th>Last Name</th>
        <th>Street</th>
        <th>Address</th>
        <th>City</th>
        <th>State</th>
        <th>Email</th>
        <th>Phone</th>
        <th>Action</th>
    </tr>
    </thead>
    <tbody id="customerList"></tbody>
</table>

<!-- Edit Customer -->
<h2>Edit Customer</h2>
<form id="editCustomerForm">
    <label for="edit_first_name">First Name:</label>
    <input type="text" id="edit_first_name" name="edit_first_name" required>

    <label for="edit_last_name">Last Name:</label>
    <input type="text" id="edit_last_name" name="edit_last_name" required>

    <label for="edit_street">Street:</label>
    <input type="text" id="edit_street" name="edit_street" required>

    <label for="edit_address">Address:</label>
    <input type="text" id="edit_address" name="edit_address" required>

    <label for="edit_city">City:</label>
    <input type="text" id="edit_city" name="edit_city" required>

    <label for="edit_state">State:</label>
    <input type="text" id="edit_state" name="edit_state" required>

    <label for="edit_email">Email:</label>
    <input type="email" id="edit_email" name="edit_email" required>

    <label for="edit_phone">Phone:</label>
    <input type="text" id="edit_phone" name="edit_phone" required>

    <!-- Hidden input field to store the customer ID -->
    <input type="hidden" id="edit_customer_id" name="edit_customer_id">

    <button type="submit">Edit Customer</button>
</form>




<script>
    let accesstoken = sessionStorage.getItem("accessToken");
    document.addEventListener("DOMContentLoaded", function () {

        console.log(accesstoken);
        retrieveCustomerList(accesstoken);

        // Create Customer Form


        const createCustomerForm = document.getElementById("createCustomerForm");

        createCustomerForm.addEventListener("submit", function (e) {
            e.preventDefault();

            const newCustomer = {
                first_name: document.getElementById("new_first_name").value,
                last_name: document.getElementById("new_last_name").value,
                street: document.getElementById("street").value,
                address: document.getElementById("address").value,
                city: document.getElementById("city").value,
                state: document.getElementById("state").value,
                email: document.getElementById("email").value,
                phone: document.getElementById("phone").value,
            };

            var myHeaders = new Headers();
            myHeaders.append("Authorization", "Bearer "+accesstoken);
            myHeaders.append("Content-Type", "application/json");

            var requestOptions = {
                method: 'POST',
                headers: myHeaders,
                body: JSON.stringify(newCustomer),
                redirect: 'follow'
            };

            fetch("http://localhost:8080/api/customers", requestOptions)
                .then(response => response.text())
                .then(result => {
                    console.log('Customer created:', result);
                    retrieveCustomerList(accesstoken);
                })
                .catch(error => {
                    console.error('Error creating customer: ', error);
                });
        });

        // Edit Customer Form
        const editCustomerForm = document.getElementById("editCustomerForm");

        editCustomerForm.addEventListener("submit", function (e) {
            e.preventDefault();

            const customerId = document.getElementById("edit_customer_id").value;
            console.log(customerId);
            const editedCustomer = {
                first_name: document.getElementById("edit_first_name").value,
                last_name: document.getElementById("edit_last_name").value,
                street: document.getElementById("edit_street").value,
                address: document.getElementById("edit_address").value,
                city: document.getElementById("edit_city").value,
                state: document.getElementById("edit_state").value,
                email: document.getElementById("edit_email").value,
                phone: document.getElementById("edit_phone").value,
            };

            var myHeaders = new Headers();
            myHeaders.append("Authorization", "Bearer "+accesstoken);
            myHeaders.append("Content-Type", "application/json");

            var requestOptions = {
                method: 'PUT',
                headers: myHeaders,
                body: JSON.stringify(editedCustomer),
                redirect: 'follow'
            };

            fetch("http://localhost:8080/api/customers/"+customerId, requestOptions)
                .then(response => response.text())
                .then(result => {
                    console.log('Customer updated:', result);
                    retrieveCustomerList(accesstoken);
                })
                .catch(error => {
                    console.error('Error updating customer: ', error);
                });
        });

        function retrieveCustomerList(accessToken) {
            var myHeaders = new Headers();
            console.log(accessToken);
            myHeaders.append("Authorization", "Bearer "+accessToken);

            var requestOptions = {
                method: 'GET',
                headers: myHeaders,
                redirect: 'follow'
            };

            fetch("http://localhost:8080/api/customers", requestOptions)
                .then(response =>{
                    console.log(response);
                    return response.json()})

                .then(data => {
                    const customerListTable = document.getElementById("customerListTable");
                    const customerList = document.getElementById("customerList");
                    customerList.innerHTML = "";

                    data.forEach(customer => {
                        const newRow = customerList.insertRow();
                        newRow.insertCell().textContent = customer.first_name;
                        newRow.insertCell().textContent = customer.last_name;
                        newRow.insertCell().textContent = customer.street;
                        newRow.insertCell().textContent = customer.address;
                        newRow.insertCell().textContent = customer.city;
                        newRow.insertCell().textContent = customer.state;
                        newRow.insertCell().textContent = customer.email;
                        newRow.insertCell().textContent = customer.phone;

                        const editCell = newRow.insertCell();
                        const editButton = document.createElement("button");
                        editButton.textContent = "Edit";
                        editButton.addEventListener("click", function () {
                            editCustomer(customer);
                        });
                        editCell.appendChild(editButton);



                        const editCelldelete = newRow.insertCell();
                        const editButtondelete = document.createElement("button");
                        editButtondelete.textContent = "Delete";
                        editButtondelete.addEventListener("click", function () {
                            console.log("DELETE Clicked");
                            deleteCustomer(customer,accessToken);
                        });
                        editCelldelete.appendChild(editButtondelete);
                    });

                    customerListTable.appendChild(customerList);
                })
                .catch(error => console.error('Error fetching customer list: ', error));
        }

        function editCustomer(customer) {
            document.getElementById("edit_first_name").value = customer.first_name;
            document.getElementById("edit_last_name").value = customer.last_name;
            document.getElementById("edit_street").value = customer.street;
            document.getElementById("edit_address").value = customer.address;
            document.getElementById("edit_city").value = customer.city;
            document.getElementById("edit_state").value = customer.state;
            document.getElementById("edit_email").value = customer.email;
            document.getElementById("edit_phone").value = customer.phone;
            document.getElementById("edit_customer_id").value = customer.uuid;
        }

        function deleteCustomer(customer, accessToken) {
            var myHeaders = new Headers();
            myHeaders.append("Authorization", "Bearer " + accessToken);

            var requestOptions = {
                method: 'DELETE',
                headers: myHeaders,
                redirect: 'follow'
            };

            fetch("http://localhost:8080/api/customers/" + customer.uuid, requestOptions)
                .then(response => {
                    console.log(response.statusText); // Log the response status message
                    retrieveCustomerList(accessToken);
                })
                .catch(error => {
                    console.error('Error deleting customer: ', error);
                });
        }
    });
</script>

</body>
</html>
