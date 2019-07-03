package com.findAddress.auth.service;

import com.findAddress.auth.model.User;

public interface UserService {
    void save(User user);

    User findByUsername(String username);
}
