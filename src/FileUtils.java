import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public final class FileUtils {

    public static List<String> getAllFiles(String path) {
        List<String> files = getFiles(path);
        List<String> directories = getDirectories(path);
        Collections.sort(directories);
        for (String directory : directories) {
            files.addAll(getAllFiles(path + "/" + directory));
        }
        return files;
    }

    public static List<String> getFiles(String path) {
        File folder = new File(path);
        File[] listOfFiles = folder.listFiles();
        List<String> retList = new ArrayList<>();
        if (listOfFiles != null) {
            for (int i = 0; i < listOfFiles.length; i++) {
                if (listOfFiles[i].isFile()) {
                    retList.add(path + "/" + listOfFiles[i].getName());
                }
            }
        }

        return retList;
    }

    public static List<String> getDirectories(String path) {
        File folder = new File(path);
        File[] listOfFiles = folder.listFiles();
        List<String> retList = new ArrayList<>();
        if (listOfFiles != null) {
            for (int i = 0; i < listOfFiles.length; i++) {
                if (listOfFiles[i].isDirectory()) {
                    retList.add(listOfFiles[i].getName());
                }
            }
        }
        return retList;
    }
}
