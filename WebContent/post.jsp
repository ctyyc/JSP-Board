<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="post.Post" %>
<%@ page import="post.PostDAO" %>
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
		
		// postID를 초기화 시키고
		// 'postID'라는 데이터가 넘어온 것이 존재한다면 캐스팅을 하여 변수에 담는다
		int postID = 0;
		if(request.getParameter("postID") != null){
			postID = Integer.parseInt(request.getParameter("postID"));
		}
		
		// 만약 넘어온 데이터가 없다면
		if(postID == 0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다')");
			script.println("location.href='board.jsp'");
			script.println("</script");
		}
		
		// 유효한 글이라면 구체적인 정보를 'post'라는 인스턴스에 담는다
		Post post = new PostDAO().getPost(postID);
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
	
	<!-- 게시판 글 보기 양식 영역 시작 -->
	<div class="container">
		<div class="row">
			<table class="table table-striped table-bordered" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글 보기</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 20%;">글 제목</td>
						<td colspan="2">
							<%= post.getTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %>
						</td>
					</tr>
					<tr>
						<td>작성자</td>
						<td colspan="2"><%= post.getUserID() %></td>
					</tr>
					<tr>
						<td>작성일자</td>
						<td colspan="2">
							<%= post.getRegDate().substring(0, 11)
								+ post.getRegDate().substring(11, 13) + "시"
								+ post.getRegDate().substring(14, 16) + "분" %>
						</td>
					</tr>
					<tr>
						<td>내용</td>
						<td colspan="2" style="height: 200px; text-align: left;">
							<%= post.getContents().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %>
						</td>
					</tr>
				</tbody>
			</table>
			<a href="board.jsp" class="btn btn-primary">목록</a>
			
			<!-- 해당 글의 작성자가 본인이라면 수정과 삭제가 가능하도록 코드 추가 -->
			<%
				if(userID != null && userID.equals(post.getUserID())){
			%>
					<a href="updatePost.jsp?postID=<%= postID %>" class="btn btn-primary">수정</a>
					<a href="deletePostAction.jsp?postID=<%= postID %>" class="btn btn-primary">삭제</a>
			<%
				}
			%>
		</div>
	</div>
	<!-- 게시판 글 보기 양식 영역 끝 -->
	
	<!-- 부트스트랩 참조 영역 -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>