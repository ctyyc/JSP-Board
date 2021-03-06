<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="post.PostDAO" %>
<%@ page import="post.Post" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- 화면 최적화 -->
<meta name="viewport" content="width-device-width", initial-scale="1">
<!-- 루트 폴더에 부트스트랩을 참조하는 링크 -->
<link rel="stylesheet" href="css/bootstrap.css">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		// 메인 페이지로 이동했을 때 세션에 값이 담겨있는지 체크
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
		}
		
		int pageNumber = 1; //기본은 1 페이지를 할당
		// 만약 파라미터로 넘어온 오브젝트 타입 'pageNumber'가 존재한다면
		// 'int'타입으로 캐스팅을 해주고 그 값을 'pageNumber'변수에 저장한다
		if(request.getParameter("pageNumber") != null){
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
	%>
	
	<!-- 네비게이션 -->
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
		        <span class="sr-only">Toggle navigation</span>
		        <span class="icon-bar"></span>
		        <span class="icon-bar"></span>
		        <span class="icon-bar"></span>
	      	</button>
			<a class="navbar-brand" href="board.jsp">JSP 게시판</a>
	  	</div>
	  	<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
  		<%
			// 로그인 하지 않았을 때 보여지는 화면
			if(userID == null){
		%>
			<ul class="nav navbar-nav navbar-right">
		        <li><a class="nav-link" href="login.jsp">로그인</a></li>
		        <li><a class="nav-link" href="join.jsp">회원가입</a></li>
	      	</ul>
		<%
			// 로그인이 되어 있는 상태에서 보여주는 화면
			}else{
		%>
			<!-- 헤더 우측에 나타나는 드랍다운 영역 -->
			<ul class="nav navbar-nav navbar-right">
		        <li><a class="nav-link" href="logoutAction.jsp">로그아웃</a></li>
	      	</ul>
		<%
			}
		%>
	  	</div>
	</nav>
	<!-- 네비게이션 영역 끝 -->
	
	<!-- 게시판 메인 페이지 영역 시작 -->
	<div class="container">
		<div class="row">
			<table class="table table-striped table-hover" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">번호</th>
						<th style="background-color: #eeeeee; text-align: center;">제목</th>
						<th style="background-color: #eeeeee; text-align: center;">작성자</th>
						<th style="background-color: #eeeeee; text-align: center;">작성일</th>
					</tr>
				</thead>
				<tbody>
					<%
						PostDAO postDAO = new PostDAO(); // 인스턴스 생성
						ArrayList<Post> list = postDAO.getList(pageNumber);
						for(int i = 0; i < list.size(); i++){
					%>
					<!-- 해당 글을 볼 수 있도록 링크를 걸어둔다 -->
					<tr onClick="location.href='post.jsp?postID=<%= list.get(i).getPostID() %>'">
						<td><%= list.get(i).getPostID() %></td>
						<td><%= list.get(i).getTitle() %></td>
						<td><%= list.get(i).getUserID() %></td>
						<td>
							<%= list.get(i).getRegDate().substring(0, 11) 
							+ list.get(i).getRegDate().substring(11, 13) + "시"
							+ list.get(i).getRegDate().substring(14, 16) + "분" %>
						</td>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>
			
			<!-- 페이징 처리 영역 -->
			<%
				if(pageNumber != 1) {
			%>
				<a href="board.jsp?pageNumber=<%=pageNumber - 1 %>" class="btn btn-success btn-arraw-left">이전</a>
			<%
				} if(postDAO.nextPage(pageNumber + 1)) {
			%>
				<a href="board.jsp?pageNumber=<%=pageNumber + 1 %>" class="btn btn-success btn-arraw-left">다음</a>
			<%
				}
			%>
			
			<!-- 글쓰기 버튼 생성 -->
			<%
				if(userID != null) {
			%>
				<a href="writePost.jsp" class="btn btn-primary pull-right">글쓰기</a>
			<%
				}
			%>
		</div>
	</div>
	<!-- 게시판 메인 페이지 영역 끝 -->
	
	<!-- 부트스트랩 참조 영역 -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>