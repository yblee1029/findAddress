package com.findAddress.search.repository;

import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.findAddress.search.model.Search;

public interface SearchRepository extends JpaRepository<Search, Long> {
	
	List<Search> findByUsername(String username);
	
	@Query("SELECT count(s) as count FROM Search s WHERE s.username = :username")
	Object[] findByHistoryListCount(@Param("username") String username);
	
	@Query("SELECT s FROM Search s WHERE s.username = :username ORDER BY s.regdate DESC")
	List<Search> findByHistoryList(@Param("username") String username, Pageable limit);
	
	@Query("SELECT s.keyword as keyword, count(s) as count FROM Search s GROUP BY s.keyword ORDER BY count(s) DESC")
	List<Object[]> findByHotKeywordList(Pageable limit);
		
}
