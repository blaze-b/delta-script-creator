import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.List;

import static java.lang.System.in;

/**
 * AUTHOR: brianblaze14
 * Delta class for creating the DELTA Scripts for
 * automating the Execution of the large number of the
 * DML and the DDL Scripts in the corresponding RDBC environments
 */
public class Delta {

    private static final String FILE_EXTENSION = "sql";
    private static final String DRIVER_SQL = "driver.sql";
    private static final String NEWLINE = "\r\n";

    public static void main(String[] args) {
        String path = null;
        String schema = null;
        if (args.length > 0) {
            path = args[0];
        }
        if (args.length > 1) {
            schema = args[1];
        }
        BufferedReader br = new BufferedReader(new InputStreamReader(in));
        try {
            if (path == null) {
                System.out.println("Enter path: ");
                path = br.readLine();
            }
            if (schema == null) {
                System.out.println("Enter schema: ");
                schema = br.readLine();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        List<String> files = FileUtils.getAllFiles(path);
        //System.out.println("Files details from the path = " + files);
        StringBuilder driverFileContent = new StringBuilder("" + NEWLINE
                + "spool  ICODBUPDATE_.log" + NEWLINE
                + "SET SQLBLANKLINES ON;" + NEWLINE
                + "SET DEFINE OFF;" + NEWLINE
                + "SET SQLPREFIX OFF;" + NEWLINE);
        for (String filename : files) {
            int i = filename.lastIndexOf('.');
            if (i > 0) {
                String extension = filename.substring(i + 1);
                if (!FILE_EXTENSION.equalsIgnoreCase(extension))
                    continue;
                filename = filename.replace(path + "/", "");
                if (DRIVER_SQL.equals(filename))
                    continue;
                driverFileContent.append(NEWLINE).append("prompt ****************Applying ")
                        .append(filename).append(" start************************")
                        .append(NEWLINE).append("@").append(filename).append(NEWLINE)
                        .append("prompt ****************Applying ").append(filename)
                        .append(" end************************");
            }
        }
        driverFileContent.append(NEWLINE).append("EXEC DBMS_UTILITY.compile_schema(schema => '").append(schema).append("');")
                .append(NEWLINE).append("Prompt Invalid database objects")
                .append(NEWLINE).append("set lines 300;")
                .append(NEWLINE).append("column object_name format a30;")
                .append(NEWLINE).append("select object_name, object_type from user_objects where status='INVALID';")
                .append(NEWLINE).append("SET SQLBLANKLINES OFF;")
                .append(NEWLINE).append("spool off;");
        try {
            PrintWriter writer = new PrintWriter(path + "/driver.sql", "UTF-8");
            writer.print(driverFileContent);
            writer.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


}
