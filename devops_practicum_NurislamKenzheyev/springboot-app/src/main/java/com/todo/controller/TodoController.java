package com.todo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/tasks")
public class TodoController {

    @GetMapping
    public List<String> getTasks() {
        return List.of("Task1", "Task2", "Task3");
    }
}

