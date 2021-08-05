package post;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class PostDAO {
	
	private Connection conn;
	private ResultSet rs;
	
	//기본 생성자
	public PostDAO() {
		try {
			String dbURL = "jdbc:mariadb://localhost:3306/jspdb";
			String dbID = "root";
			String dbPassword = "coocon123!";
			Class.forName("org.mariadb.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		}catch (Exception e) {
			e.printStackTrace();
		}
	}

	//작성일자 메소드
	public String getDate() {
		String sql = "select now()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return ""; //데이터베이스 오류
	}
	
	//게시글 번호 부여 메소드
	public int getNext() {
		//현재 게시글을 내림차순으로 조회하여 가장 마지막 글의 번호를 구한다
		String sql = "select postID from POST order by postID desc";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1; //첫 번째 게시물인 경우
		}catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
	//글쓰기 메소드
	public int write(String title, String userID, String contents) {
		String sql = "insert into POST values(?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, title);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, contents);
			pstmt.setInt(6, 1); //글의 유효번호
			return pstmt.executeUpdate();
		}catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
	//게시글 리스트 메소드
	public ArrayList<Post> getList(int pageNumber){
		String sql = "select * from POST where postID < ? and available = 1 order by postID desc limit 10";
		ArrayList<Post> list = new ArrayList<Post>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Post post = new Post();
				post.setPostID(rs.getInt(1));
				post.setTitle(rs.getString(2));
				post.setUserID(rs.getString(3));
				post.setRegDate(rs.getString(4));
				post.setContents(rs.getString(5));
				post.setAvailable(rs.getInt(6));
				list.add(post);
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
		
	//페이징 처리 메소드
	public boolean nextPage(int pageNumber) {
		String sql = "select * from POST where postID < ? and Available = 1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return true;
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	//하나의 게시글을 보는 메소드
	public Post getPost(int postID) {
		String sql = "select * from POST where postID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				Post post = new Post();
				post.setPostID(rs.getInt(1));
				post.setTitle(rs.getString(2));
				post.setUserID(rs.getString(3));
				post.setRegDate(rs.getString(4));
				post.setContents(rs.getString(5));
				post.setAvailable(rs.getInt(6));
				return post;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	//게시글 수정 메소드
	public int update(int postID, String title, String contents) {
		String sql = "update POST set title = ?, contents = ? where postID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, title);
			pstmt.setString(2, contents);
			pstmt.setInt(3, postID);
			return pstmt.executeUpdate();
		}catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
	//게시글 삭제 메소드
	public int delete(int postID) {
		//실제 데이터를 삭제하는 것이 아니라 게시글 유효숫자를 '0'으로 수정한다
		String sql = "update POST set available = 0 where postID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postID);
			return pstmt.executeUpdate();
		}catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류 
	}
	
}
