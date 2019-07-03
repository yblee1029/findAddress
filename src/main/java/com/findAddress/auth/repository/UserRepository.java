package com.findAddress.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.findAddress.auth.model.User;

public interface UserRepository extends JpaRepository<User, Long> {
    User findByUsername(String username);
}
