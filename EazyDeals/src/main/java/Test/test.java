package Test;
import java.sql.Connection;
import com.eazydeals.helper.ConnectionProvider;
public class test {
	public static void main(String[] args) {
		Connection conn = ConnectionProvider.getConnection();
		System.out.println(conn);
	}
}
