package com.CO227.FloraCare_Spring.auth;


import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
//import com.CO227.FloraCare_Spring.auth.CustomErrorResponse;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(EmailAlreadyTakenException.class)
    public ResponseEntity<CustomErrorResponse> handleEmailAlreadyTakenException(EmailAlreadyTakenException ex) {
        CustomErrorResponse errorResponse = new CustomErrorResponse(HttpStatus.BAD_REQUEST.value(), ex.getMessage());
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errorResponse);
    }
}
