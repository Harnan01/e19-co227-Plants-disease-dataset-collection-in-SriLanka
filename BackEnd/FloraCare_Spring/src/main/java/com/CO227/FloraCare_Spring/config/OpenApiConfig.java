package com.CO227.FloraCare_Spring.config;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeIn;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeType;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.security.SecurityScheme;
import io.swagger.v3.oas.annotations.servers.Server;

import java.util.Locale;

@OpenAPIDefinition(
        info = @Info(
                contact = @Contact(
                        name = "FloraCare",
                        email = "floracare@gmail.com"
                ),
                description = "Open Api Documentation for FloraCare Mobile Application RestApi",
                title = "Rest Api - FloraCare",
                version = "1.0"

        ),
        servers = {
                @Server(
                        description = "Localhost",
                        url = "http://localhost:8080"
                )
        }
)

public class OpenApiConfig {
}
