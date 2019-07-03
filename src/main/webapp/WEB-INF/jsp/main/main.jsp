<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Main</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>    
	<!-- Custom fonts for this template-->
	<link href="${contextPath}/resources/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
	
	<!-- Page level plugin CSS-->
	<link href="${contextPath}/resources/vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">
	
	<!-- Custom styles for this template-->
	<link href="${contextPath}/resources/css/sb-admin.css" rel="stylesheet">

	<style type="text/css">
	.pull-right {
		float: right!important;
	}
	
	.modal {
        text-align: center;
	}
	 
	@media screen and (min-width: 768px) { 
	        .modal:before {
	                display: inline-block;
	                vertical-align: middle;
	                content: " ";
	                height: 100%;
	        }
	}
	 
	.modal-dialog {
	        display: inline-block;
	        text-align: left;
	        vertical-align: middle;
	}

	.wrap {position: absolute;left: 0;bottom: 40px;width: 288px;height: 132px;margin-left: -144px;text-align: left;overflow: hidden;font-size: 12px;font-family: 'Malgun Gothic', dotum, '돋움', sans-serif;line-height: 1.5;}
    .wrap * {padding: 0;margin: 0;}
    .wrap .info {width: 286px;height: 120px;border-radius: 5px;border-bottom: 2px solid #ccc;border-right: 1px solid #ccc;overflow: hidden;background: #fff;}
    .wrap .info:nth-child(1) {border: 0;box-shadow: 0px 1px 2px #888;}
    .info .title {padding: 5px 0 0 10px;height: 30px;background: #eee;border-bottom: 1px solid #ddd;font-size: 18px;font-weight: bold;}
    .info .close {position: absolute;top: 10px;right: 10px;color: #888;width: 17px;height: 17px;background: url('http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/overlay_close.png');}
    .info .close:hover {cursor: pointer;}
    .info .body {position: relative;overflow: hidden;}
    .info .desc {position: relative;margin: 13px 0 0 13px;height: 75px;}
    .desc .ellipsis {overflow: hidden;text-overflow: ellipsis;white-space: nowrap;}
    .desc .jibun {font-size: 11px;color: #888;margin-top: -2px;}
    .info .img {position: absolute;top: 6px;left: 5px;width: 73px;height: 71px;border: 1px solid #ddd;color: #888;overflow: hidden;}
    .info:after {content: '';position: absolute;margin-left: -12px;left: 50%;bottom: 0;width: 22px;height: 12px;background: url('http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/vertex_white.png')}
    .info .link {color: #5085BB;}

	</style>

</head>

<body id="page-top">

  <nav class="navbar navbar-expand navbar-dark bg-dark static-top">

	<form id="searchForm" class="d-none d-md-inline-block form-inline ml-auto mr-0 mr-md-3 my-2 my-md-0">
      	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      	<input type="hidden" name="username" id="username" value="${pageContext.request.userPrincipal.name}">
      	<input type="hidden" name="currentPage" id="currentPage" value="1">
      	<input type="hidden" name="size" id="size" value="5">
      	<input type="hidden" name="pageYN" id="pageYN" value="N">
      <div class="input-group">
        <input type="text" class="form-control" placeholder="장소 검색" aria-label="Search" aria-describedby="basic-addon2" name="keyword" id="keyword" autocomplete="off">
        <input type="hidden" name="searchKeyword" id="searchKeyword">
        <div class="input-group-append">
          <button class="btn btn-primary" type="button" id="search">
            <i class="fas fa-search"></i>
          </button>
        </div>
      </div>
    </form>
    <div>
	    <form id="historyForm" class="d-none d-md-inline-block form-inline ml-auto mr-0 mr-md-3 my-2 my-md-0">
	      	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	      	<input type="hidden" name="username" id="username" value="${pageContext.request.userPrincipal.name}">
	      	<input type="hidden" name="historyCurrentPage" id="historyCurrentPage" value="1">
	      	<input type="hidden" name="historySize" id="historySize" value="5">
	    </form>
	</div>
	<ul class="navbar-nav ml-auto ml-md-0">
      <li class="nav-item dropdown no-arrow">
        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          <i class="fas fa-user-circle fa-fw"></i>
        </a>
        <div class="dropdown-menu dropdown-menu-right" aria-labelledby="userDropdown">
          <a class="dropdown-item" href="#">${pageContext.request.userPrincipal.name}</a>
          <div class="dropdown-divider"></div>
          <a class="dropdown-item" href="#" onclick="document.forms['logoutForm'].submit()">Logout</a>
        </div>
      </li>
    </ul>
	<div>
	<form id="logoutForm" method="POST" action="${contextPath}/logout">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	</form>
	</div>
  </nav>

  <div id="wrapper">

    <div id="content-wrapper">

      <div class="container-fluid">

        <div class="card mb-3">
          <div class="card-header"><b>장소 검색</b></div>
          <div class="card-body">
            <div class="table-responsive">
              <table class="table table-bordered" id="" width="100%" cellspacing="0">
                <thead>
                  <tr>                  	
                  	<th class="text-center">장소 명, 업체명</th>
                  	<th class="text-center">전화번호</th>
                    <th class="text-center">지번 주소</th>
                    <th class="text-center">도로명 주소</th>                                                
                  </tr>
                </thead>

                <tbody id="addressBody">
				                  
                </tbody>
              </table>
            </div>

			<div class="col-sm-12 col-md-7">
				<div class="dataTables_paginate paging_simple_numbers" id="dataTable_paginate">
					<ul class="pagination" id="paging">
					</ul>
				</div>
			</div>

          </div>
          <div class="card-footer small text-muted"></div>
        </div>
        
        <div class="card mb-3">
          <div class="card-header"><a id="refreshHistory" class="pull-right" href="javascript:void(0);"><span class="fas fa-sync"></span></a><b>내 검색 히스토리</b></div>
          <div class="card-body">
            <div class="table-responsive">
              <table class="table table-bordered" id="" width="100%" cellspacing="0">
                <thead>
                  <tr>
                    <th class="text-center">키워드</th>
                  	<th class="text-center">검색일시</th>
                  </tr>
                </thead>

                <tbody id="historyBody">
				                  
                </tbody>
              </table>
            </div>
            <div class="col-sm-12 col-md-7">
				<div class="dataTables_paginate paging_simple_numbers" id="dataTable_paginate">
					<ul class="pagination" id="historyPaging">
					</ul>
				</div>
			</div>
          </div>
          <div class="card-footer small text-muted"></div>
        </div>
        
        <div class="card mb-3">
          <div class="card-header inline"><a id="refreshHotKeyword" class="pull-right" href="javascript:void(0);"><span class="fas fa-sync"></span></a><b>인기 키워드 목록</b></div>
          <div class="card-body">
            <div class="table-responsive">
              <table class="table table-bordered" id="" width="100%" cellspacing="0">
                <thead>
                  <tr>
                    <th class="text-center">키워드</th>
                  	<th class="text-center">검색된 휫수</th>
                  </tr>
                </thead>

                <tbody id="hotKeywordBody">
				                  
                </tbody>
              </table>
            </div>
          </div>
          <div class="card-footer small text-muted"></div>
        </div>
        

      </div>
      <!-- /.container-fluid -->

    </div>
    <!-- /.content-wrapper -->

  </div>
  <!-- /#wrapper -->

  <!-- Scroll to Top Button-->
  <a class="scroll-to-top rounded" href="#page-top">
    <i class="fas fa-angle-up"></i>
  </a>

  <!-- Logout Modal-->
  <div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="exampleModalLabel">Ready to Leave?</h5>
          <button class="close" type="button" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">×</span>
          </button>
        </div>
        <div class="modal-body">Select "Logout" below if you are ready to end your current session.</div>
        <div class="modal-footer">
          <button class="btn btn-secondary" type="button" data-dismiss="modal">Cancel</button>
          <a class="btn btn-primary" href="login.html">Logout</a>
        </div>
      </div>
    </div>
  </div>

	<div class="modal fade" id="detailModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<!-- class를 주목하시면  여기 클레스에 modal-lg, modal-sm을 입력하시면 스몰 모달, 라지 모달로 선언이 가능 합니다. -->
	<!-- 위에 설명 예 : <div class="modal-dialog modal-sm" role="document"> -->
	  <div class="modal-dialog modal-lg" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	       <!-- 모달 이름 -->
	        <h5 class="modal-title font-weight-bold" id="exampleModalLabel">상세 정보</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body">
	        <!-- 모달 내용 -->
	        <div class="card" style="width: 48rem;">
<!-- 			  <div class="card-img-top" id="map"></div> -->
			  <div id="map" style="width:100%;height:350px;"></div>
			  <div class="card-body">
			    <H5 class="card-title font-weight-bold" id="placeName"></H5>
			    <p class="card-text" id="addressName"></p>
<!-- 			    <p class="card-text" id="addressName"></p>			     -->
			  </div>
			  <ul class="list-group list-group-flush">
			    <li class="list-group-item">
			    	<b>전화번호</b>
			    	<p class="card-text" id="phone"></p>
			    </li>
			    <li class="list-group-item">
			    	<b>카테고리</b>
			    	<p class="card-text" id="categoryName"></p>
			    </li>
			    <li class="list-group-item">
			    	<b>장소 ID</b>
			    	<p class="card-text" id="id"></p>
			    </li>
			    <li class="list-group-item">
			    	<b>장소 상세페이지 URL</b>
			    	<p class="card-text" id="placeUrl"></p>
			    </li>
			  </ul>
			  <div class="card-body">
			  	<a href="javascript:void(0);" class="btn btn-primary" id="shortCut" target="_blank">지도 바로가기</a>
			  </div>
			</div>
	        
	      </div>
	      <div class="modal-footer">
	        <!-- data-dismiss="modal"를 통해 모달을 닫을수 있다. -->
	        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
	      </div>
	    </div>
	  </div>
	</div>


  <!-- Bootstrap core JavaScript-->
  <script src="${contextPath}/resources/js/jquery-1.11.2.min.js"></script>
<%--   <script src="${contextPath}/resources/vendor/jquery/jquery.min.js"></script> --%>
  <script src="${contextPath}/resources/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

  <!-- Core plugin JavaScript-->
  <script src="${contextPath}/resources/vendor/jquery-easing/jquery.easing.min.js"></script>

  <!-- Page level plugin JavaScript-->
  <script src="${contextPath}/resources/vendor/datatables/jquery.dataTables.js"></script>
  <script src="${contextPath}/resources/vendor/datatables/dataTables.bootstrap4.js"></script>

  <!-- Custom scripts for all pages-->
  <script src="${contextPath}/resources/js/sb-admin.min.js"></script>
  
  <!-- pagination.js -->
  <script src="${contextPath}/resources/js/jquery.paging.js"></script>
  
  <!-- custom overlay -->
  <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=2a51acdd1f861fe186da9e5e98d7d562"></script>

	<script type="text/javascript">
	$(document).ready(function() {		
		
		getHistory();
		getHotKeyword();
		
		$("#keyword").keypress(function(event){
			if(event.which==13){
				$("#search").click();
				return false;
			}
		});
		
			
		$("#search").click(function() {
			
			if($("#keyword").val() == ""){
				alert('검색할 장소를 입력하세요.');
				return;
			}
			$("#searchKeyword").val($("#keyword").val());
			$("#pageYN").val('N');
			searchAddress();
		});
		
		$("#refreshHistory").click(function() {	
			$("#historyCurrentPage").val("1");
			getHistory();
		});
		
		$("#refreshHotKeyword").click(function() {		
			getHotKeyword();
		});
		
	});	
		
	function searchAddress(){
		
		$("#addressBody").html("")
		$("#paging").html("")
		
		$.ajax({    			
   			type: 'POST',
   			url : "/searchAddress",
   			data : $("#searchForm").serialize(),
   			dataType:"json",
   			success : function(data) {  
   				
   				if (data.code=="0000") {
   					
   					var list_length = data.addressList.length;    				    				
   					
   					if(list_length != 0){
    					for(i=0; i<list_length; i++){
    							    						
    						$("#addressBody").append("<tr>");
    						$("#addressBody").append("<form id='addressForm'>");
    						$("#addressBody").append("	<input type='hidden' id='id_"+data.addressList[i].id+"' value='"+data.addressList[i].id+"'>");
    						$("#addressBody").append("	<input type='hidden' id='place_name_"+data.addressList[i].id+"' value='"+data.addressList[i].place_name+"'>");
    						$("#addressBody").append("	<input type='hidden' id='category_name_"+data.addressList[i].id+"' value='"+data.addressList[i].category_name+"'>");
    						$("#addressBody").append("	<input type='hidden' id='phone_"+data.addressList[i].id+"' value='"+data.addressList[i].phone+"'>");
    						$("#addressBody").append("	<input type='hidden' id='address_name_"+data.addressList[i].id+"' value='"+data.addressList[i].address_name+"'>");
    						$("#addressBody").append("	<input type='hidden' id='road_address_name_"+data.addressList[i].id+"' value='"+data.addressList[i].road_address_name+"'>");
    						$("#addressBody").append("	<input type='hidden' id='place_url_"+data.addressList[i].id+"' value='"+data.addressList[i].place_url+"'>");
    						$("#addressBody").append("	<input type='hidden' id='x_"+data.addressList[i].id+"' value='"+data.addressList[i].x+"'>");
    						$("#addressBody").append("	<input type='hidden' id='y_"+data.addressList[i].id+"' value='"+data.addressList[i].y+"'>");
    						$("#addressBody").append("</form>");
    						$("#addressBody").append("<td class='text-center'><a href='javascript:void(0);' onclick='detailAddress("+data.addressList[i].id+");return false;'>"+data.addressList[i].place_name+"</td>");
    						$("#addressBody").append("<td class='text-center'>"+data.addressList[i].phone+"</td>");
    						$("#addressBody").append("<td class='text-center'>"+data.addressList[i].address_name+"</td>");
    						$("#addressBody").append("<td class='text-center'>"+data.addressList[i].road_address_name+"</td>");
    						$("#addressBody").append("</tr>");
    						
    					}
    					
    					$("#paging").paging({
    						current: data.currentPage, max: data.maxPage,
    						onclick:function(e, page){
    							$("#currentPage").val(page);
    							$("#pageYN").val('Y');
    							searchAddress();
    						}
    					});
    						    					
   					} else {
   						$("#addressBody").append("<tr>");
   						$("#addressBody").append("<td colspan='4' class='text-center'>조회된 정보가 없습니다.</td>");
   						$("#addressBody").append("</tr>");
   					}
   					$("#historyCurrentPage").val("1");
   					getHistory();
   					getHotKeyword();
   					
				} else {
					$("#addressBody").append("<tr>");
					$("#addressBody").append("<td colspan='4'>조회된 정보가 없습니다.</td>");
					$("#addressBody").append("</tr>");
				}
   			},
   			error : function(request, status, error){
   				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error); 				
   			}
   		});
	}
	
	function getHistory(){
		
		$("#historyBody").html("")
		$("#historyPaging").html("")
		
		$.ajax({    			
   			type: 'POST',
   			url : "/getHistory",
   			data : $("#historyForm").serialize(),
   			dataType:"json",
   			success : function(data) {  
   				
				var list_length = data.historyList.length;
   				
   				if (list_length!=0) {
   					    					
   					for(i=0; i<list_length; i++){

   						$("#historyBody").append("<tr>");
   						$("#historyBody").append("<td class='text-center'>"+data.historyList[i].keyword+"</td>");
   						$("#historyBody").append("<td class='text-center'>"+data.historyList[i].regdate+"</td>");
   						$("#historyBody").append("</tr>");
   					}
   					
   					$("#historyPaging").paging({
   						current: data.historyCurrentPage, max: data.historyMaxPage,
   						onclick:function(e, page){
   							$("#historyCurrentPage").val(page);
   							getHistory();
   						}
   					});
    					
  					} else {
  						$("#historyBody").append("<tr>");
  						$("#historyBody").append("<td colspan='2' class='text-center'>조회된 정보가 없습니다.</td>");
  						$("#historyBody").append("</tr>");
  					}
   			},
   			error : function(request, status, error){
   				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error); 				
   			}
   		});
	}
	
	function getHotKeyword(){
		
		$("#hotKeywordBody").html("");
		
		$.ajax({    			
   			type: 'POST',
   			url : "/getHotKeyword",
   			data : $("#searchForm").serialize(),
   			dataType:"json",
   			success : function(data) {      				    	
   				
   				var list_length = data.hotKeywordList.length;
   
   				if (list_length!=0) {
   					    					
   					for(i=0; i<list_length; i++){

   						$("#hotKeywordBody").append("<tr>");
   						$("#hotKeywordBody").append("<td class='text-center'>"+data.hotKeywordList[i].keyword+"</td>");
   						$("#hotKeywordBody").append("<td class='text-center'>"+data.hotKeywordList[i].count+"</td>");
   						$("#hotKeywordBody").append("</tr>");
   					}
    					
  					} else {
  						$("#hotKeywordBody").append("<tr>");
  						$("#hotKeywordBody").append("<td colspan='2' class='text-center'>조회된 정보가 없습니다.</td>");
  						$("#hotKeywordBody").append("</tr>");
  					}
   					
   			},
   			error : function(request, status, error){
   				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error); 				
   			}
   		});
	}


	
	function detailAddress(id){
		
		$("#placeName").html($("#place_name_"+id).val());
		$("#addressName").html($("#road_address_name_"+id).val()+"<br/>지번 | "+$("#address_name_"+id).val());
		$("#phone").html($("#phone_"+id).val());
		$("#categoryName").html($("#category_name_"+id).val());
		$("#placeUrl").html("<a href='"+$("#place_url_"+id).val()+"' target='_blank'>"+$("#place_url_"+id).val()+"</a>");
		$("#id").html($("#id_"+id).val());
		$("#shortCut").attr("href", "https://map.kakao.com/link/map/"+$("#id_"+id).val());
		
		$("#detailModal").modal("show");
		
		setTimeout(function(){
			makeOverlay($("#x_"+id).val(), $("#y_"+id).val(), $("#place_name_"+id).val(), $("#road_address_name_"+id).val(), $("#address_name_"+id).val());
		}, 500);
	}


	//custom overlay
	function makeOverlay(x, y, placeName, roadAddressName, adressName){
		//alert(x+"/"+y);
		var mapContainer = document.getElementById('map'), // 지도의 중심좌표	
	    mapOption = { 
	        center: new kakao.maps.LatLng(y, x), // 지도의 중심좌표
	        level: 3 // 지도의 확대 레벨
	    }; 
	
		var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
		
		// 지도에 마커를 표시합니다 
		var marker = new kakao.maps.Marker({
		    map: map, 
		    position: new kakao.maps.LatLng(y, x)
		});
		
		// 커스텀 오버레이에 표시할 컨텐츠 입니다
		// 커스텀 오버레이는 아래와 같이 사용자가 자유롭게 컨텐츠를 구성하고 이벤트를 제어할 수 있기 때문에
		// 별도의 이벤트 메소드를 제공하지 않습니다 
		var content = '<div class="wrap">' + 
		            '    <div class="info">' + 
		            '        <div class="title">' + 
		            placeName + 
		            '        </div>' + 
		            '        <div class="body">' + 
		            '            <div class="desc">' + 
		            '                <div class="ellipsis">'+roadAddressName+'</div>' + 
		            '                <div class="jibun ellipsis">(지번) '+adressName+'</div>' + 
		            '            </div>' + 
		            '        </div>' + 
		            '    </div>' +    
		            '</div>';
		
		// 마커 위에 커스텀오버레이를 표시합니다
		// 마커를 중심으로 커스텀 오버레이를 표시하기위해 CSS를 이용해 위치를 설정했습니다
		var overlay = new kakao.maps.CustomOverlay({
		    content: content,
		    map: map,
		    position: marker.getPosition()       
		});
		
		// 마커를 클릭했을 때 커스텀 오버레이를 표시합니다
		kakao.maps.event.addListener(marker, 'click', function() {
		    overlay.setMap(map);
		});
	
	}

	
	
	</script>

</body>

</html>
