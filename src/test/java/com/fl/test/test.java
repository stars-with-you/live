package com.fl.test;

import com.fl.common.ImgUtil;
import org.junit.Test;
import java.io.*;
public class test {
    @Test
    public void XX() throws Exception {
        //1280,1080,400
        ImgUtil imgUtil = new ImgUtil();
            String fromPic = "G:\\3333.jpg";
            String toPic = "G:\\1212.jpg";
           // imgUtil.ThumbnailsImgURL(baseSize, fromPic, toPic);

        traverseFolder2("G:\\图片\\");

    }
    public void traverseFolder2(String path) {
        ImgUtil imgUtil = new ImgUtil();
        int baseSize = 1280;
        File file = new File(path);
        if (file.exists()) {
            File[] files = file.listFiles();
            if (files.length == 0) {
                System.out.println("文件夹是空的!");
                return;
            } else {
                for (File file2 : files) {
                    if (file2.isDirectory()) {
                        System.out.println("文件夹:" + file2.getAbsolutePath());
                        traverseFolder2(file2.getAbsolutePath());
                    } else {
                        try {
                            String pstr=file2.getAbsolutePath();
                            String fname=pstr.substring(pstr.lastIndexOf("\\")+1);
                            if(fname.contains("_slt")){
                                if(file2.length()>1024*100){
                                    imgUtil.ThumbnailsImgURL(400, pstr, pstr);
                                }
                            }
                            else{
                                imgUtil.ThumbnailsImgURL(baseSize, pstr, pstr);
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
        } else {
            System.out.println("文件不存在!");
        }
    }
}
