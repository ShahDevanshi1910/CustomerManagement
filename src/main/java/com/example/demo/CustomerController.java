package com.example.demo;
import com.google.gson.JsonObject;
import org.json.JSONObject;
import org.springframework.boot.json.JsonParser;
import org.springframework.http.*;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class CustomerController {



    private final String authApiUrl = "https://qa2.sunbasedata.com/sunbase/portal/api/assignment_auth.jsp";
    //private CustomerService customerService;

    // Authentication endpoint
    @PostMapping("/authenticate")
    public ResponseEntity<Map<String,String>> authenticate(@RequestBody AuthRequest authRequest) {
// Define the URL of the authentication API
        String authApiUrl = "https://qa2.sunbasedata.com/sunbase/portal/api/assignment_auth.jsp";

        // Create a RestTemplate to make the POST request
        RestTemplate restTemplate = new RestTemplate();

        // Create the request entity with headers and the request body
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<AuthRequest> requestEntity = new HttpEntity<>(authRequest, headers);

        // Send the POST request to the authentication API
        ResponseEntity<String> responseEntity = restTemplate.exchange(authApiUrl, HttpMethod.POST, requestEntity, String.class);
        Map<String,String> mymap = new HashMap<>();
        // Check if the authentication was successful (you may need to customize this based on the API response)
        if (responseEntity.getStatusCode() == HttpStatus.OK) {
            // Extract the bearer token from the response (you may need to parse the JSON response)
            String bearerToken = extractBearerTokenFromResponse(responseEntity.getBody());


            // Return the bearer token as a response
            mymap.put("access_token",bearerToken);
            return ResponseEntity.ok(mymap);
        } else {
            // Authentication failed, return an error response
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(mymap);
        }
    }

    private String extractBearerTokenFromResponse(String responseBody) {

        JSONObject jsonObject = new JSONObject(responseBody);
        String accessToken = jsonObject.getString("access_token");
        return accessToken;
    }


     //Create a new customer
    @PostMapping("/customers")
    public ResponseEntity<String> createCustomer(@RequestBody Customer customer,
                                            @RequestHeader("Authorization") String accessToken
    ) {
        // URL for the external API including the cmd parameter in the URL
        String apiUrl = "https://qa2.sunbasedata.com/sunbase/portal/api/assignment.jsp?cmd=create";

        // Create a RestTemplate instance
        RestTemplate restTemplate = new RestTemplate();

        // Set up request headers
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", accessToken); // Use the access_token from frontend
        headers.setContentType(MediaType.APPLICATION_JSON);

        // Create the request body
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("first_name", customer.getFirst_name());
        requestBody.put("last_name", customer.getLast_name());
        requestBody.put("street", customer.getStreet());
        requestBody.put("address", customer.getAddress());
        requestBody.put("city", customer.getCity());
        requestBody.put("state", customer.getState());
        requestBody.put("email", customer.getEmail());
        requestBody.put("phone", customer.getPhone());

        // Create the request entity with headers and body
        HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(requestBody, headers);

        try {
            // Send the POST request
            ResponseEntity<String> responseEntity = restTemplate.exchange(apiUrl, HttpMethod.POST, requestEntity,
                    String.class);

            // Check the response status and return the corresponding ResponseEntity
            if (responseEntity.getStatusCode().is2xxSuccessful()) {
                // Successfully Created
                return ResponseEntity.status(HttpStatus.OK).body(responseEntity.getBody().trim());
            } else {
                // Handle non-successful HTTP status codes (4xx, 5xx) here
                // You can log or throw an exception, as needed
                // For example, you can log the response body for debugging:
                String responseBody = responseEntity.getBody();
                System.out.println("API request failed with response body: {}"+responseBody);
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(responseBody);
            }
        } catch (HttpServerErrorException e) {
            // Handle HTTP 5xx errors
            String errorResponseBody = e.getResponseBodyAsString();
            System.out.println("API request failed with error response: {}" + errorResponseBody);

            // Handle the error gracefully, e.g., by providing a meaningful response or rethrowing a custom exception
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponseBody);
        } catch (RestClientException e) {
            // Handle other RestClientExceptions, e.g., network issues, connection timeouts
            System.out.println("API request failed with RestClientException: {}" + e.getMessage());

            // Handle the error gracefully, e.g., by providing a meaningful response or rethrowing a custom exception
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("API request failed due to a network issue.");
        }
    }
    //Get customer list
    @GetMapping("/customers")
    public ResponseEntity<List> getCustomerList(@RequestHeader("Authorization") String accessToken) {

        String apiUrl = "https://qa2.sunbasedata.com/sunbase/portal/api/assignment.jsp?cmd=get_customer_list";

        RestTemplate restTemplate = new RestTemplate();

        // Set up request headers
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", accessToken); // Use the access_token from frontend
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(headers);
        ResponseEntity<List> responseEntity = restTemplate.exchange(apiUrl, HttpMethod.GET, requestEntity,
                List.class);


        System.out.println(responseEntity);
        return ResponseEntity.ok().body(responseEntity.getBody());
    }
    // Delete a customer
    @DeleteMapping("/customers/{id}")
    public ResponseEntity<?> deleteCustomer(@PathVariable String id,@RequestHeader("Authorization") String accessToken) {
        String apiUrl = "https://qa2.sunbasedata.com/sunbase/portal/api/assignment.jsp?cmd=delete&uuid="+id;

        RestTemplate restTemplate = new RestTemplate();

        // Set up request headers
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", accessToken); // Use the access_token from frontend
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(headers);
        ResponseEntity<String> responseEntity = restTemplate.exchange(apiUrl, HttpMethod.POST, requestEntity,
                String.class);


        return ResponseEntity.ok().body(responseEntity.getBody().trim());
    }

    // Update a customer
    @PutMapping("/customers/{id}")
    public ResponseEntity<String> updateCustomer(@PathVariable String id, @RequestBody Customer customer,
                                            @RequestHeader("Authorization") String accessToken) {
        // Implement update customer logic
        // ...
        String apiUrl = "https://qa2.sunbasedata.com/sunbase/portal/api/assignment.jsp?cmd=update&uuid="+id;

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", accessToken); // Use the access_token from frontend
        headers.setContentType(MediaType.APPLICATION_JSON);


// Create the request body
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("first_name", customer.getFirst_name());
        requestBody.put("last_name", customer.getLast_name());
        requestBody.put("street", customer.getStreet());
        requestBody.put("address", customer.getAddress());
        requestBody.put("city", customer.getCity());
        requestBody.put("state", customer.getState());
        requestBody.put("email", customer.getEmail());
        requestBody.put("phone", customer.getPhone());

        // Create the request entity with headers and body
        HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(requestBody, headers);

        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> responseEntity = restTemplate.exchange(apiUrl, HttpMethod.POST, requestEntity,
                String.class);

        return ResponseEntity.status(HttpStatus.OK).body(responseEntity.getBody().trim());



    }
}
