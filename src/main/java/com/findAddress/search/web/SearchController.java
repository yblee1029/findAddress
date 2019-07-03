package com.findAddress.search.web;


import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.findAddress.search.service.SearchService;

@Controller
public class SearchController {
	
    @Autowired
    private SearchService searchService;

    @RequestMapping(value="/searchAddress", produces="text/json; charset=utf-8", method=RequestMethod.POST)
    @ResponseBody
    public String searchAddress(HttpServletRequest request) {
        return searchService.searchAddress(request);
    }
    
    @RequestMapping(value="/getHistory", produces="text/json; charset=utf-8", method=RequestMethod.POST)
    @ResponseBody
    public String getHistory(HttpServletRequest request) {
    	return searchService.getHistory(request);
    }
    
    @RequestMapping(value="/getHotKeyword", produces="text/json; charset=utf-8", method=RequestMethod.POST)
    @ResponseBody
    public String getHotKeyword() {
    	return searchService.getHotKeyword();
    }
}
