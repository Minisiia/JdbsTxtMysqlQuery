package txt;

import java.io.BufferedReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.*;

/**
 *Используя дополнительное задания все запросы записать в текстовом файле с новой строки каждый
 *и используя потоки ввода-вывода считать с файла все запросы и выполнить.
 */

public class Main {
    private static final String URL = "jdbc:mysql://localhost:3306/myjoinsjdbcdbv2";
    private static final String LOGIN = "root";
    private static final String PASSWORD = "root";

    public static void main(String[] args) {
        registerDriver();

        Connection connection = null;
        PreparedStatement ps = null;

        Path path = Paths.get("mysql_queries.txt");
        try (BufferedReader br = Files.newBufferedReader(path, StandardCharsets.UTF_8)) {
            String s = "";
            int temp;
            for (; ; ) {
                temp = br.read();
                if (temp == -1) break;
                s += (char) temp;

                if (temp == ';') {
                    System.out.print("\nmysql query:");
                    System.out.println(s);
                    try {
                        connection = DriverManager.getConnection(URL, LOGIN, PASSWORD);
                        ps = connection.prepareStatement(s);
                        showResult(ps);
                    } catch (SQLException e) {
                        e.printStackTrace();
                    } finally {
                        try {
                            connection.close();
                            ps.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                    s = "";
                }
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void showResult(PreparedStatement ps) throws SQLException {
        ResultSet resultSet = ps.executeQuery();
        ResultSetMetaData md = resultSet.getMetaData();
        for (int i = 1; i <= md.getColumnCount(); i++)
            System.out.print(md.getColumnName(i) + "\t\t\t");
        System.out.println();
        while (resultSet.next()) {
            for (int j = 1; j <= md.getColumnCount(); j++) {
                System.out.print(resultSet.getString(j) + "\t\t");
            }
            System.out.println();
        }
    }

    private static void registerDriver() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Driver loading success!");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}