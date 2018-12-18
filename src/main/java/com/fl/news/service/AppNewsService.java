/*
  Created: 方磊
  Date: 2018年3月28日  下午1:52:14

*/
package com.fl.news.service;

import com.fl.model.AppNewsinfo;

public interface AppNewsService {
	/*
	 * 获取分页数据json格式
	 */
	public String getData(int currentPage, int pagesize, AppNewsinfo model);

	public String Add(AppNewsinfo model);

	public String DelByNid(String nid);

	public String GetSingle(String nid);

	public AppNewsinfo GetSingleOjb(String nid);

	public String UpdateByMid(AppNewsinfo model);
}
