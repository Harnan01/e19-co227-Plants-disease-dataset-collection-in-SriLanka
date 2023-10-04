package com.CO227.FloraCare_Spring.config;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import java.security.Key;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@Service
public class JwtService {

    private static final String SECRET_KEY = "ds911dXcP875EPbzgbX0nMG/QGHjd4iIerlNsMWqEjCWAq0kmDAUgXIOAINRjqLHcKUa1F+wfp/8LKBGmGTVfq4iAH5TGr+9ji8kj1IYzE8bWRmed6RR4JVACzZw5sJ7GyfbVZphZv8darbZzaY0yufJcINxCOXiBJoJxHbD53HmE66YRE+iqBesXJ8V6XVrGujHHhiw8ojaVcXkn72Z/+R+UIkSugrmJjqy98WD451mkjmQ7U74h7JjW3DmQZnD/R89X8QXxkkdyevCSqyeGLBmxwebmN9RBhe+n6+8vbuk4lRYTHHt5XJqA8KfHC6NNsZDeaK4+LUox9wFySoPFTzQryJi1QY5iBVRLQnWhGtTItzSWuvBihEaZXCC0hlawTCPAPmxirGNT2V3UztA1TvokqukZDXEVkzk7j9QnnPaQmlDuWRLU0aFKQo+rxoo69i0zwCptK0Bx3paqobkip6JlxpNEaI8d8GAClSQLjgjxxyXQ5YkLANf8rIH5y1XWDM0T8/xVTQ8a+EqBVrShYdE5ji/POLH8Ahu3nC0rjGHbLXdex/mArwVTPCGhBmja+El6Agj4g5ZCajh+hBa6mxPrXi3dhV6L8S2HdJabWqBj0ArZRLbZ9b8GHU4zs9mNpeq7h4MJCvyGsyTb668lzcxMSHI1vDBh+73hpSC2f7vbTl3wQTj3LTHHoANaKuLl6mCJj3dU71IqAUaPn9hvIfILtuvyhD9kWuVQBOlspJfTfyBqYJrUErFrZpnD3Rlu6PuZe+Fk9TcfhSY5GSGVMVvStEIbUnW45LDui2OH2QDYqEkFgWTAHyhzFMcGSC0FiVMO5TZPB0usgMaBk8NdyNVMv+LWwlVSuC/RdbdOvPJ0KR2OTYf2sHoEO7Bs+xWFf5y6QJaTfW0+0opq79NPb3or+jPQUfrQzrb1pMszHO/LTb6fpsbDBgXVn6CWOttR1YaEG657aXvqpEDPfNPfqVD0Ik/7RfX8bKYXoMbQyck/w3EpJ63HgyD6UhNv1jXqDeJwU3PKRP7bMhmJaO/f8mHv0OxMspjqqdIvYUJ1R696r/2UHY9XYxQCQNh047qHdS9ik16/grOhvGnavWjFu/XbgIFNe3slDSmOI/udHUYITuG0g7Mq6WYG3zzvEwv3GFojbbUqKcHpJ1jLynFdyz7J65AeGtTvGIAijBFGLRcrpkQccIeQHtGzmdG7c5v2DCViwUqxuVD3QxqvKYNfncbD/ctGCtP1ydF3yVWrNdDTuzD2sSlvVhpLQKP/0GV+TPE/yVjKV4zJJef6cXBzmq4PA4LDg41C+9rTBDW7A73VBwVCiT/8d8TaQgNldBFoHTjjCbG1wnT9hV1XXQF3kZa7EdGDa6gw/KTQaDwgyI=";
    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    public String generateToken(UserDetails userDetails){
        return generateToken(new HashMap<>(), userDetails);
    }

    public String generateToken(
            Map<String, Object> extraClaims,
            UserDetails userDetails
    ){
        return Jwts
                .builder()
                .setClaims(extraClaims)
                .setSubject(userDetails.getUsername())
                .setIssuedAt(new Date(System.currentTimeMillis()))
                //.setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 24))
                .signWith(getSignInKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    public boolean isTokenValid(String token, UserDetails userDetails ){
        final String username = extractUsername(token);
        return (username.equals(userDetails.getUsername())) && !isTokenExpired(token);
    }

    private boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }

    private Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver){
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    private Claims extractAllClaims(String token){
        return Jwts
                .parserBuilder()
                .setSigningKey(getSignInKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    private Key getSignInKey() {
        byte[] keyBytes = Decoders.BASE64.decode(SECRET_KEY);
        return Keys.hmacShaKeyFor(keyBytes);
    }
}
