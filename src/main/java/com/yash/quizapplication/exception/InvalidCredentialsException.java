package com.yash.quizapplication.exception;

import jdk.nashorn.internal.runtime.Version;

public class InvalidCredentialsException extends Exception{

    public InvalidCredentialsException(String message) {
        super(message);
    }
}
