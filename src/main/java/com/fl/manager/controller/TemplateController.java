/*
  Created: 方磊
  Date: 2017年8月1日  上午9:24:34

*/
package com.fl.manager.controller;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fl.common.CommonHelp;
import com.fl.common.EncodeUtils;
import com.fl.model.AppFileInfo;

@RequestMapping(value = "/template")
@Controller
public class TemplateController {
	private static final String jspmaster = CommonHelp
			.getPropertyKey(CommonHelp.getProperty("config/config.properties"), "jsp.master");
	/*
	 * 浏览jsp内容
	 */
	@RequestMapping(value = "/readjsp")
	@ResponseBody
	public String ReadJsp(HttpServletRequest request) {
		FileInputStream fis = null;
		InputStreamReader Inputreader = null;
		BufferedReader br = null;
		try {
			String path = request.getParameter("path");
			String filename = EncodeUtils.urlDecode(path, "utf-8");
			fis = new FileInputStream(filename);
			Inputreader = new InputStreamReader(fis, "utf-8"); //
			br = new BufferedReader(Inputreader);

			String temp = br.readLine();
			StringBuffer data = new StringBuffer();
			while (temp != null) {
				data.append(temp).append("\n"); // 接着读下一行
				temp = br.readLine();
			}
			fis.close();
			Inputreader.close();
			br.close();
			String str = data.toString();
			return str;
		} catch (Exception e) {

		} finally {
			try {
				if (fis != null) {
					fis.close();
				}
				if (Inputreader != null) {
					Inputreader.close();
				}
				if (br != null) {
					br.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return "";

	}

	/**
	 * 动态修改jsp内容
	 * 
	 * @param request
	 */
	@RequestMapping(value = "/writejsp", produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String WriteJsp(HttpServletRequest request) {
		String string = request.getParameter("content").trim();
		String path = request.getParameter("path");
		path = EncodeUtils.urlDecode(path, "utf-8");
		FileOutputStream fop = null;
		File file;
		String content = string;
		try {
			file = new File(path);
			if (!file.exists() || !file.isFile()) {
				return "文件不存在";
			}
			fop = new FileOutputStream(file);
			// get the content in bytes
			byte[] contentInBytes = content.getBytes();

			fop.write(contentInBytes);
			fop.flush();
			fop.close();

			return "1";

		} catch (IOException e) {
			return e.getMessage().toString();
		} finally {
			try {
				if (fop != null) {
					fop.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

	}

	/*
	 * 读取jsp
	 */
	@RequestMapping(value = { "/list" })
	public ModelAndView GetList(HttpServletRequest request) {
		ModelAndView mView = new ModelAndView();
		mView.setViewName("/manager/list_source"+jspmaster);

		String path = request.getSession().getServletContext().getRealPath("/") + "WEB-INF/pages";
		path = EncodeUtils.urlEncode(path, "utf-8");
		mView.addObject("gml", path);
		return mView;
	}

	/*
	 * 读取日志
	 */
	@RequestMapping(value = { "/loglist" })
	public ModelAndView GetLogList(HttpServletRequest request) {
		ModelAndView mView = new ModelAndView();
		mView.setViewName("/template/list");
		String path = request.getSession().getServletContext().getRealPath("/") + "log";
		path = EncodeUtils.urlEncode(path, "utf-8");
		mView.addObject("gml", path);
		return mView;
	}

	/*
	 * 显示配置文件内容
	 */
	@RequestMapping(value = { "/xmllist" })
	public ModelAndView GetXmlList(HttpServletRequest request) {
		ModelAndView mView = new ModelAndView();
		mView.setViewName("/template/list");
		String path = request.getSession().getServletContext().getRealPath("/") + "WEB-INF/classes/config";
		path = EncodeUtils.urlEncode(path, "utf-8");
		mView.addObject("gml", path);
		return mView;
	}

	@RequestMapping(value = { "/data" })
	@ResponseBody
	public String GetData(String path) {
		path = EncodeUtils.urlDecode(path, "utf-8");
		List<AppFileInfo> list = CommonHelp.readfile(path);
        String json;
        try {

            json = "{\"code\": \"0\", \"msg\": \"\",\"count\": \"" + list.size() + "\",\"data\":"
                    + CommonHelp.ConvertToJson(list) + "}";
        } catch (Exception e) {
            json = "{\"code\": \"1\", \"msg\": \"\",\"count\":0,data:[]}";
        }
        return json;
	}

	/*
	 * 显示配置文件内容
	 */
	@RequestMapping(value = { "/getsysconfig" })
	public ModelAndView GetSysConfig(HttpServletRequest request) {
		ModelAndView mView = new ModelAndView();
		mView.setViewName("/template/sysconfig");
		Properties properties = null;
		properties = CommonHelp.getProperty("config/db.properties");
		Map<String, String> vString = CommonHelp.getPropertyMap(properties);
		mView.addObject("configlist", vString);
		return mView;
	}
}
