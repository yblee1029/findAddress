package com.findAddress;

import java.util.HashSet;
import java.util.Optional;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.test.context.junit4.SpringRunner;

import com.findAddress.auth.model.User;
import com.findAddress.auth.repository.RoleRepository;
import com.findAddress.auth.repository.UserRepository;

@RunWith(SpringRunner.class)
@SpringBootTest
public class FindAddressApplicationTests {
	static Logger logger = LoggerFactory.getLogger(FindAddressApplicationTests.class);
	
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private RoleRepository roleRepository;
    @Autowired
    private BCryptPasswordEncoder bCryptPasswordEncoder;
    
	@Test
	public void insertTest() {
		for(int i=0; i<100; i++) {
			User user = new User();
			user.setUsername("username" + i);
			user.setPassword(bCryptPasswordEncoder.encode("passwordTest" + i));
			user.setRoles(new HashSet<>(roleRepository.findAll()));
			userRepository.save(user);
		}
	}
	
	@Test
	public void testUser() {
		Optional<Optional<User>> result = Optional.ofNullable(userRepository.findById(85L));
		result.ifPresent(user -> logger.info("@@@@@@@@ user: ", user));
	}
}
