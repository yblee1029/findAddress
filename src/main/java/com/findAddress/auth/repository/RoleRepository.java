package com.findAddress.auth.repository;


import org.springframework.data.jpa.repository.JpaRepository;

import com.findAddress.auth.model.Role;

public interface RoleRepository extends JpaRepository<Role, Long>{
}
