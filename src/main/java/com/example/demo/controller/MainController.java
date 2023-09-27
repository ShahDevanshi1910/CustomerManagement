package com.example.demo.controller;

import ch.qos.logback.core.model.Model;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainController {


    @RequestMapping("/login")
    public String login(){
        return "login";
    }

    @RequestMapping("/dashboard")
    public String dashboard(){
        return "dashboard";
    }
}
