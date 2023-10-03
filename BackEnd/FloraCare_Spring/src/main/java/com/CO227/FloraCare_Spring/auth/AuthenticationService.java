package com.CO227.FloraCare_Spring.auth;

import com.CO227.FloraCare_Spring.config.JwtService;
import com.CO227.FloraCare_Spring.token.Token;
import com.CO227.FloraCare_Spring.token.TokenRepository;
import com.CO227.FloraCare_Spring.token.TokenType;
import com.CO227.FloraCare_Spring.user.Role;
import com.CO227.FloraCare_Spring.user.User;
import com.CO227.FloraCare_Spring.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthenticationService {

    private final UserRepository repository;
    private final TokenRepository tokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;


    public AuthenticationResponse register(RegisterRequest request) {

        // Check if the email already exists in the repository
        if (repository.existsByEmail(request.getEmail())) {
            throw new EmailAlreadyTakenException("Email is already taken. Please try again.");
        }


        var user = User.builder()
                .userName(request.getUserName())
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .role(Role.USER)
                .build();
        var savedUser = repository.save(user);
        var jwtToken = jwtService.generateToken(user);
        saveUserToken(savedUser, jwtToken);

        AuthenticationResponse response = new AuthenticationResponse();
        response.setToken(jwtToken);
        response.setId(user.getId());

        return response;
    }


    public AuthenticationResponse authenticate(AuthenticationRequest request) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getEmail(),
                        request.getPassword()
                )
        );

        var user = repository.findByEmail(request.getEmail())
                .orElseThrow();
        var jwtToken = jwtService.generateToken(user);
        revokeAllUserTokens(user);
        saveUserToken(user, jwtToken);

        AuthenticationResponse response = new AuthenticationResponse();
        response.setToken(jwtToken);
        response.setId(user.getId());

        return response;
    }

    private void saveUserToken(User user, String jwtToken) {
        var token = Token.builder()
                .user(user)
                .token(jwtToken)
                .tokenType(TokenType.BEARER)
                .revoked(false)
                .expired(false)
                .build();
        tokenRepository.save(token);
    }

    private void revokeAllUserTokens(User user){
        var validUserTokens = tokenRepository.findAllValidTokensByUser(user.getId());
        if (validUserTokens.isEmpty())
            return;
        validUserTokens.forEach(t ->{
            t.setExpired(true);
            t.setRevoked(true);
        });
        tokenRepository.saveAll(validUserTokens);
    }
}
