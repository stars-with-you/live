/*
  Created: 方磊
  Date: 2017年7月27日  上午9:26:03

*/
package com.fl.news.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.fl.common.CommonHelp;

@Controller
@RequestMapping(value = "/newsupload")
public class NewsUploadController {

	private String getError(String errorMsg) throws JsonGenerationException, JsonMappingException, IOException {
		Map<String, Object> errorMap = new HashMap<String, Object>();
		errorMap.put("error", 1);
		errorMap.put("message", errorMsg);

		return CommonHelp.ConvertToJson(errorMap);
	}

	@RequestMapping(value = {
			"/uploadjson" }, method = RequestMethod.POST, produces = "application/json; charset=utf-8")
	@ResponseBody
	public String UploadJson(HttpServletRequest request)
			throws JsonGenerationException, JsonMappingException, IOException {
		// 文件保存目录路径

		String savePath = request.getSession().getServletContext().getRealPath("/") + "uploadfiles/";
		// 文件保存目录URL
		String saveUrl = request.getContextPath() + "/uploadfiles/";
		// 定义允许上传的文件扩展名
		HashMap<String, String> extMap = new HashMap<String, String>();
		extMap.put("image", "gif,jpg,jpeg,png,bmp");
		extMap.put("flash", "swf,flv");
		extMap.put("media", "swf,flv,mp3,wav,wma,wmv,mid,avi,mpg,asf,rm,rmvb");
		extMap.put("file",
				"doc,docx,xls,xlsx,ppt,htm,html,txt,zip,rar,gz,bz2,gif,jpg,jpeg,png,bmp,swf,flv,mp3,wav,wma,wmv,mid,avi,mpg,asf,rm,rmvb");
		// 最大文件大小
		long maxSize = 1024 * 1024 * 3;
		// 判断是否上传文件
		if (!ServletFileUpload.isMultipartContent(request)) {
			return getError("请选择文件。");
		}
		String dirName = request.getParameter("dir");
		if (dirName == null) {
			dirName = "image";
		}
		// 不允许上传exe等
		if (!extMap.containsKey(dirName)) {
			return getError("只允许上传image、flash、media、file四类文件。");
		}
		// 创建文件夹
		savePath += dirName + "/";
		saveUrl += dirName + "/";
		File saveDirFile = new File(savePath);
		if (!saveDirFile.exists()) {
			saveDirFile.mkdirs();
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String ymd = sdf.format(new Date());
		savePath += ymd + "/";
		saveUrl += ymd + "/";
		File dirFile = new File(savePath);
		if (!dirFile.exists()) {
			dirFile.mkdirs();
		}
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		Iterator itr = multipartRequest.getFileNames();
		while (itr.hasNext()) {
			String fileName = (String) itr.next();
			MultipartFile file = multipartRequest.getFile(fileName);
			// （1） 检查文件大小
			if (file.getSize() > maxSize) {
				return getError("上传文件大小超过限制。");
			}
			// （2）检查扩展名
			String fileExt = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf(".") + 1)
					.toLowerCase();
			if (!Arrays.<String>asList(extMap.get(dirName).split(",")).contains(fileExt)) {
				return getError("上传文件扩展名是不允许的扩展名。\n只允许" + extMap.get(dirName) + "格式。");
			}
			// （3）文件重命名
			SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmmss");
			String newFileName = df.format(new Date()) + "_" + new Random().nextInt(1000) + "." + fileExt;
			// 上传文件
			try {
				File uploadedFile = new File(savePath, newFileName);
				file.transferTo(uploadedFile);
			} catch (Exception e) {
				return getError("上传文件失败。");
			}

			Map<String, Object> succMap = new HashMap<String, Object>();
			succMap.put("error", 0);
			succMap.put("url", saveUrl + newFileName);
			succMap.put("oname", file.getOriginalFilename());
			return CommonHelp.ConvertToJson(succMap);
		}
		return null;
	}
}