package com.findAddress.search.service;

import java.net.URI;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.servlet.http.HttpServletRequest;
import javax.transaction.Transactional;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import com.findAddress.search.model.Search;
import com.findAddress.search.repository.SearchRepository;



@Service
@Transactional
public class SearchService {
	
	static Logger logger = LoggerFactory.getLogger(SearchService.class);
    
	@Autowired
	private SearchRepository searchRepository;
	
	@PersistenceContext
	private EntityManager entityManager;
	
	public List<Search> getSearchList(String username) {
		return searchRepository.findByUsername(username);
	}
	
	public String searchAddress(HttpServletRequest request) {

		JSONObject resultJson = new JSONObject(); 
		
		try {
		
			String keyword = request.getParameter("searchKeyword");
			String username = request.getParameter("username");
			int currentPage = Integer.parseInt((String) request.getParameter("currentPage"));
			int size = Integer.parseInt((String) request.getParameter("size"));
			String pageYN = request.getParameter("pageYN");
			
			if("N".equals(pageYN)) {
				Search search = new Search();
				search.setKeyword(keyword);
				search.setUsername(username);
				search.setRegdate(new Date());
				searchRepository.save(search);
			}
			logger.debug("pageYN : "+ pageYN);	
			logger.debug("keyword : "+ keyword);
			logger.debug("username : "+ username);
			logger.debug("currentPage : "+ currentPage);
			logger.debug("size : "+ size);
			
			
			MultiValueMap<String, Object> parameters = new LinkedMultiValueMap<String, Object>();
			parameters.add("query", keyword);
			parameters.add("page", currentPage);
			parameters.add("size", size);
			
			HttpHeaders headers = new HttpHeaders();
			headers.add("Accept", "application/json");
			headers.add("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");
			headers.add("Authorization", "KakaoAK b32794839eb536f94f5946a3da671f09");
			
			HttpEntity<MultiValueMap<String, Object>> req = new HttpEntity<MultiValueMap<String,Object>>(parameters, headers);
			
			RestTemplate restTemplate = new RestTemplate();
			String resResult = restTemplate.postForObject(new URI("https://dapi.kakao.com/v2/local/search/keyword.json"), req, String.class);
			logger.debug("응답결과: "+resResult);
			JSONObject jsonObject = (JSONObject) new JSONParser().parse(resResult);
			JSONArray documents = (JSONArray) jsonObject.get("documents");
			
			
			List<HashMap<String, Object>> list = new ArrayList<HashMap<String,Object>>();
			HashMap<String, Object> map;
			
			for(int i=0; i<documents.size(); i++) {
				JSONObject docObj = (JSONObject) documents.get(i);
				map = new HashMap<String, Object>();
				map.put("address_name", docObj.get("address_name"));
				map.put("category_group_code", docObj.get("category_group_code"));
				map.put("category_group_name", docObj.get("category_group_name"));
				map.put("category_name", docObj.get("category_name"));
				map.put("distance", docObj.get("distance"));
				map.put("id", docObj.get("id"));
				map.put("phone", docObj.get("phone"));
				map.put("place_name", docObj.get("place_name"));
				map.put("place_url", docObj.get("place_url"));
				map.put("road_address_name", docObj.get("road_address_name"));
				map.put("x", docObj.get("x"));
				map.put("y", docObj.get("y"));
				list.add(map);
			}
			logger.debug(list.toString());
			JSONObject metaInfo = (JSONObject) jsonObject.get("meta");
			int maxPage = 0;
			int pageableCount = 0;
			
			if(metaInfo!=null) {
				pageableCount = Math.round((Long) metaInfo.get("pageable_count"));
				int modCount = pageableCount%size;
				if(modCount>0) {
					maxPage = Math.round(pageableCount/size)+1;
				} else {
					maxPage = Math.round(pageableCount/size);
				}
			}
			resultJson.put("maxPage", maxPage);
			resultJson.put("currentPage", currentPage);
			resultJson.put("addressList", list);
			resultJson.put("code", "0000");
					
		} catch (Exception e) {
			logger.error("searchAddress error: {}", e.getMessage());
			e.printStackTrace();
			resultJson.put("code", "9999");
		}

		return resultJson.toString();
	}
	
	public String getHistory(HttpServletRequest request) {

		JSONObject resultJson = new JSONObject(); 
		
		SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		String username = request.getParameter("username");
		int currentPage = Integer.parseInt((String) request.getParameter("historyCurrentPage"));
		int size = Integer.parseInt((String) request.getParameter("historySize"));
				
		Object[] historyListCount = searchRepository.findByHistoryListCount(username);
		int maxCount = Math.round((Long) historyListCount[0]);
		
		logger.debug("username : "+ username);	
		logger.debug("currentPage : "+ currentPage);
		logger.debug("size : "+ size);
		logger.debug("maxCount: "+maxCount);
		
		int modCount = maxCount % size;
		int pageableCount = Math.round(maxCount);
		int maxPage = 0;
		if(modCount>0) {
			maxPage = Math.round(pageableCount/size)+1;
		} else {
			maxPage = Math.round(pageableCount/size);
		}
				
		logger.debug("maxPage: "+maxPage);
		int firstIndex = (currentPage-1)*size;
		logger.debug("firstIndex : "+ firstIndex);
		PageRequest limit = PageRequest.of(currentPage-1, size);
		List<Search> searchList = searchRepository.findByHistoryList(username, limit);
		List<HashMap<String, Object>> list = new ArrayList<HashMap<String,Object>>();
		HashMap<String, Object> map;
		for(int i=0; i<searchList.size(); i++) {
			Search search = searchList.get(i);
			map = new HashMap<String, Object>();
			map.put("keyword", search.getKeyword());
			map.put("regdate", dt.format(search.getRegdate()));
			list.add(map);
			logger.debug("map: "+map.toString());
		}
		resultJson.put("historyMaxPage", maxPage);
		resultJson.put("historyCurrentPage", currentPage);
		resultJson.put("historyList", list);
		return resultJson.toString();
	}
	
	public String getHotKeyword() {

		JSONObject resultJson = new JSONObject(); 
		PageRequest limit = PageRequest.of(0, 10);
		List<Object[]> searchList = searchRepository.findByHotKeywordList(limit);
		List<HashMap<String, Object>> list = new ArrayList<HashMap<String,Object>>();
		HashMap<String, Object> map;
		for(int i=0; i<searchList.size(); i++) {
			Object[] result = searchList.get(i);
			map = new HashMap<String, Object>();
			map.put("keyword", result[0]);
			map.put("count", result[1]);
			list.add(map);
		}
		resultJson.put("hotKeywordList", list);
		return resultJson.toString();
	}
}
